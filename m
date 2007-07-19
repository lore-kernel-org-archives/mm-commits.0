From: akpm@linux-foundation.org
Subject: - drivers-edac-split-out-functions-to-unique-files.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:17 -0700
Message-ID: <200707192005.l6JK5HP9020034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757187AbXGSURy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: split out functions to unique files
has been removed from the -mm tree.  Its filename was
     drivers-edac-split-out-functions-to-unique-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: split out functions to unique files
From: Douglas Thompson <dougthompson@xmission.com>

This is a large patch to refactor the original EDAC module in the kernel
and to break it up into better file granularity, such that each source
file contains a given subsystem of the EDAC CORE.

Originally, the EDAC 'core' was contained in one source file: edac_mc.c
with it corresponding edac_mc.h file.

Now, there are the following files:

edac_module.c	The main module init/exit function and other overhead
edac_mc.c	Code handling the edac_mc class of object
edac_mc_sysfs.c	Code handling for sysfs presentation
edac_pci_sysfs.c  Code handling for PCI sysfs presentation
edac_core.h	CORE .h include file for 'edac_mc' and 'edac_device' drivers
edac_module.h	Internal CORE .h include file

This forms a foundation upon which a later patch can create the 'edac_device'
class of object code in a new file 'edac_device.c'.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Makefile         |    7 
 drivers/edac/edac_core.h      |  478 +++++++++++
 drivers/edac/edac_mc.c        | 1317 --------------------------------
 drivers/edac/edac_mc.h        |  471 -----------
 drivers/edac/edac_mc_sysfs.c  |  889 +++++++++++++++++++++
 drivers/edac/edac_module.c    |  130 +++
 drivers/edac/edac_module.h    |   55 +
 drivers/edac/edac_pci_sysfs.c |  361 ++++++++
 8 files changed, 1932 insertions(+), 1776 deletions(-)

diff -puN drivers/edac/Makefile~drivers-edac-split-out-functions-to-unique-files drivers/edac/Makefile
--- a/drivers/edac/Makefile~drivers-edac-split-out-functions-to-unique-files
+++ a/drivers/edac/Makefile
@@ -8,7 +8,12 @@
 # $Id: Makefile,v 1.4.2.3 2005/07/08 22:05:38 dsp_llnl Exp $
 
 
-obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_mc.o
+obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
+
+edac_core-objs	:= edac_mc.o edac_mc_sysfs.o edac_pci_sysfs.o
+
+edac_core-objs	+= edac_module.o
+
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_E7XXX)		+= e7xxx_edac.o
 obj-$(CONFIG_EDAC_E752X)		+= e752x_edac.o
diff -puN /dev/null drivers/edac/edac_core.h
--- /dev/null
+++ a/drivers/edac/edac_core.h
@@ -0,0 +1,478 @@
+/*
+ * Defines, structures, APIs for edac_core module
+ *
+ * (C) 2007 Linux Networx (http://lnxi.com)
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ * Written by Thayne Harbaugh
+ * Based on work by Dan Hollis <goemon at anime dot net> and others.
+ *	http://www.anime.net/~goemon/linux-ecc/
+ *
+ * NMI handling support added by
+ *     Dave Peterson <dsp@llnl.gov> <dave_peterson@pobox.com>
+ *
+ * Refactored for multi-source files:
+ *	Doug Thompson <norsk5@xmission.com>
+ *
+ */
+
+#ifndef _EDAC_CORE_H_
+#define _EDAC_CORE_H_
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/pci.h>
+#include <linux/time.h>
+#include <linux/nmi.h>
+#include <linux/rcupdate.h>
+#include <linux/completion.h>
+#include <linux/kobject.h>
+#include <linux/platform_device.h>
+
+#define EDAC_MC_LABEL_LEN	31
+#define MC_PROC_NAME_MAX_LEN 7
+
+#if PAGE_SHIFT < 20
+#define PAGES_TO_MiB( pages )	( ( pages ) >> ( 20 - PAGE_SHIFT ) )
+#else				/* PAGE_SHIFT > 20 */
+#define PAGES_TO_MiB( pages )	( ( pages ) << ( PAGE_SHIFT - 20 ) )
+#endif
+
+#define edac_printk(level, prefix, fmt, arg...) \
+	printk(level "EDAC " prefix ": " fmt, ##arg)
+
+#define edac_mc_printk(mci, level, fmt, arg...) \
+	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
+
+#define edac_mc_chipset_printk(mci, level, prefix, fmt, arg...) \
+	printk(level "EDAC " prefix " MC%d: " fmt, mci->mc_idx, ##arg)
+
+/* prefixes for edac_printk() and edac_mc_printk() */
+#define EDAC_MC "MC"
+#define EDAC_PCI "PCI"
+#define EDAC_DEBUG "DEBUG"
+
+#ifdef CONFIG_EDAC_DEBUG
+extern int edac_debug_level;
+
+#define edac_debug_printk(level, fmt, arg...)                            \
+	do {                                                             \
+		if (level <= edac_debug_level)                           \
+			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
+	} while(0)
+
+#define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
+#define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
+#define debugf2( ... ) edac_debug_printk(2, __VA_ARGS__ )
+#define debugf3( ... ) edac_debug_printk(3, __VA_ARGS__ )
+#define debugf4( ... ) edac_debug_printk(4, __VA_ARGS__ )
+
+#else  /* !CONFIG_EDAC_DEBUG */
+
+#define debugf0( ... )
+#define debugf1( ... )
+#define debugf2( ... )
+#define debugf3( ... )
+#define debugf4( ... )
+
+#endif  /* !CONFIG_EDAC_DEBUG */
+
+#define BIT(x) (1 << (x))
+
+#define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
+	PCI_DEVICE_ID_ ## vend ## _ ## dev
+
+#if defined(CONFIG_X86) && defined(CONFIG_PCI)
+#define dev_name(dev) pci_name(to_pci_dev(dev))
+#else
+#define dev_name(dev) to_platform_device(dev)->name
+#endif
+
+/* memory devices */
+enum dev_type {
+	DEV_UNKNOWN = 0,
+	DEV_X1,
+	DEV_X2,
+	DEV_X4,
+	DEV_X8,
+	DEV_X16,
+	DEV_X32,		/* Do these parts exist? */
+	DEV_X64			/* Do these parts exist? */
+};
+
+#define DEV_FLAG_UNKNOWN	BIT(DEV_UNKNOWN)
+#define DEV_FLAG_X1		BIT(DEV_X1)
+#define DEV_FLAG_X2		BIT(DEV_X2)
+#define DEV_FLAG_X4		BIT(DEV_X4)
+#define DEV_FLAG_X8		BIT(DEV_X8)
+#define DEV_FLAG_X16		BIT(DEV_X16)
+#define DEV_FLAG_X32		BIT(DEV_X32)
+#define DEV_FLAG_X64		BIT(DEV_X64)
+
+/* memory types */
+enum mem_type {
+	MEM_EMPTY = 0,		/* Empty csrow */
+	MEM_RESERVED,		/* Reserved csrow type */
+	MEM_UNKNOWN,		/* Unknown csrow type */
+	MEM_FPM,		/* Fast page mode */
+	MEM_EDO,		/* Extended data out */
+	MEM_BEDO,		/* Burst Extended data out */
+	MEM_SDR,		/* Single data rate SDRAM */
+	MEM_RDR,		/* Registered single data rate SDRAM */
+	MEM_DDR,		/* Double data rate SDRAM */
+	MEM_RDDR,		/* Registered Double data rate SDRAM */
+	MEM_RMBS,		/* Rambus DRAM */
+	MEM_DDR2,               /* DDR2 RAM */
+	MEM_FB_DDR2,            /* fully buffered DDR2 */
+	MEM_RDDR2,              /* Registered DDR2 RAM */
+};
+
+#define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
+#define MEM_FLAG_RESERVED	BIT(MEM_RESERVED)
+#define MEM_FLAG_UNKNOWN	BIT(MEM_UNKNOWN)
+#define MEM_FLAG_FPM		BIT(MEM_FPM)
+#define MEM_FLAG_EDO		BIT(MEM_EDO)
+#define MEM_FLAG_BEDO		BIT(MEM_BEDO)
+#define MEM_FLAG_SDR		BIT(MEM_SDR)
+#define MEM_FLAG_RDR		BIT(MEM_RDR)
+#define MEM_FLAG_DDR		BIT(MEM_DDR)
+#define MEM_FLAG_RDDR		BIT(MEM_RDDR)
+#define MEM_FLAG_RMBS		BIT(MEM_RMBS)
+#define MEM_FLAG_DDR2           BIT(MEM_DDR2)
+#define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
+#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
+
+/* chipset Error Detection and Correction capabilities and mode */
+enum edac_type {
+	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
+	EDAC_NONE,		/* Doesnt support ECC */
+	EDAC_RESERVED,		/* Reserved ECC type */
+	EDAC_PARITY,		/* Detects parity errors */
+	EDAC_EC,		/* Error Checking - no correction */
+	EDAC_SECDED,		/* Single bit error correction, Double detection */
+	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
+	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
+	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
+	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
+};
+
+#define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
+#define EDAC_FLAG_NONE		BIT(EDAC_NONE)
+#define EDAC_FLAG_PARITY	BIT(EDAC_PARITY)
+#define EDAC_FLAG_EC		BIT(EDAC_EC)
+#define EDAC_FLAG_SECDED	BIT(EDAC_SECDED)
+#define EDAC_FLAG_S2ECD2ED	BIT(EDAC_S2ECD2ED)
+#define EDAC_FLAG_S4ECD4ED	BIT(EDAC_S4ECD4ED)
+#define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
+#define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
+
+/* scrubbing capabilities */
+enum scrub_type {
+	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
+	SCRUB_NONE,		/* No scrubber */
+	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
+	SCRUB_SW_SRC,		/* Software scrub only errors */
+	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
+	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
+	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
+	SCRUB_HW_SRC,		/* Hardware scrub only errors */
+	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
+	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
+};
+
+#define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
+#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC_CORR)
+#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC_CORR)
+#define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
+#define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
+#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC_CORR)
+#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC_CORR)
+#define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
+
+/* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
+
+/*
+ * There are several things to be aware of that aren't at all obvious:
+ *
+ *
+ * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
+ *
+ * These are some of the many terms that are thrown about that don't always
+ * mean what people think they mean (Inconceivable!).  In the interest of
+ * creating a common ground for discussion, terms and their definitions
+ * will be established.
+ *
+ * Memory devices:	The individual chip on a memory stick.  These devices
+ *			commonly output 4 and 8 bits each.  Grouping several
+ *			of these in parallel provides 64 bits which is common
+ *			for a memory stick.
+ *
+ * Memory Stick:	A printed circuit board that agregates multiple
+ *			memory devices in parallel.  This is the atomic
+ *			memory component that is purchaseable by Joe consumer
+ *			and loaded into a memory socket.
+ *
+ * Socket:		A physical connector on the motherboard that accepts
+ *			a single memory stick.
+ *
+ * Channel:		Set of memory devices on a memory stick that must be
+ *			grouped in parallel with one or more additional
+ *			channels from other memory sticks.  This parallel
+ *			grouping of the output from multiple channels are
+ *			necessary for the smallest granularity of memory access.
+ *			Some memory controllers are capable of single channel -
+ *			which means that memory sticks can be loaded
+ *			individually.  Other memory controllers are only
+ *			capable of dual channel - which means that memory
+ *			sticks must be loaded as pairs (see "socket set").
+ *
+ * Chip-select row:	All of the memory devices that are selected together.
+ *			for a single, minimum grain of memory access.
+ *			This selects all of the parallel memory devices across
+ *			all of the parallel channels.  Common chip-select rows
+ *			for single channel are 64 bits, for dual channel 128
+ *			bits.
+ *
+ * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memmory.
+ *			Motherboards commonly drive two chip-select pins to
+ *			a memory stick. A single-ranked stick, will occupy
+ *			only one of those rows. The other will be unused.
+ *
+ * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.
+ *
+ * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
+ *			A double-sided stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.  "Double-sided"
+ *			is irrespective of the memory devices being mounted
+ *			on both sides of the memory stick.
+ *
+ * Socket set:		All of the memory sticks that are required for for
+ *			a single memory access or all of the memory sticks
+ *			spanned by a chip-select row.  A single socket set
+ *			has two chip-select rows and if double-sided sticks
+ *			are used these will occupy those chip-select rows.
+ *
+ * Bank:		This term is avoided because it is unclear when
+ *			needing to distinguish between chip-select rows and
+ *			socket sets.
+ *
+ * Controller pages:
+ *
+ * Physical pages:
+ *
+ * Virtual pages:
+ *
+ *
+ * STRUCTURE ORGANIZATION AND CHOICES
+ *
+ *
+ *
+ * PS - I enjoyed writing all that about as much as you enjoyed reading it.
+ */
+
+struct channel_info {
+	int chan_idx;		/* channel index */
+	u32 ce_count;		/* Correctable Errors for this CHANNEL */
+	char label[EDAC_MC_LABEL_LEN + 1];  /* DIMM label on motherboard */
+	struct csrow_info *csrow;	/* the parent */
+};
+
+struct csrow_info {
+	unsigned long first_page;	/* first page number in dimm */
+	unsigned long last_page;	/* last page number in dimm */
+	unsigned long page_mask;	/* used for interleaving -
+					 * 0UL for non intlv
+					 */
+	u32 nr_pages;		/* number of pages in csrow */
+	u32 grain;		/* granularity of reported error in bytes */
+	int csrow_idx;		/* the chip-select row */
+	enum dev_type dtype;	/* memory device type */
+	u32 ue_count;		/* Uncorrectable Errors for this csrow */
+	u32 ce_count;		/* Correctable Errors for this csrow */
+	enum mem_type mtype;	/* memory csrow type */
+	enum edac_type edac_mode;	/* EDAC mode for this csrow */
+	struct mem_ctl_info *mci;	/* the parent */
+
+	struct kobject kobj;	/* sysfs kobject for this csrow */
+	struct completion kobj_complete;
+
+	/* FIXME the number of CHANNELs might need to become dynamic */
+	u32 nr_channels;
+	struct channel_info *channels;
+};
+
+struct mem_ctl_info {
+	struct list_head link;  /* for global list of mem_ctl_info structs */
+	unsigned long mtype_cap;	/* memory types supported by mc */
+	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
+	unsigned long edac_cap;	/* configuration capabilities - this is
+				 * closely related to edac_ctl_cap.  The
+				 * difference is that the controller may be
+				 * capable of s4ecd4ed which would be listed
+				 * in edac_ctl_cap, but if channels aren't
+				 * capable of s4ecd4ed then the edac_cap would
+				 * not have that capability.
+				 */
+	unsigned long scrub_cap;	/* chipset scrub capabilities */
+	enum scrub_type scrub_mode;	/* current scrub mode */
+
+	/* Translates sdram memory scrub rate given in bytes/sec to the
+	   internal representation and configures whatever else needs
+	   to be configured.
+	*/
+	int (*set_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+
+	/* Get the current sdram memory scrub rate from the internal
+	   representation and converts it to the closest matching
+	   bandwith in bytes/sec.
+	*/
+	int (*get_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
+
+	/* pointer to edac checking routine */
+	void (*edac_check) (struct mem_ctl_info * mci);
+
+	/*
+	 * Remaps memory pages: controller pages to physical pages.
+	 * For most MC's, this will be NULL.
+	 */
+	/* FIXME - why not send the phys page to begin with? */
+	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
+					unsigned long page);
+	int mc_idx;
+	int nr_csrows;
+	struct csrow_info *csrows;
+	/*
+	 * FIXME - what about controllers on other busses? - IDs must be
+	 * unique.  dev pointer should be sufficiently unique, but
+	 * BUS:SLOT.FUNC numbers may not be unique.
+	 */
+	struct device *dev;
+	const char *mod_name;
+	const char *mod_ver;
+	const char *ctl_name;
+	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
+	void *pvt_info;
+	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
+	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
+	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
+	u32 ce_count;		/* Total Correctable Errors for this MC */
+	unsigned long start_time;	/* mci load start time (in jiffies) */
+
+	/* this stuff is for safe removal of mc devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	struct rcu_head rcu;
+	struct completion complete;
+
+	/* edac sysfs device control */
+	struct kobject edac_mci_kobj;
+	struct completion kobj_complete;
+};
+
+#ifdef CONFIG_PCI
+
+/* write all or some bits in a byte-register*/
+static inline void pci_write_bits8(struct pci_dev *pdev, int offset, u8 value,
+		u8 mask)
+{
+	if (mask != 0xff) {
+		u8 buf;
+
+		pci_read_config_byte(pdev, offset, &buf);
+		value &= mask;
+		buf &= ~mask;
+		value |= buf;
+	}
+
+	pci_write_config_byte(pdev, offset, value);
+}
+
+/* write all or some bits in a word-register*/
+static inline void pci_write_bits16(struct pci_dev *pdev, int offset,
+		u16 value, u16 mask)
+{
+	if (mask != 0xffff) {
+		u16 buf;
+
+		pci_read_config_word(pdev, offset, &buf);
+		value &= mask;
+		buf &= ~mask;
+		value |= buf;
+	}
+
+	pci_write_config_word(pdev, offset, value);
+}
+
+/* write all or some bits in a dword-register*/
+static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
+		u32 value, u32 mask)
+{
+	if (mask != 0xffff) {
+		u32 buf;
+
+		pci_read_config_dword(pdev, offset, &buf);
+		value &= mask;
+		buf &= ~mask;
+		value |= buf;
+	}
+
+	pci_write_config_dword(pdev, offset, value);
+}
+
+#endif /* CONFIG_PCI */
+
+extern struct mem_ctl_info * edac_mc_find(int idx);
+extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
+extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
+extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
+					unsigned long page);
+
+/*
+ * The no info errors are used when error overflows are reported.
+ * There are a limited number of error logging registers that can
+ * be exausted.  When all registers are exhausted and an additional
+ * error occurs then an error overflow register records that an
+ * error occured and the type of error, but doesn't have any
+ * further information.  The ce/ue versions make for cleaner
+ * reporting logic and function interface - reduces conditional
+ * statement clutter and extra function arguments.
+ */
+extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
+		unsigned long page_frame_number, unsigned long offset_in_page,
+		unsigned long syndrome, int row, int channel,
+		const char *msg);
+extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
+		const char *msg);
+extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
+		unsigned long page_frame_number, unsigned long offset_in_page,
+		int row, const char *msg);
+extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
+		const char *msg);
+extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
+		unsigned int csrow,
+		unsigned int channel0,
+		unsigned int channel1,
+		char *msg);
+extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
+		unsigned int csrow,
+		unsigned int channel,
+		char *msg);
+
+/*
+ * This kmalloc's and initializes all the structures.
+ * Can't be used if all structures don't have the same lifetime.
+ */
+extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
+		unsigned nr_chans);
+
+/* Free an mc previously allocated by edac_mc_alloc() */
+extern void edac_mc_free(struct mem_ctl_info *mci);
+
+#endif				/* _EDAC_CORE_H_ */
diff -puN drivers/edac/edac_mc.c~drivers-edac-split-out-functions-to-unique-files drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-split-out-functions-to-unique-files
+++ a/drivers/edac/edac_mc.c
@@ -27,1197 +27,17 @@
 #include <linux/list.h>
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
 #include "edac_mc.h"
+#include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.1 " __DATE__
-
-
-#ifdef CONFIG_EDAC_DEBUG
-/* Values of 0 to 4 will generate output */
-int edac_debug_level = 1;
-EXPORT_SYMBOL_GPL(edac_debug_level);
-#endif
-
-/* EDAC Controls, setable by module parameter, and sysfs */
-static int log_ue = 1;
-static int log_ce = 1;
-static int panic_on_ue;
-static int poll_msec = 1000;
 
 /* lock to memory controller's control array */
 static DECLARE_MUTEX(mem_ctls_mutex);
 static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
 
-static struct task_struct *edac_thread;
-
-#ifdef CONFIG_PCI
-static int check_pci_parity = 0;	/* default YES check PCI parity */
-static int panic_on_pci_parity;		/* default no panic on PCI Parity */
-static atomic_t pci_parity_count = ATOMIC_INIT(0);
-
-static struct kobject edac_pci_kobj; /* /sys/devices/system/edac/pci */
-static struct completion edac_pci_kobj_complete;
-#endif	/* CONFIG_PCI */
-
-/*  START sysfs data and methods */
-
-
-static const char *mem_types[] = {
-	[MEM_EMPTY] = "Empty",
-	[MEM_RESERVED] = "Reserved",
-	[MEM_UNKNOWN] = "Unknown",
-	[MEM_FPM] = "FPM",
-	[MEM_EDO] = "EDO",
-	[MEM_BEDO] = "BEDO",
-	[MEM_SDR] = "Unbuffered-SDR",
-	[MEM_RDR] = "Registered-SDR",
-	[MEM_DDR] = "Unbuffered-DDR",
-	[MEM_RDDR] = "Registered-DDR",
-	[MEM_RMBS] = "RMBS"
-};
-
-static const char *dev_types[] = {
-	[DEV_UNKNOWN] = "Unknown",
-	[DEV_X1] = "x1",
-	[DEV_X2] = "x2",
-	[DEV_X4] = "x4",
-	[DEV_X8] = "x8",
-	[DEV_X16] = "x16",
-	[DEV_X32] = "x32",
-	[DEV_X64] = "x64"
-};
-
-static const char *edac_caps[] = {
-	[EDAC_UNKNOWN] = "Unknown",
-	[EDAC_NONE] = "None",
-	[EDAC_RESERVED] = "Reserved",
-	[EDAC_PARITY] = "PARITY",
-	[EDAC_EC] = "EC",
-	[EDAC_SECDED] = "SECDED",
-	[EDAC_S2ECD2ED] = "S2ECD2ED",
-	[EDAC_S4ECD4ED] = "S4ECD4ED",
-	[EDAC_S8ECD8ED] = "S8ECD8ED",
-	[EDAC_S16ECD16ED] = "S16ECD16ED"
-};
-
-/* sysfs object: /sys/devices/system/edac */
-static struct sysdev_class edac_class = {
-	set_kset_name("edac"),
-};
-
-/* sysfs object:
- *	/sys/devices/system/edac/mc
- */
-static struct kobject edac_memctrl_kobj;
-
-/* We use these to wait for the reference counts on edac_memctrl_kobj and
- * edac_pci_kobj to reach 0.
- */
-static struct completion edac_memctrl_kobj_complete;
-
-/*
- * /sys/devices/system/edac/mc;
- *	data structures and methods
- */
-static ssize_t memctrl_int_show(void *ptr, char *buffer)
-{
-	int *value = (int*) ptr;
-	return sprintf(buffer, "%u\n", *value);
-}
-
-static ssize_t memctrl_int_store(void *ptr, const char *buffer, size_t count)
-{
-	int *value = (int*) ptr;
-
-	if (isdigit(*buffer))
-		*value = simple_strtoul(buffer, NULL, 0);
-
-	return count;
-}
-
-struct memctrl_dev_attribute {
-	struct attribute attr;
-	void *value;
-	ssize_t (*show)(void *,char *);
-	ssize_t (*store)(void *, const char *, size_t);
-};
-
-/* Set of show/store abstract level functions for memory control object */
-static ssize_t memctrl_dev_show(struct kobject *kobj,
-		struct attribute *attr, char *buffer)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute*)attr;
-
-	if (memctrl_dev->show)
-		return memctrl_dev->show(memctrl_dev->value, buffer);
-
-	return -EIO;
-}
-
-static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
-{
-	struct memctrl_dev_attribute *memctrl_dev;
-	memctrl_dev = (struct memctrl_dev_attribute*)attr;
-
-	if (memctrl_dev->store)
-		return memctrl_dev->store(memctrl_dev->value, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops memctrlfs_ops = {
-	.show   = memctrl_dev_show,
-	.store  = memctrl_dev_store
-};
-
-#define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = &_name,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-#define MEMCTRL_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-static struct memctrl_dev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = _data,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* csrow<id> control files */
-MEMCTRL_ATTR(panic_on_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(log_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(log_ce,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-MEMCTRL_ATTR(poll_msec,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
-
-/* Base Attributes of the memory ECC object */
-static struct memctrl_dev_attribute *memctrl_attr[] = {
-	&attr_panic_on_ue,
-	&attr_log_ue,
-	&attr_log_ce,
-	&attr_poll_msec,
-	NULL,
-};
-
-/* Main MC kobject release() function */
-static void edac_memctrl_master_release(struct kobject *kobj)
-{
-	debugf1("%s()\n", __func__);
-	complete(&edac_memctrl_kobj_complete);
-}
-
-static struct kobj_type ktype_memctrl = {
-	.release = edac_memctrl_master_release,
-	.sysfs_ops = &memctrlfs_ops,
-	.default_attrs = (struct attribute **) memctrl_attr,
-};
-
-/* Initialize the main sysfs entries for edac:
- *   /sys/devices/system/edac
- *
- * and children
- *
- * Return:  0 SUCCESS
- *         !0 FAILURE
- */
-static int edac_sysfs_memctrl_setup(void)
-{
-	int err = 0;
-
-	debugf1("%s()\n", __func__);
-
-	/* create the /sys/devices/system/edac directory */
-	err = sysdev_class_register(&edac_class);
-
-	if (err) {
-		debugf1("%s() error=%d\n", __func__, err);
-		return err;
-	}
-
-	/* Init the MC's kobject */
-	memset(&edac_memctrl_kobj, 0, sizeof (edac_memctrl_kobj));
-	edac_memctrl_kobj.parent = &edac_class.kset.kobj;
-	edac_memctrl_kobj.ktype = &ktype_memctrl;
-
-	/* generate sysfs "..../edac/mc"   */
-	err = kobject_set_name(&edac_memctrl_kobj,"mc");
-
-	if (err)
-		goto fail;
-
-	/* FIXME: maybe new sysdev_create_subdir() */
-	err = kobject_register(&edac_memctrl_kobj);
-
-	if (err) {
-		debugf1("Failed to register '.../edac/mc'\n");
-		goto fail;
-	}
-
-	debugf1("Registered '.../edac/mc' kobject\n");
-
-	return 0;
-
-fail:
-	sysdev_class_unregister(&edac_class);
-	return err;
-}
-
-/*
- * MC teardown:
- *	the '..../edac/mc' kobject followed by '..../edac' itself
- */
-static void edac_sysfs_memctrl_teardown(void)
-{
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
-
-	/* Unregister the MC's kobject and wait for reference count to reach
-	 * 0.
-	 */
-	init_completion(&edac_memctrl_kobj_complete);
-	kobject_unregister(&edac_memctrl_kobj);
-	wait_for_completion(&edac_memctrl_kobj_complete);
-
-	/* Unregister the 'edac' object */
-	sysdev_class_unregister(&edac_class);
-}
-
-#ifdef CONFIG_PCI
-static ssize_t edac_pci_int_show(void *ptr, char *buffer)
-{
-	int *value = ptr;
-	return sprintf(buffer,"%d\n",*value);
-}
-
-static ssize_t edac_pci_int_store(void *ptr, const char *buffer, size_t count)
-{
-	int *value = ptr;
-
-	if (isdigit(*buffer))
-		*value = simple_strtoul(buffer,NULL,0);
-
-	return count;
-}
-
-struct edac_pci_dev_attribute {
-	struct attribute attr;
-	void *value;
-	ssize_t (*show)(void *,char *);
-	ssize_t (*store)(void *, const char *,size_t);
-};
-
-/* Set of show/store abstract level functions for PCI Parity object */
-static ssize_t edac_pci_dev_show(struct kobject *kobj, struct attribute *attr,
-		char *buffer)
-{
-	struct edac_pci_dev_attribute *edac_pci_dev;
-	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
-
-	if (edac_pci_dev->show)
-		return edac_pci_dev->show(edac_pci_dev->value, buffer);
-	return -EIO;
-}
-
-static ssize_t edac_pci_dev_store(struct kobject *kobj,
-		struct attribute *attr, const char *buffer, size_t count)
-{
-	struct edac_pci_dev_attribute *edac_pci_dev;
-	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
-
-	if (edac_pci_dev->show)
-		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
-	return -EIO;
-}
-
-static struct sysfs_ops edac_pci_sysfs_ops = {
-	.show   = edac_pci_dev_show,
-	.store  = edac_pci_dev_store
-};
-
-#define EDAC_PCI_ATTR(_name,_mode,_show,_store)			\
-static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = &_name,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-#define EDAC_PCI_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.value  = _data,					\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* PCI Parity control files */
-EDAC_PCI_ATTR(check_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
-EDAC_PCI_ATTR(panic_on_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
-	edac_pci_int_store);
-EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
-
-/* Base Attributes of the memory ECC object */
-static struct edac_pci_dev_attribute *edac_pci_attr[] = {
-	&edac_pci_attr_check_pci_parity,
-	&edac_pci_attr_panic_on_pci_parity,
-	&edac_pci_attr_pci_parity_count,
-	NULL,
-};
-
-/* No memory to release */
-static void edac_pci_release(struct kobject *kobj)
-{
-	debugf1("%s()\n", __func__);
-	complete(&edac_pci_kobj_complete);
-}
-
-static struct kobj_type ktype_edac_pci = {
-	.release = edac_pci_release,
-	.sysfs_ops = &edac_pci_sysfs_ops,
-	.default_attrs = (struct attribute **) edac_pci_attr,
-};
-
-/**
- * edac_sysfs_pci_setup()
- *
- */
-static int edac_sysfs_pci_setup(void)
-{
-	int err;
-
-	debugf1("%s()\n", __func__);
-
-	memset(&edac_pci_kobj, 0, sizeof(edac_pci_kobj));
-	edac_pci_kobj.parent = &edac_class.kset.kobj;
-	edac_pci_kobj.ktype = &ktype_edac_pci;
-	err = kobject_set_name(&edac_pci_kobj, "pci");
-
-	if (!err) {
-		/* Instanstiate the csrow object */
-		/* FIXME: maybe new sysdev_create_subdir() */
-		err = kobject_register(&edac_pci_kobj);
-
-		if (err)
-			debugf1("Failed to register '.../edac/pci'\n");
-		else
-			debugf1("Registered '.../edac/pci' kobject\n");
-	}
-
-	return err;
-}
-
-static void edac_sysfs_pci_teardown(void)
-{
-	debugf0("%s()\n", __func__);
-	init_completion(&edac_pci_kobj_complete);
-	kobject_unregister(&edac_pci_kobj);
-	wait_for_completion(&edac_pci_kobj_complete);
-}
-
-
-static u16 get_pci_parity_status(struct pci_dev *dev, int secondary)
-{
-	int where;
-	u16 status;
-
-	where = secondary ? PCI_SEC_STATUS : PCI_STATUS;
-	pci_read_config_word(dev, where, &status);
-
-	/* If we get back 0xFFFF then we must suspect that the card has been
-	 * pulled but the Linux PCI layer has not yet finished cleaning up.
-	 * We don't want to report on such devices
-	 */
-
-	if (status == 0xFFFF) {
-		u32 sanity;
-
-		pci_read_config_dword(dev, 0, &sanity);
-
-		if (sanity == 0xFFFFFFFF)
-			return 0;
-	}
-
-	status &= PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR |
-		PCI_STATUS_PARITY;
-
-	if (status)
-		/* reset only the bits we are interested in */
-		pci_write_config_word(dev, where, status);
-
-	return status;
-}
-
-typedef void (*pci_parity_check_fn_t) (struct pci_dev *dev);
-
-/* Clear any PCI parity errors logged by this device. */
-static void edac_pci_dev_parity_clear(struct pci_dev *dev)
-{
-	u8 header_type;
-
-	get_pci_parity_status(dev, 0);
-
-	/* read the device TYPE, looking for bridges */
-	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
-
-	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE)
-		get_pci_parity_status(dev, 1);
-}
-
-/*
- *  PCI Parity polling
- *
- */
-static void edac_pci_dev_parity_test(struct pci_dev *dev)
-{
-	u16 status;
-	u8  header_type;
-
-	/* read the STATUS register on this device
-	 */
-	status = get_pci_parity_status(dev, 0);
-
-	debugf2("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id );
-
-	/* check the status reg for errors */
-	if (status) {
-		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
-			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Signaled System Error on %s\n",
-				pci_name(dev));
-
-		if (status & (PCI_STATUS_PARITY)) {
-			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Master Data Parity Error on %s\n",
-				pci_name(dev));
-
-			atomic_inc(&pci_parity_count);
-		}
-
-		if (status & (PCI_STATUS_DETECTED_PARITY)) {
-			edac_printk(KERN_CRIT, EDAC_PCI,
-				"Detected Parity Error on %s\n",
-				pci_name(dev));
-
-			atomic_inc(&pci_parity_count);
-		}
-	}
-
-	/* read the device TYPE, looking for bridges */
-	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
-
-	debugf2("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id );
-
-	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
-		/* On bridges, need to examine secondary status register  */
-		status = get_pci_parity_status(dev, 1);
-
-		debugf2("PCI SEC_STATUS= 0x%04x %s\n",
-				status, dev->dev.bus_id );
-
-		/* check the secondary status reg for errors */
-		if (status) {
-			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
-				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Signaled System Error on %s\n",
-					pci_name(dev));
-
-			if (status & (PCI_STATUS_PARITY)) {
-				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Master Data Parity Error on "
-					"%s\n", pci_name(dev));
-
-				atomic_inc(&pci_parity_count);
-			}
-
-			if (status & (PCI_STATUS_DETECTED_PARITY)) {
-				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					"Detected Parity Error on %s\n",
-					pci_name(dev));
-
-				atomic_inc(&pci_parity_count);
-			}
-		}
-	}
-}
-
-/*
- * pci_dev parity list iterator
- *	Scan the PCI device list for one iteration, looking for SERRORs
- *	Master Parity ERRORS or Parity ERRORs on primary or secondary devices
- */
-static inline void edac_pci_dev_parity_iterator(pci_parity_check_fn_t fn)
-{
-	struct pci_dev *dev = NULL;
-
-	/* request for kernel access to the next PCI device, if any,
-	 * and while we are looking at it have its reference count
-	 * bumped until we are done with it
-	 */
-	while((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		fn(dev);
-	}
-}
-
-static void do_pci_parity_check(void)
-{
-	unsigned long flags;
-	int before_count;
-
-	debugf3("%s()\n", __func__);
-
-	if (!check_pci_parity)
-		return;
-
-	before_count = atomic_read(&pci_parity_count);
-
-	/* scan all PCI devices looking for a Parity Error on devices and
-	 * bridges
-	 */
-	local_irq_save(flags);
-	edac_pci_dev_parity_iterator(edac_pci_dev_parity_test);
-	local_irq_restore(flags);
-
-	/* Only if operator has selected panic on PCI Error */
-	if (panic_on_pci_parity) {
-		/* If the count is different 'after' from 'before' */
-		if (before_count != atomic_read(&pci_parity_count))
-			panic("EDAC: PCI Parity Error");
-	}
-}
-
-static inline void clear_pci_parity_errors(void)
-{
-	/* Clear any PCI bus parity errors that devices initially have logged
-	 * in their registers.
-	 */
-	edac_pci_dev_parity_iterator(edac_pci_dev_parity_clear);
-}
-
-#else	/* CONFIG_PCI */
-
-/* pre-process these away */
-#define	do_pci_parity_check()
-#define	clear_pci_parity_errors()
-#define	edac_sysfs_pci_teardown()
-#define	edac_sysfs_pci_setup()	(0)
-
-#endif	/* CONFIG_PCI */
-
-/* EDAC sysfs CSROW data structures and methods
- */
-
-/* Set of more default csrow<id> attribute show/store functions */
-static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%u\n", csrow->ue_count);
-}
-
-static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%u\n", csrow->ce_count);
-}
-
-static ssize_t csrow_size_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%u\n", PAGES_TO_MiB(csrow->nr_pages));
-}
-
-static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%s\n", mem_types[csrow->mtype]);
-}
-
-static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%s\n", dev_types[csrow->dtype]);
-}
-
-static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data, int private)
-{
-	return sprintf(data,"%s\n", edac_caps[csrow->edac_mode]);
-}
-
-/* show/store functions for DIMM Label attributes */
-static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
-		char *data, int channel)
-{
-	return snprintf(data, EDAC_MC_LABEL_LEN,"%s",
-			csrow->channels[channel].label);
-}
-
-static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
-				const char *data,
-				size_t count,
-				int channel)
-{
-	ssize_t max_size = 0;
-
-	max_size = min((ssize_t)count,(ssize_t)EDAC_MC_LABEL_LEN-1);
-	strncpy(csrow->channels[channel].label, data, max_size);
-	csrow->channels[channel].label[max_size] = '\0';
-
-	return max_size;
-}
-
-/* show function for dynamic chX_ce_count attribute */
-static ssize_t channel_ce_count_show(struct csrow_info *csrow,
-				char *data,
-				int channel)
-{
-	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
-}
-
-/* csrow specific attribute structure */
-struct csrowdev_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct csrow_info *,char *,int);
-	ssize_t (*store)(struct csrow_info *, const char *,size_t,int);
-	int    private;
-};
-
-#define to_csrow(k) container_of(k, struct csrow_info, kobj)
-#define to_csrowdev_attr(a) container_of(a, struct csrowdev_attribute, attr)
-
-/* Set of show/store higher level functions for default csrow attributes */
-static ssize_t csrowdev_show(struct kobject *kobj,
-			struct attribute *attr,
-			char *buffer)
-{
-	struct csrow_info *csrow = to_csrow(kobj);
-	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
-
-	if (csrowdev_attr->show)
-		return csrowdev_attr->show(csrow,
-					buffer,
-					csrowdev_attr->private);
-	return -EIO;
-}
-
-static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
-{
-	struct csrow_info *csrow = to_csrow(kobj);
-	struct csrowdev_attribute * csrowdev_attr = to_csrowdev_attr(attr);
-
-	if (csrowdev_attr->store)
-		return csrowdev_attr->store(csrow,
-					buffer,
-					count,
-					csrowdev_attr->private);
-	return -EIO;
-}
-
-static struct sysfs_ops csrowfs_ops = {
-	.show   = csrowdev_show,
-	.store  = csrowdev_store
-};
-
-#define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
-static struct csrowdev_attribute attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-	.private = _private,					\
-};
-
-/* default cwrow<id>/attribute files */
-CSROWDEV_ATTR(size_mb,S_IRUGO,csrow_size_show,NULL,0);
-CSROWDEV_ATTR(dev_type,S_IRUGO,csrow_dev_type_show,NULL,0);
-CSROWDEV_ATTR(mem_type,S_IRUGO,csrow_mem_type_show,NULL,0);
-CSROWDEV_ATTR(edac_mode,S_IRUGO,csrow_edac_mode_show,NULL,0);
-CSROWDEV_ATTR(ue_count,S_IRUGO,csrow_ue_count_show,NULL,0);
-CSROWDEV_ATTR(ce_count,S_IRUGO,csrow_ce_count_show,NULL,0);
-
-/* default attributes of the CSROW<id> object */
-static struct csrowdev_attribute *default_csrow_attr[] = {
-	&attr_dev_type,
-	&attr_mem_type,
-	&attr_edac_mode,
-	&attr_size_mb,
-	&attr_ue_count,
-	&attr_ce_count,
-	NULL,
-};
-
-
-/* possible dynamic channel DIMM Label attribute files */
-CSROWDEV_ATTR(ch0_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		0 );
-CSROWDEV_ATTR(ch1_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		1 );
-CSROWDEV_ATTR(ch2_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		2 );
-CSROWDEV_ATTR(ch3_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		3 );
-CSROWDEV_ATTR(ch4_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		4 );
-CSROWDEV_ATTR(ch5_dimm_label,S_IRUGO|S_IWUSR,
-		channel_dimm_label_show,
-		channel_dimm_label_store,
-		5 );
-
-/* Total possible dynamic DIMM Label attribute file table */
-static struct csrowdev_attribute *dynamic_csrow_dimm_attr[] = {
-		&attr_ch0_dimm_label,
-		&attr_ch1_dimm_label,
-		&attr_ch2_dimm_label,
-		&attr_ch3_dimm_label,
-		&attr_ch4_dimm_label,
-		&attr_ch5_dimm_label
-};
-
-/* possible dynamic channel ce_count attribute files */
-CSROWDEV_ATTR(ch0_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		0 );
-CSROWDEV_ATTR(ch1_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		1 );
-CSROWDEV_ATTR(ch2_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		2 );
-CSROWDEV_ATTR(ch3_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		3 );
-CSROWDEV_ATTR(ch4_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		4 );
-CSROWDEV_ATTR(ch5_ce_count,S_IRUGO|S_IWUSR,
-		channel_ce_count_show,
-		NULL,
-		5 );
-
-/* Total possible dynamic ce_count attribute file table */
-static struct csrowdev_attribute *dynamic_csrow_ce_count_attr[] = {
-		&attr_ch0_ce_count,
-		&attr_ch1_ce_count,
-		&attr_ch2_ce_count,
-		&attr_ch3_ce_count,
-		&attr_ch4_ce_count,
-		&attr_ch5_ce_count
-};
-
-
-#define EDAC_NR_CHANNELS	6
-
-/* Create dynamic CHANNEL files, indexed by 'chan',  under specifed CSROW */
-static int edac_create_channel_files(struct kobject *kobj, int chan)
-{
-	int err=-ENODEV;
-
-	if (chan >= EDAC_NR_CHANNELS)
-		return err;
-
-	/* create the DIMM label attribute file */
-	err = sysfs_create_file(kobj,
-			(struct attribute *) dynamic_csrow_dimm_attr[chan]);
-
-	if (!err) {
-		/* create the CE Count attribute file */
-		err = sysfs_create_file(kobj,
-			(struct attribute *) dynamic_csrow_ce_count_attr[chan]);
-	} else {
-		debugf1("%s()  dimm labels and ce_count files created", __func__);
-	}
-
-	return err;
-}
-
-/* No memory to release for this kobj */
-static void edac_csrow_instance_release(struct kobject *kobj)
-{
-	struct csrow_info *cs;
-
-	cs = container_of(kobj, struct csrow_info, kobj);
-	complete(&cs->kobj_complete);
-}
-
-/* the kobj_type instance for a CSROW */
-static struct kobj_type ktype_csrow = {
-	.release = edac_csrow_instance_release,
-	.sysfs_ops = &csrowfs_ops,
-	.default_attrs = (struct attribute **) default_csrow_attr,
-};
-
-/* Create a CSROW object under specifed edac_mc_device */
-static int edac_create_csrow_object(
-		struct kobject *edac_mci_kobj,
-		struct csrow_info *csrow,
-		int index)
-{
-	int err = 0;
-	int chan;
-
-	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
-
-	/* generate ..../edac/mc/mc<id>/csrow<index>   */
-
-	csrow->kobj.parent = edac_mci_kobj;
-	csrow->kobj.ktype = &ktype_csrow;
-
-	/* name this instance of csrow<id> */
-	err = kobject_set_name(&csrow->kobj,"csrow%d",index);
-	if (err)
-		goto error_exit;
-
-	/* Instanstiate the csrow object */
-	err = kobject_register(&csrow->kobj);
-	if (!err) {
-		/* Create the dyanmic attribute files on this csrow,
-		 * namely, the DIMM labels and the channel ce_count
-		 */
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			err = edac_create_channel_files(&csrow->kobj,chan);
-			if (err)
-				break;
-		}
-	}
-
-error_exit:
-	return err;
-}
-
-/* default sysfs methods and data structures for the main MCI kobject */
-
-static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
-		const char *data, size_t count)
-{
-	int row, chan;
-
-	mci->ue_noinfo_count = 0;
-	mci->ce_noinfo_count = 0;
-	mci->ue_count = 0;
-	mci->ce_count = 0;
-
-	for (row = 0; row < mci->nr_csrows; row++) {
-		struct csrow_info *ri = &mci->csrows[row];
-
-		ri->ue_count = 0;
-		ri->ce_count = 0;
-
-		for (chan = 0; chan < ri->nr_channels; chan++)
-			ri->channels[chan].ce_count = 0;
-	}
-
-	mci->start_time = jiffies;
-	return count;
-}
-
-/* memory scrubbing */
-static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
-					const char *data, size_t count)
-{
-	u32 bandwidth = -1;
-
-	if (mci->set_sdram_scrub_rate) {
-
-		memctrl_int_store(&bandwidth, data, count);
-
-		if (!(*mci->set_sdram_scrub_rate)(mci, &bandwidth)) {
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set successfully, applied: %d\n",
-				bandwidth);
-		} else {
-			/* FIXME: error codes maybe? */
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate set FAILED, could not apply: %d\n",
-				bandwidth);
-		}
-	} else {
-		/* FIXME: produce "not implemented" ERROR for user-side. */
-		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'set'control is not implemented!\n");
-	}
-	return count;
-}
-
-static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
-{
-	u32 bandwidth = -1;
-
-	if (mci->get_sdram_scrub_rate) {
-		if (!(*mci->get_sdram_scrub_rate)(mci, &bandwidth)) {
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate successfully, fetched: %d\n",
-				bandwidth);
-		} else {
-			/* FIXME: error codes maybe? */
-			edac_printk(KERN_DEBUG, EDAC_MC,
-				"Scrub rate fetch FAILED, got: %d\n",
-				bandwidth);
-		}
-	} else {
-		/* FIXME: produce "not implemented" ERROR for user-side.  */
-		edac_printk(KERN_WARNING, EDAC_MC,
-			"Memory scrubbing 'get' control is not implemented!\n");
-	}
-	return sprintf(data, "%d\n", bandwidth);
-}
-
-/* default attribute files for the MCI object */
-static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%d\n", mci->ue_count);
-}
-
-static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%d\n", mci->ce_count);
-}
-
-static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%d\n", mci->ce_noinfo_count);
-}
-
-static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%d\n", mci->ue_noinfo_count);
-}
-
-static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%ld\n", (jiffies - mci->start_time) / HZ);
-}
-
-static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
-{
-	return sprintf(data,"%s\n", mci->ctl_name);
-}
-
-static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
-{
-	int total_pages, csrow_idx;
-
-	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
-			csrow_idx++) {
-		struct csrow_info *csrow = &mci->csrows[csrow_idx];
-
-		if (!csrow->nr_pages)
-			continue;
-
-		total_pages += csrow->nr_pages;
-	}
-
-	return sprintf(data,"%u\n", PAGES_TO_MiB(total_pages));
-}
-
-struct mcidev_attribute {
-	struct attribute attr;
-	ssize_t (*show)(struct mem_ctl_info *,char *);
-	ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
-};
-
-#define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
-#define to_mcidev_attr(a) container_of(a, struct mcidev_attribute, attr)
-
-/* MCI show/store functions for top most object */
-static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
-		char *buffer)
-{
-	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
-
-	if (mcidev_attr->show)
-		return mcidev_attr->show(mem_ctl_info, buffer);
-
-	return -EIO;
-}
-
-static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
-		const char *buffer, size_t count)
-{
-	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
-	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
-
-	if (mcidev_attr->store)
-		return mcidev_attr->store(mem_ctl_info, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops mci_ops = {
-	.show = mcidev_show,
-	.store = mcidev_store
-};
-
-#define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-static struct mcidev_attribute mci_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* default Control file */
-MCIDEV_ATTR(reset_counters,S_IWUSR,NULL,mci_reset_counters_store);
-
-/* default Attribute files */
-MCIDEV_ATTR(mc_name,S_IRUGO,mci_ctl_name_show,NULL);
-MCIDEV_ATTR(size_mb,S_IRUGO,mci_size_mb_show,NULL);
-MCIDEV_ATTR(seconds_since_reset,S_IRUGO,mci_seconds_show,NULL);
-MCIDEV_ATTR(ue_noinfo_count,S_IRUGO,mci_ue_noinfo_show,NULL);
-MCIDEV_ATTR(ce_noinfo_count,S_IRUGO,mci_ce_noinfo_show,NULL);
-MCIDEV_ATTR(ue_count,S_IRUGO,mci_ue_count_show,NULL);
-MCIDEV_ATTR(ce_count,S_IRUGO,mci_ce_count_show,NULL);
-
-/* memory scrubber attribute file */
-MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,mci_sdram_scrub_rate_store);
-
-static struct mcidev_attribute *mci_attr[] = {
-	&mci_attr_reset_counters,
-	&mci_attr_mc_name,
-	&mci_attr_size_mb,
-	&mci_attr_seconds_since_reset,
-	&mci_attr_ue_noinfo_count,
-	&mci_attr_ce_noinfo_count,
-	&mci_attr_ue_count,
-	&mci_attr_ce_count,
-	&mci_attr_sdram_scrub_rate,
-	NULL
-};
-
-/*
- * Release of a MC controlling instance
- */
-static void edac_mci_instance_release(struct kobject *kobj)
-{
-	struct mem_ctl_info *mci;
-
-	mci = to_mci(kobj);
-	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
-	complete(&mci->kobj_complete);
-}
-
-static struct kobj_type ktype_mci = {
-	.release = edac_mci_instance_release,
-	.sysfs_ops = &mci_ops,
-	.default_attrs = (struct attribute **) mci_attr,
-};
-
-
-#define EDAC_DEVICE_SYMLINK	"device"
-
-/*
- * Create a new Memory Controller kobject instance,
- *	mc<id> under the 'mc' directory
- *
- * Return:
- *	0	Success
- *	!0	Failure
- */
-static int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
-{
-	int i;
-	int err;
-	struct csrow_info *csrow;
-	struct kobject *edac_mci_kobj=&mci->edac_mci_kobj;
-
-	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
-	memset(edac_mci_kobj, 0, sizeof(*edac_mci_kobj));
-
-	/* set the name of the mc<id> object */
-	err = kobject_set_name(edac_mci_kobj,"mc%d",mci->mc_idx);
-	if (err)
-		return err;
-
-	/* link to our parent the '..../edac/mc' object */
-	edac_mci_kobj->parent = &edac_memctrl_kobj;
-	edac_mci_kobj->ktype = &ktype_mci;
-
-	/* register the mc<id> kobject */
-	err = kobject_register(edac_mci_kobj);
-	if (err)
-		return err;
-
-	/* create a symlink for the device */
-	err = sysfs_create_link(edac_mci_kobj, &mci->dev->kobj,
-				EDAC_DEVICE_SYMLINK);
-	if (err)
-		goto fail0;
-
-	/* Make directories for each CSROW object
-	 * under the mc<id> kobject
-	 */
-	for (i = 0; i < mci->nr_csrows; i++) {
-		csrow = &mci->csrows[i];
-
-		/* Only expose populated CSROWs */
-		if (csrow->nr_pages > 0) {
-			err = edac_create_csrow_object(edac_mci_kobj,csrow,i);
-			if (err)
-				goto fail1;
-		}
-	}
-
-	return 0;
-
-	/* CSROW error: backout what has already been registered,  */
-fail1:
-	for ( i--; i >= 0; i--) {
-		if (csrow->nr_pages > 0) {
-			init_completion(&csrow->kobj_complete);
-			kobject_unregister(&mci->csrows[i].kobj);
-			wait_for_completion(&csrow->kobj_complete);
-		}
-	}
-
-fail0:
-	init_completion(&mci->kobj_complete);
-	kobject_unregister(edac_mci_kobj);
-	wait_for_completion(&mci->kobj_complete);
-	return err;
-}
-
-/*
- * remove a Memory Controller instance
- */
-static void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
-{
-	int i;
-
-	debugf0("%s()\n", __func__);
-
-	/* remove all csrow kobjects */
-	for (i = 0; i < mci->nr_csrows; i++) {
-		if (mci->csrows[i].nr_pages > 0) {
-			init_completion(&mci->csrows[i].kobj_complete);
-			kobject_unregister(&mci->csrows[i].kobj);
-			wait_for_completion(&mci->csrows[i].kobj_complete);
-		}
-	}
-
-	sysfs_remove_link(&mci->edac_mci_kobj, EDAC_DEVICE_SYMLINK);
-	init_completion(&mci->kobj_complete);
-	kobject_unregister(&mci->edac_mci_kobj);
-	wait_for_completion(&mci->kobj_complete);
-}
-
-/* END OF sysfs data and methods */
-
 #ifdef CONFIG_EDAC_DEBUG
 
 static void edac_mc_dump_channel(struct channel_info *chan)
@@ -1672,7 +492,7 @@ void edac_mc_handle_ce(struct mem_ctl_in
 		return;
 	}
 
-	if (log_ce)
+	if (edac_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
@@ -1707,7 +527,7 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	if (log_ce)
+	if (edac_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE - no information available: %s\n", msg);
 
@@ -1751,14 +571,14 @@ void edac_mc_handle_ue(struct mem_ctl_in
 		pos += chars;
 	}
 
-	if (log_ue)
+	if (edac_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
 			"labels \"%s\": %s\n", page_frame_number,
 			offset_in_page, mci->csrows[row].grain, row, labels,
 			msg);
 
-	if (panic_on_ue)
+	if (edac_get_panic_on_ue())
 		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
 			"row %d, labels \"%s\": %s\n", mci->mc_idx,
 			page_frame_number, offset_in_page,
@@ -1771,10 +591,10 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	if (panic_on_ue)
+	if (edac_get_panic_on_ue())
 		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
 
-	if (log_ue)
+	if (edac_get_log_ue())
 		edac_mc_printk(mci, KERN_WARNING,
 			"UE - no information available: %s\n", msg);
 	mci->ue_noinfo_count++;
@@ -1837,13 +657,13 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	chars = snprintf(pos, len + 1, "-%s",
 			 mci->csrows[csrow].channels[channelb].label);
 
-	if (log_ue)
+	if (edac_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE row %d, channel-a= %d channel-b= %d "
 			"labels \"%s\": %s\n", csrow, channela, channelb,
 			labels, msg);
 
-	if (panic_on_ue)
+	if (edac_get_panic_on_ue())
 		panic("UE row %d, channel-a= %d channel-b= %d "
 				"labels \"%s\": %s\n", csrow, channela,
 				channelb, labels, msg);
@@ -1878,7 +698,7 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 		return;
 	}
 
-	if (log_ce)
+	if (edac_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE row %d, channel %d, label \"%s\": %s\n",
@@ -1896,7 +716,7 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
 /*
  * Iterate over all MC instances and check for ECC, et al, errors
  */
-static inline void check_mc_devices(void)
+void edac_check_mc_devices(void)
 {
 	struct list_head *item;
 	struct mem_ctl_info *mci;
@@ -1913,118 +733,3 @@ static inline void check_mc_devices(void
 
 	up(&mem_ctls_mutex);
 }
-
-/*
- * Check MC status every poll_msec.
- * Check PCI status every poll_msec as well.
- *
- * This where the work gets done for edac.
- *
- * SMP safe, doesn't use NMI, and auto-rate-limits.
- */
-static void do_edac_check(void)
-{
-	debugf3("%s()\n", __func__);
-	check_mc_devices();
-	do_pci_parity_check();
-}
-
-static int edac_kernel_thread(void *arg)
-{
-	set_freezable();
-	while (!kthread_should_stop()) {
-		do_edac_check();
-
-		/* goto sleep for the interval */
-		schedule_timeout_interruptible((HZ * poll_msec) / 1000);
-		try_to_freeze();
-	}
-
-	return 0;
-}
-
-/*
- * edac_mc_init
- *      module initialization entry point
- */
-static int __init edac_mc_init(void)
-{
-	edac_printk(KERN_INFO, EDAC_MC, EDAC_MC_VERSION "\n");
-
-	/*
-	 * Harvest and clear any boot/initialization PCI parity errors
-	 *
-	 * FIXME: This only clears errors logged by devices present at time of
-	 * 	module initialization.  We should also do an initial clear
-	 *	of each newly hotplugged device.
-	 */
-	clear_pci_parity_errors();
-
-	/* Create the MC sysfs entries */
-	if (edac_sysfs_memctrl_setup()) {
-		edac_printk(KERN_ERR, EDAC_MC,
-			"Error initializing sysfs code\n");
-		return -ENODEV;
-	}
-
-	/* Create the PCI parity sysfs entries */
-	if (edac_sysfs_pci_setup()) {
-		edac_sysfs_memctrl_teardown();
-		edac_printk(KERN_ERR, EDAC_MC,
-			"EDAC PCI: Error initializing sysfs code\n");
-		return -ENODEV;
-	}
-
-	/* create our kernel thread */
-	edac_thread = kthread_run(edac_kernel_thread, NULL, "kedac");
-
-	if (IS_ERR(edac_thread)) {
-		/* remove the sysfs entries */
-		edac_sysfs_memctrl_teardown();
-		edac_sysfs_pci_teardown();
-		return PTR_ERR(edac_thread);
-	}
-
-	return 0;
-}
-
-/*
- * edac_mc_exit()
- *      module exit/termination functioni
- */
-static void __exit edac_mc_exit(void)
-{
-	debugf0("%s()\n", __func__);
-	kthread_stop(edac_thread);
-
-	/* tear down the sysfs device */
-	edac_sysfs_memctrl_teardown();
-	edac_sysfs_pci_teardown();
-}
-
-module_init(edac_mc_init);
-module_exit(edac_mc_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh et al\n"
-	"Based on work by Dan Hollis et al");
-MODULE_DESCRIPTION("Core library routines for MC reporting");
-
-module_param(panic_on_ue, int, 0644);
-MODULE_PARM_DESC(panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
-#ifdef CONFIG_PCI
-module_param(check_pci_parity, int, 0644);
-MODULE_PARM_DESC(check_pci_parity, "Check for PCI bus parity errors: 0=off 1=on");
-module_param(panic_on_pci_parity, int, 0644);
-MODULE_PARM_DESC(panic_on_pci_parity, "Panic on PCI Bus Parity error: 0=off 1=on");
-#endif
-module_param(log_ue, int, 0644);
-MODULE_PARM_DESC(log_ue, "Log uncorrectable error to console: 0=off 1=on");
-module_param(log_ce, int, 0644);
-MODULE_PARM_DESC(log_ce, "Log correctable error to console: 0=off 1=on");
-module_param(poll_msec, int, 0644);
-MODULE_PARM_DESC(poll_msec, "Polling period in milliseconds");
-#ifdef CONFIG_EDAC_DEBUG
-module_param(edac_debug_level, int, 0644);
-MODULE_PARM_DESC(edac_debug_level, "Debug level");
-#endif
diff -puN drivers/edac/edac_mc.h~drivers-edac-split-out-functions-to-unique-files drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-split-out-functions-to-unique-files
+++ a/drivers/edac/edac_mc.h
@@ -1,476 +1,9 @@
-/*
- * MC kernel module
- * (C) 2003 Linux Networx (http://lnxi.com)
- * This file may be distributed under the terms of the
- * GNU General Public License.
- *
- * Written by Thayne Harbaugh
- * Based on work by Dan Hollis <goemon at anime dot net> and others.
- *	http://www.anime.net/~goemon/linux-ecc/
- *
- * NMI handling support added by
- *     Dave Peterson <dsp@llnl.gov> <dave_peterson@pobox.com>
- *
- * $Id: edac_mc.h,v 1.4.2.10 2005/10/05 00:43:44 dsp_llnl Exp $
- *
- */
-
-#ifndef _EDAC_MC_H_
-#define _EDAC_MC_H_
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/pci.h>
-#include <linux/time.h>
-#include <linux/nmi.h>
-#include <linux/rcupdate.h>
-#include <linux/completion.h>
-#include <linux/kobject.h>
-#include <linux/platform_device.h>
-
-#define EDAC_MC_LABEL_LEN	31
-#define MC_PROC_NAME_MAX_LEN 7
-
-#if PAGE_SHIFT < 20
-#define PAGES_TO_MiB( pages )	( ( pages ) >> ( 20 - PAGE_SHIFT ) )
-#else				/* PAGE_SHIFT > 20 */
-#define PAGES_TO_MiB( pages )	( ( pages ) << ( PAGE_SHIFT - 20 ) )
-#endif
-
-#define edac_printk(level, prefix, fmt, arg...) \
-	printk(level "EDAC " prefix ": " fmt, ##arg)
-
-#define edac_mc_printk(mci, level, fmt, arg...) \
-	printk(level "EDAC MC%d: " fmt, mci->mc_idx, ##arg)
-
-#define edac_mc_chipset_printk(mci, level, prefix, fmt, arg...) \
-	printk(level "EDAC " prefix " MC%d: " fmt, mci->mc_idx, ##arg)
-
-/* prefixes for edac_printk() and edac_mc_printk() */
-#define EDAC_MC "MC"
-#define EDAC_PCI "PCI"
-#define EDAC_DEBUG "DEBUG"
-
-#ifdef CONFIG_EDAC_DEBUG
-extern int edac_debug_level;
-
-#define edac_debug_printk(level, fmt, arg...)                            \
-	do {                                                             \
-		if (level <= edac_debug_level)                           \
-			edac_printk(KERN_DEBUG, EDAC_DEBUG, fmt, ##arg); \
-	} while(0)
-
-#define debugf0( ... ) edac_debug_printk(0, __VA_ARGS__ )
-#define debugf1( ... ) edac_debug_printk(1, __VA_ARGS__ )
-#define debugf2( ... ) edac_debug_printk(2, __VA_ARGS__ )
-#define debugf3( ... ) edac_debug_printk(3, __VA_ARGS__ )
-#define debugf4( ... ) edac_debug_printk(4, __VA_ARGS__ )
-
-#else  /* !CONFIG_EDAC_DEBUG */
-
-#define debugf0( ... )
-#define debugf1( ... )
-#define debugf2( ... )
-#define debugf3( ... )
-#define debugf4( ... )
-
-#endif  /* !CONFIG_EDAC_DEBUG */
 
-#define BIT(x) (1 << (x))
-
-#define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
-	PCI_DEVICE_ID_ ## vend ## _ ## dev
-
-#if defined(CONFIG_X86) && defined(CONFIG_PCI)
-#define dev_name(dev) pci_name(to_pci_dev(dev))
-#else
-#define dev_name(dev) to_platform_device(dev)->name
-#endif
-
-/* memory devices */
-enum dev_type {
-	DEV_UNKNOWN = 0,
-	DEV_X1,
-	DEV_X2,
-	DEV_X4,
-	DEV_X8,
-	DEV_X16,
-	DEV_X32,		/* Do these parts exist? */
-	DEV_X64			/* Do these parts exist? */
-};
-
-#define DEV_FLAG_UNKNOWN	BIT(DEV_UNKNOWN)
-#define DEV_FLAG_X1		BIT(DEV_X1)
-#define DEV_FLAG_X2		BIT(DEV_X2)
-#define DEV_FLAG_X4		BIT(DEV_X4)
-#define DEV_FLAG_X8		BIT(DEV_X8)
-#define DEV_FLAG_X16		BIT(DEV_X16)
-#define DEV_FLAG_X32		BIT(DEV_X32)
-#define DEV_FLAG_X64		BIT(DEV_X64)
-
-/* memory types */
-enum mem_type {
-	MEM_EMPTY = 0,		/* Empty csrow */
-	MEM_RESERVED,		/* Reserved csrow type */
-	MEM_UNKNOWN,		/* Unknown csrow type */
-	MEM_FPM,		/* Fast page mode */
-	MEM_EDO,		/* Extended data out */
-	MEM_BEDO,		/* Burst Extended data out */
-	MEM_SDR,		/* Single data rate SDRAM */
-	MEM_RDR,		/* Registered single data rate SDRAM */
-	MEM_DDR,		/* Double data rate SDRAM */
-	MEM_RDDR,		/* Registered Double data rate SDRAM */
-	MEM_RMBS,		/* Rambus DRAM */
-	MEM_DDR2,               /* DDR2 RAM */
-	MEM_FB_DDR2,            /* fully buffered DDR2 */
-	MEM_RDDR2,              /* Registered DDR2 RAM */
-};
-
-#define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
-#define MEM_FLAG_RESERVED	BIT(MEM_RESERVED)
-#define MEM_FLAG_UNKNOWN	BIT(MEM_UNKNOWN)
-#define MEM_FLAG_FPM		BIT(MEM_FPM)
-#define MEM_FLAG_EDO		BIT(MEM_EDO)
-#define MEM_FLAG_BEDO		BIT(MEM_BEDO)
-#define MEM_FLAG_SDR		BIT(MEM_SDR)
-#define MEM_FLAG_RDR		BIT(MEM_RDR)
-#define MEM_FLAG_DDR		BIT(MEM_DDR)
-#define MEM_FLAG_RDDR		BIT(MEM_RDDR)
-#define MEM_FLAG_RMBS		BIT(MEM_RMBS)
-#define MEM_FLAG_DDR2           BIT(MEM_DDR2)
-#define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
-#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
-
-/* chipset Error Detection and Correction capabilities and mode */
-enum edac_type {
-	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
-	EDAC_NONE,		/* Doesnt support ECC */
-	EDAC_RESERVED,		/* Reserved ECC type */
-	EDAC_PARITY,		/* Detects parity errors */
-	EDAC_EC,		/* Error Checking - no correction */
-	EDAC_SECDED,		/* Single bit error correction, Double detection */
-	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
-	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
-	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
-	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
-};
-
-#define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
-#define EDAC_FLAG_NONE		BIT(EDAC_NONE)
-#define EDAC_FLAG_PARITY	BIT(EDAC_PARITY)
-#define EDAC_FLAG_EC		BIT(EDAC_EC)
-#define EDAC_FLAG_SECDED	BIT(EDAC_SECDED)
-#define EDAC_FLAG_S2ECD2ED	BIT(EDAC_S2ECD2ED)
-#define EDAC_FLAG_S4ECD4ED	BIT(EDAC_S4ECD4ED)
-#define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
-#define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
-
-/* scrubbing capabilities */
-enum scrub_type {
-	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
-	SCRUB_NONE,		/* No scrubber */
-	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
-	SCRUB_SW_SRC,		/* Software scrub only errors */
-	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
-	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
-	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
-	SCRUB_HW_SRC,		/* Hardware scrub only errors */
-	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
-	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
-};
-
-#define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC_CORR)
-#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC_CORR)
-#define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
-#define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
-#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC_CORR)
-#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC_CORR)
-#define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
-
-/* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
 
 /*
- * There are several things to be aware of that aren't at all obvious:
- *
- *
- * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
- *
- * These are some of the many terms that are thrown about that don't always
- * mean what people think they mean (Inconceivable!).  In the interest of
- * creating a common ground for discussion, terms and their definitions
- * will be established.
- *
- * Memory devices:	The individual chip on a memory stick.  These devices
- *			commonly output 4 and 8 bits each.  Grouping several
- *			of these in parallel provides 64 bits which is common
- *			for a memory stick.
- *
- * Memory Stick:	A printed circuit board that agregates multiple
- *			memory devices in parallel.  This is the atomic
- *			memory component that is purchaseable by Joe consumer
- *			and loaded into a memory socket.
- *
- * Socket:		A physical connector on the motherboard that accepts
- *			a single memory stick.
- *
- * Channel:		Set of memory devices on a memory stick that must be
- *			grouped in parallel with one or more additional
- *			channels from other memory sticks.  This parallel
- *			grouping of the output from multiple channels are
- *			necessary for the smallest granularity of memory access.
- *			Some memory controllers are capable of single channel -
- *			which means that memory sticks can be loaded
- *			individually.  Other memory controllers are only
- *			capable of dual channel - which means that memory
- *			sticks must be loaded as pairs (see "socket set").
- *
- * Chip-select row:	All of the memory devices that are selected together.
- *			for a single, minimum grain of memory access.
- *			This selects all of the parallel memory devices across
- *			all of the parallel channels.  Common chip-select rows
- *			for single channel are 64 bits, for dual channel 128
- *			bits.
- *
- * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memmory.
- *			Motherboards commonly drive two chip-select pins to
- *			a memory stick. A single-ranked stick, will occupy
- *			only one of those rows. The other will be unused.
+ * Older .h file for edac, until all drivers are modified
  *
- * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.
- *
- * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
- *			A double-sided stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.  "Double-sided"
- *			is irrespective of the memory devices being mounted
- *			on both sides of the memory stick.
- *
- * Socket set:		All of the memory sticks that are required for for
- *			a single memory access or all of the memory sticks
- *			spanned by a chip-select row.  A single socket set
- *			has two chip-select rows and if double-sided sticks
- *			are used these will occupy those chip-select rows.
- *
- * Bank:		This term is avoided because it is unclear when
- *			needing to distinguish between chip-select rows and
- *			socket sets.
- *
- * Controller pages:
- *
- * Physical pages:
- *
- * Virtual pages:
- *
- *
- * STRUCTURE ORGANIZATION AND CHOICES
- *
- *
- *
- * PS - I enjoyed writing all that about as much as you enjoyed reading it.
- */
-
-struct channel_info {
-	int chan_idx;		/* channel index */
-	u32 ce_count;		/* Correctable Errors for this CHANNEL */
-	char label[EDAC_MC_LABEL_LEN + 1];  /* DIMM label on motherboard */
-	struct csrow_info *csrow;	/* the parent */
-};
-
-struct csrow_info {
-	unsigned long first_page;	/* first page number in dimm */
-	unsigned long last_page;	/* last page number in dimm */
-	unsigned long page_mask;	/* used for interleaving -
-					 * 0UL for non intlv
-					 */
-	u32 nr_pages;		/* number of pages in csrow */
-	u32 grain;		/* granularity of reported error in bytes */
-	int csrow_idx;		/* the chip-select row */
-	enum dev_type dtype;	/* memory device type */
-	u32 ue_count;		/* Uncorrectable Errors for this csrow */
-	u32 ce_count;		/* Correctable Errors for this csrow */
-	enum mem_type mtype;	/* memory csrow type */
-	enum edac_type edac_mode;	/* EDAC mode for this csrow */
-	struct mem_ctl_info *mci;	/* the parent */
-
-	struct kobject kobj;	/* sysfs kobject for this csrow */
-	struct completion kobj_complete;
-
-	/* FIXME the number of CHANNELs might need to become dynamic */
-	u32 nr_channels;
-	struct channel_info *channels;
-};
-
-struct mem_ctl_info {
-	struct list_head link;  /* for global list of mem_ctl_info structs */
-	unsigned long mtype_cap;	/* memory types supported by mc */
-	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
-	unsigned long edac_cap;	/* configuration capabilities - this is
-				 * closely related to edac_ctl_cap.  The
-				 * difference is that the controller may be
-				 * capable of s4ecd4ed which would be listed
-				 * in edac_ctl_cap, but if channels aren't
-				 * capable of s4ecd4ed then the edac_cap would
-				 * not have that capability.
-				 */
-	unsigned long scrub_cap;	/* chipset scrub capabilities */
-	enum scrub_type scrub_mode;	/* current scrub mode */
-
-	/* Translates sdram memory scrub rate given in bytes/sec to the
-	   internal representation and configures whatever else needs
-	   to be configured.
-	*/
-	int (*set_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
-
-	/* Get the current sdram memory scrub rate from the internal
-	   representation and converts it to the closest matching
-	   bandwith in bytes/sec.
-	*/
-	int (*get_sdram_scrub_rate) (struct mem_ctl_info *mci, u32 *bw);
-
-	/* pointer to edac checking routine */
-	void (*edac_check) (struct mem_ctl_info * mci);
-
-	/*
-	 * Remaps memory pages: controller pages to physical pages.
-	 * For most MC's, this will be NULL.
-	 */
-	/* FIXME - why not send the phys page to begin with? */
-	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
-					unsigned long page);
-	int mc_idx;
-	int nr_csrows;
-	struct csrow_info *csrows;
-	/*
-	 * FIXME - what about controllers on other busses? - IDs must be
-	 * unique.  dev pointer should be sufficiently unique, but
-	 * BUS:SLOT.FUNC numbers may not be unique.
-	 */
-	struct device *dev;
-	const char *mod_name;
-	const char *mod_ver;
-	const char *ctl_name;
-	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
-	void *pvt_info;
-	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
-	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
-	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
-	u32 ce_count;		/* Total Correctable Errors for this MC */
-	unsigned long start_time;	/* mci load start time (in jiffies) */
-
-	/* this stuff is for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
-	struct completion complete;
-
-	/* edac sysfs device control */
-	struct kobject edac_mci_kobj;
-	struct completion kobj_complete;
-};
-
-#ifdef CONFIG_PCI
-
-/* write all or some bits in a byte-register*/
-static inline void pci_write_bits8(struct pci_dev *pdev, int offset, u8 value,
-		u8 mask)
-{
-	if (mask != 0xff) {
-		u8 buf;
-
-		pci_read_config_byte(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_byte(pdev, offset, value);
-}
-
-/* write all or some bits in a word-register*/
-static inline void pci_write_bits16(struct pci_dev *pdev, int offset,
-		u16 value, u16 mask)
-{
-	if (mask != 0xffff) {
-		u16 buf;
-
-		pci_read_config_word(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_word(pdev, offset, value);
-}
-
-/* write all or some bits in a dword-register*/
-static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
-		u32 value, u32 mask)
-{
-	if (mask != 0xffff) {
-		u32 buf;
-
-		pci_read_config_dword(pdev, offset, &buf);
-		value &= mask;
-		buf &= ~mask;
-		value |= buf;
-	}
-
-	pci_write_config_dword(pdev, offset, value);
-}
-
-#endif /* CONFIG_PCI */
-
-extern struct mem_ctl_info * edac_mc_find(int idx);
-extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
-extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
-extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
-					unsigned long page);
-
-/*
- * The no info errors are used when error overflows are reported.
- * There are a limited number of error logging registers that can
- * be exausted.  When all registers are exhausted and an additional
- * error occurs then an error overflow register records that an
- * error occured and the type of error, but doesn't have any
- * further information.  The ce/ue versions make for cleaner
- * reporting logic and function interface - reduces conditional
- * statement clutter and extra function arguments.
- */
-extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		unsigned long syndrome, int row, int channel,
-		const char *msg);
-extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
-		const char *msg);
-extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		unsigned long page_frame_number, unsigned long offset_in_page,
-		int row, const char *msg);
-extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
-		const char *msg);
-extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-		unsigned int csrow,
-		unsigned int channel0,
-		unsigned int channel1,
-		char *msg);
-extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-		unsigned int csrow,
-		unsigned int channel,
-		char *msg);
-
-/*
- * This kmalloc's and initializes all the structures.
- * Can't be used if all structures don't have the same lifetime.
  */
-extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-		unsigned nr_chans);
 
-/* Free an mc previously allocated by edac_mc_alloc() */
-extern void edac_mc_free(struct mem_ctl_info *mci);
+#include "edac_core.h"
 
-#endif				/* _EDAC_MC_H_ */
diff -puN /dev/null drivers/edac/edac_mc_sysfs.c
--- /dev/null
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -0,0 +1,889 @@
+/*
+ * edac_mc kernel module
+ * (C) 2005, 2006 Linux Networx (http://lnxi.com)
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ * Written Doug Thompson <norsk5@xmission.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/sysdev.h>
+#include <linux/ctype.h>
+
+#include "edac_mc.h"
+#include "edac_module.h"
+
+/* MC EDAC Controls, setable by module parameter, and sysfs */
+static int log_ue = 1;
+static int log_ce = 1;
+static int panic_on_ue;
+static int poll_msec = 1000;
+
+/* Getter functions for above */
+int edac_get_log_ue()
+{
+	return log_ue;
+}
+
+int edac_get_log_ce()
+{
+	return log_ce;
+}
+
+int edac_get_panic_on_ue()
+{
+	return panic_on_ue;
+}
+
+int edac_get_poll_msec()
+{
+	return poll_msec;
+}
+
+/* Parameter declarations for above */
+module_param(panic_on_ue, int, 0644);
+MODULE_PARM_DESC(panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
+module_param(log_ue, int, 0644);
+MODULE_PARM_DESC(log_ue, "Log uncorrectable error to console: 0=off 1=on");
+module_param(log_ce, int, 0644);
+MODULE_PARM_DESC(log_ce, "Log correctable error to console: 0=off 1=on");
+module_param(poll_msec, int, 0644);
+MODULE_PARM_DESC(poll_msec, "Polling period in milliseconds");
+
+
+/*
+ * various constants for Memory Controllers
+ */
+static const char *mem_types[] = {
+	[MEM_EMPTY] = "Empty",
+	[MEM_RESERVED] = "Reserved",
+	[MEM_UNKNOWN] = "Unknown",
+	[MEM_FPM] = "FPM",
+	[MEM_EDO] = "EDO",
+	[MEM_BEDO] = "BEDO",
+	[MEM_SDR] = "Unbuffered-SDR",
+	[MEM_RDR] = "Registered-SDR",
+	[MEM_DDR] = "Unbuffered-DDR",
+	[MEM_RDDR] = "Registered-DDR",
+	[MEM_RMBS] = "RMBS"
+};
+
+static const char *dev_types[] = {
+	[DEV_UNKNOWN] = "Unknown",
+	[DEV_X1] = "x1",
+	[DEV_X2] = "x2",
+	[DEV_X4] = "x4",
+	[DEV_X8] = "x8",
+	[DEV_X16] = "x16",
+	[DEV_X32] = "x32",
+	[DEV_X64] = "x64"
+};
+
+static const char *edac_caps[] = {
+	[EDAC_UNKNOWN] = "Unknown",
+	[EDAC_NONE] = "None",
+	[EDAC_RESERVED] = "Reserved",
+	[EDAC_PARITY] = "PARITY",
+	[EDAC_EC] = "EC",
+	[EDAC_SECDED] = "SECDED",
+	[EDAC_S2ECD2ED] = "S2ECD2ED",
+	[EDAC_S4ECD4ED] = "S4ECD4ED",
+	[EDAC_S8ECD8ED] = "S8ECD8ED",
+	[EDAC_S16ECD16ED] = "S16ECD16ED"
+};
+
+/*
+ * sysfs object: /sys/devices/system/edac
+ *	need to export to other files in this modules
+ */
+struct sysdev_class edac_class = {
+	set_kset_name("edac"),
+};
+
+/* sysfs object:
+ *	/sys/devices/system/edac/mc
+ */
+static struct kobject edac_memctrl_kobj;
+
+/* We use these to wait for the reference counts on edac_memctrl_kobj and
+ * edac_pci_kobj to reach 0.
+ */
+static struct completion edac_memctrl_kobj_complete;
+
+/*
+ * /sys/devices/system/edac/mc;
+ *	data structures and methods
+ */
+static ssize_t memctrl_int_show(void *ptr, char *buffer)
+{
+	int *value = (int*) ptr;
+	return sprintf(buffer, "%u\n", *value);
+}
+
+static ssize_t memctrl_int_store(void *ptr, const char *buffer, size_t count)
+{
+	int *value = (int*) ptr;
+
+	if (isdigit(*buffer))
+		*value = simple_strtoul(buffer, NULL, 0);
+
+	return count;
+}
+
+struct memctrl_dev_attribute {
+	struct attribute attr;
+	void *value;
+	ssize_t (*show)(void *,char *);
+	ssize_t (*store)(void *, const char *, size_t);
+};
+
+/* Set of show/store abstract level functions for memory control object */
+static ssize_t memctrl_dev_show(struct kobject *kobj,
+		struct attribute *attr, char *buffer)
+{
+	struct memctrl_dev_attribute *memctrl_dev;
+	memctrl_dev = (struct memctrl_dev_attribute*)attr;
+
+	if (memctrl_dev->show)
+		return memctrl_dev->show(memctrl_dev->value, buffer);
+
+	return -EIO;
+}
+
+static ssize_t memctrl_dev_store(struct kobject *kobj, struct attribute *attr,
+		const char *buffer, size_t count)
+{
+	struct memctrl_dev_attribute *memctrl_dev;
+	memctrl_dev = (struct memctrl_dev_attribute*)attr;
+
+	if (memctrl_dev->store)
+		return memctrl_dev->store(memctrl_dev->value, buffer, count);
+
+	return -EIO;
+}
+
+static struct sysfs_ops memctrlfs_ops = {
+	.show   = memctrl_dev_show,
+	.store  = memctrl_dev_store
+};
+
+#define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
+static struct memctrl_dev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = &_name,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+#define MEMCTRL_STRING_ATTR(_name,_data,_mode,_show,_store)	\
+static struct memctrl_dev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = _data,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+/* csrow<id> control files */
+MEMCTRL_ATTR(panic_on_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
+MEMCTRL_ATTR(log_ue,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
+MEMCTRL_ATTR(log_ce,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
+MEMCTRL_ATTR(poll_msec,S_IRUGO|S_IWUSR,memctrl_int_show,memctrl_int_store);
+
+/* Base Attributes of the memory ECC object */
+static struct memctrl_dev_attribute *memctrl_attr[] = {
+	&attr_panic_on_ue,
+	&attr_log_ue,
+	&attr_log_ce,
+	&attr_poll_msec,
+	NULL,
+};
+
+/* Main MC kobject release() function */
+static void edac_memctrl_master_release(struct kobject *kobj)
+{
+	debugf1("%s()\n", __func__);
+	complete(&edac_memctrl_kobj_complete);
+}
+
+static struct kobj_type ktype_memctrl = {
+	.release = edac_memctrl_master_release,
+	.sysfs_ops = &memctrlfs_ops,
+	.default_attrs = (struct attribute **) memctrl_attr,
+};
+
+/* Initialize the main sysfs entries for edac:
+ *   /sys/devices/system/edac
+ *
+ * and children
+ *
+ * Return:  0 SUCCESS
+ *         !0 FAILURE
+ */
+int edac_sysfs_memctrl_setup(void)
+{
+	int err = 0;
+
+	debugf1("%s()\n", __func__);
+
+	/* create the /sys/devices/system/edac directory */
+	err = sysdev_class_register(&edac_class);
+
+	if (err) {
+		debugf1("%s() error=%d\n", __func__, err);
+		return err;
+	}
+
+	/* Init the MC's kobject */
+	memset(&edac_memctrl_kobj, 0, sizeof (edac_memctrl_kobj));
+	edac_memctrl_kobj.parent = &edac_class.kset.kobj;
+	edac_memctrl_kobj.ktype = &ktype_memctrl;
+
+	/* generate sysfs "..../edac/mc"   */
+	err = kobject_set_name(&edac_memctrl_kobj,"mc");
+
+	if (err)
+		goto fail;
+
+	/* FIXME: maybe new sysdev_create_subdir() */
+	err = kobject_register(&edac_memctrl_kobj);
+
+	if (err) {
+		debugf1("Failed to register '.../edac/mc'\n");
+		goto fail;
+	}
+
+	debugf1("Registered '.../edac/mc' kobject\n");
+
+	return 0;
+
+fail:
+	sysdev_class_unregister(&edac_class);
+	return err;
+}
+
+/*
+ * MC teardown:
+ *	the '..../edac/mc' kobject followed by '..../edac' itself
+ */
+void edac_sysfs_memctrl_teardown(void)
+{
+	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+
+	/* Unregister the MC's kobject and wait for reference count to reach 0.
+	 */
+	init_completion(&edac_memctrl_kobj_complete);
+	kobject_unregister(&edac_memctrl_kobj);
+	wait_for_completion(&edac_memctrl_kobj_complete);
+
+	/* Unregister the 'edac' object */
+	sysdev_class_unregister(&edac_class);
+}
+
+
+/* EDAC sysfs CSROW data structures and methods
+ */
+
+/* Set of more default csrow<id> attribute show/store functions */
+static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%u\n", csrow->ue_count);
+}
+
+static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%u\n", csrow->ce_count);
+}
+
+static ssize_t csrow_size_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%u\n", PAGES_TO_MiB(csrow->nr_pages));
+}
+
+static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%s\n", mem_types[csrow->mtype]);
+}
+
+static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%s\n", dev_types[csrow->dtype]);
+}
+
+static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data, int private)
+{
+	return sprintf(data,"%s\n", edac_caps[csrow->edac_mode]);
+}
+
+/* show/store functions for DIMM Label attributes */
+static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
+		char *data, int channel)
+{
+	return snprintf(data, EDAC_MC_LABEL_LEN,"%s",
+			csrow->channels[channel].label);
+}
+
+static ssize_t channel_dimm_label_store(struct csrow_info *csrow,
+				const char *data,
+				size_t count,
+				int channel)
+{
+	ssize_t max_size = 0;
+
+	max_size = min((ssize_t)count,(ssize_t)EDAC_MC_LABEL_LEN-1);
+	strncpy(csrow->channels[channel].label, data, max_size);
+	csrow->channels[channel].label[max_size] = '\0';
+
+	return max_size;
+}
+
+/* show function for dynamic chX_ce_count attribute */
+static ssize_t channel_ce_count_show(struct csrow_info *csrow,
+				char *data,
+				int channel)
+{
+	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
+}
+
+/* csrow specific attribute structure */
+struct csrowdev_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct csrow_info *,char *,int);
+	ssize_t (*store)(struct csrow_info *, const char *,size_t,int);
+	int    private;
+};
+
+#define to_csrow(k) container_of(k, struct csrow_info, kobj)
+#define to_csrowdev_attr(a) container_of(a, struct csrowdev_attribute, attr)
+
+/* Set of show/store higher level functions for default csrow attributes */
+static ssize_t csrowdev_show(struct kobject *kobj,
+			struct attribute *attr,
+			char *buffer)
+{
+	struct csrow_info *csrow = to_csrow(kobj);
+	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
+
+	if (csrowdev_attr->show)
+		return csrowdev_attr->show(csrow,
+					buffer,
+					csrowdev_attr->private);
+	return -EIO;
+}
+
+static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
+		const char *buffer, size_t count)
+{
+	struct csrow_info *csrow = to_csrow(kobj);
+	struct csrowdev_attribute * csrowdev_attr = to_csrowdev_attr(attr);
+
+	if (csrowdev_attr->store)
+		return csrowdev_attr->store(csrow,
+					buffer,
+					count,
+					csrowdev_attr->private);
+	return -EIO;
+}
+
+static struct sysfs_ops csrowfs_ops = {
+	.show   = csrowdev_show,
+	.store  = csrowdev_store
+};
+
+#define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
+static struct csrowdev_attribute attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show   = _show,					\
+	.store  = _store,					\
+	.private = _private,					\
+};
+
+/* default cwrow<id>/attribute files */
+CSROWDEV_ATTR(size_mb,S_IRUGO,csrow_size_show,NULL,0);
+CSROWDEV_ATTR(dev_type,S_IRUGO,csrow_dev_type_show,NULL,0);
+CSROWDEV_ATTR(mem_type,S_IRUGO,csrow_mem_type_show,NULL,0);
+CSROWDEV_ATTR(edac_mode,S_IRUGO,csrow_edac_mode_show,NULL,0);
+CSROWDEV_ATTR(ue_count,S_IRUGO,csrow_ue_count_show,NULL,0);
+CSROWDEV_ATTR(ce_count,S_IRUGO,csrow_ce_count_show,NULL,0);
+
+/* default attributes of the CSROW<id> object */
+static struct csrowdev_attribute *default_csrow_attr[] = {
+	&attr_dev_type,
+	&attr_mem_type,
+	&attr_edac_mode,
+	&attr_size_mb,
+	&attr_ue_count,
+	&attr_ce_count,
+	NULL,
+};
+
+
+/* possible dynamic channel DIMM Label attribute files */
+CSROWDEV_ATTR(ch0_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		0 );
+CSROWDEV_ATTR(ch1_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		1 );
+CSROWDEV_ATTR(ch2_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		2 );
+CSROWDEV_ATTR(ch3_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		3 );
+CSROWDEV_ATTR(ch4_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		4 );
+CSROWDEV_ATTR(ch5_dimm_label,S_IRUGO|S_IWUSR,
+		channel_dimm_label_show,
+		channel_dimm_label_store,
+		5 );
+
+/* Total possible dynamic DIMM Label attribute file table */
+static struct csrowdev_attribute *dynamic_csrow_dimm_attr[] = {
+		&attr_ch0_dimm_label,
+		&attr_ch1_dimm_label,
+		&attr_ch2_dimm_label,
+		&attr_ch3_dimm_label,
+		&attr_ch4_dimm_label,
+		&attr_ch5_dimm_label
+};
+
+/* possible dynamic channel ce_count attribute files */
+CSROWDEV_ATTR(ch0_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		0 );
+CSROWDEV_ATTR(ch1_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		1 );
+CSROWDEV_ATTR(ch2_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		2 );
+CSROWDEV_ATTR(ch3_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		3 );
+CSROWDEV_ATTR(ch4_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		4 );
+CSROWDEV_ATTR(ch5_ce_count,S_IRUGO|S_IWUSR,
+		channel_ce_count_show,
+		NULL,
+		5 );
+
+/* Total possible dynamic ce_count attribute file table */
+static struct csrowdev_attribute *dynamic_csrow_ce_count_attr[] = {
+		&attr_ch0_ce_count,
+		&attr_ch1_ce_count,
+		&attr_ch2_ce_count,
+		&attr_ch3_ce_count,
+		&attr_ch4_ce_count,
+		&attr_ch5_ce_count
+};
+
+
+#define EDAC_NR_CHANNELS	6
+
+/* Create dynamic CHANNEL files, indexed by 'chan',  under specifed CSROW */
+static int edac_create_channel_files(struct kobject *kobj, int chan)
+{
+	int err=-ENODEV;
+
+	if (chan >= EDAC_NR_CHANNELS)
+		return err;
+
+	/* create the DIMM label attribute file */
+	err = sysfs_create_file(kobj,
+			(struct attribute *) dynamic_csrow_dimm_attr[chan]);
+
+	if (!err) {
+		/* create the CE Count attribute file */
+		err = sysfs_create_file(kobj,
+			(struct attribute *) dynamic_csrow_ce_count_attr[chan]);
+	} else {
+		debugf1("%s()  dimm labels and ce_count files created", __func__);
+	}
+
+	return err;
+}
+
+/* No memory to release for this kobj */
+static void edac_csrow_instance_release(struct kobject *kobj)
+{
+	struct csrow_info *cs;
+
+	cs = container_of(kobj, struct csrow_info, kobj);
+	complete(&cs->kobj_complete);
+}
+
+/* the kobj_type instance for a CSROW */
+static struct kobj_type ktype_csrow = {
+	.release = edac_csrow_instance_release,
+	.sysfs_ops = &csrowfs_ops,
+	.default_attrs = (struct attribute **) default_csrow_attr,
+};
+
+/* Create a CSROW object under specifed edac_mc_device */
+static int edac_create_csrow_object(
+		struct kobject *edac_mci_kobj,
+		struct csrow_info *csrow,
+		int index)
+{
+	int err = 0;
+	int chan;
+
+	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
+
+	/* generate ..../edac/mc/mc<id>/csrow<index>   */
+
+	csrow->kobj.parent = edac_mci_kobj;
+	csrow->kobj.ktype = &ktype_csrow;
+
+	/* name this instance of csrow<id> */
+	err = kobject_set_name(&csrow->kobj,"csrow%d",index);
+	if (err)
+		goto error_exit;
+
+	/* Instanstiate the csrow object */
+	err = kobject_register(&csrow->kobj);
+	if (!err) {
+		/* Create the dyanmic attribute files on this csrow,
+		 * namely, the DIMM labels and the channel ce_count
+		 */
+		for (chan = 0; chan < csrow->nr_channels; chan++) {
+			err = edac_create_channel_files(&csrow->kobj,chan);
+			if (err)
+				break;
+		}
+	}
+
+error_exit:
+	return err;
+}
+
+/* default sysfs methods and data structures for the main MCI kobject */
+
+static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
+		const char *data, size_t count)
+{
+	int row, chan;
+
+	mci->ue_noinfo_count = 0;
+	mci->ce_noinfo_count = 0;
+	mci->ue_count = 0;
+	mci->ce_count = 0;
+
+	for (row = 0; row < mci->nr_csrows; row++) {
+		struct csrow_info *ri = &mci->csrows[row];
+
+		ri->ue_count = 0;
+		ri->ce_count = 0;
+
+		for (chan = 0; chan < ri->nr_channels; chan++)
+			ri->channels[chan].ce_count = 0;
+	}
+
+	mci->start_time = jiffies;
+	return count;
+}
+
+/* memory scrubbing */
+static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	u32 bandwidth = -1;
+
+	if (mci->set_sdram_scrub_rate) {
+
+		memctrl_int_store(&bandwidth, data, count);
+
+		if (!(*mci->set_sdram_scrub_rate)(mci, &bandwidth)) {
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate set successfully, applied: %d\n",
+				bandwidth);
+		} else {
+			/* FIXME: error codes maybe? */
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate set FAILED, could not apply: %d\n",
+				bandwidth);
+		}
+	} else {
+		/* FIXME: produce "not implemented" ERROR for user-side. */
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrubbing 'set'control is not implemented!\n");
+	}
+	return count;
+}
+
+static ssize_t mci_sdram_scrub_rate_show(struct mem_ctl_info *mci, char *data)
+{
+	u32 bandwidth = -1;
+
+	if (mci->get_sdram_scrub_rate) {
+		if (!(*mci->get_sdram_scrub_rate)(mci, &bandwidth)) {
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate successfully, fetched: %d\n",
+				bandwidth);
+		} else {
+			/* FIXME: error codes maybe? */
+			edac_printk(KERN_DEBUG, EDAC_MC,
+				"Scrub rate fetch FAILED, got: %d\n",
+				bandwidth);
+		}
+	} else {
+		/* FIXME: produce "not implemented" ERROR for user-side.  */
+		edac_printk(KERN_WARNING, EDAC_MC,
+			"Memory scrubbing 'get' control is not implemented!\n");
+	}
+	return sprintf(data, "%d\n", bandwidth);
+}
+
+/* default attribute files for the MCI object */
+static ssize_t mci_ue_count_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%d\n", mci->ue_count);
+}
+
+static ssize_t mci_ce_count_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%d\n", mci->ce_count);
+}
+
+static ssize_t mci_ce_noinfo_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%d\n", mci->ce_noinfo_count);
+}
+
+static ssize_t mci_ue_noinfo_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%d\n", mci->ue_noinfo_count);
+}
+
+static ssize_t mci_seconds_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%ld\n", (jiffies - mci->start_time) / HZ);
+}
+
+static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
+{
+	return sprintf(data,"%s\n", mci->ctl_name);
+}
+
+static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
+{
+	int total_pages, csrow_idx;
+
+	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
+			csrow_idx++) {
+		struct csrow_info *csrow = &mci->csrows[csrow_idx];
+
+		if (!csrow->nr_pages)
+			continue;
+
+		total_pages += csrow->nr_pages;
+	}
+
+	return sprintf(data,"%u\n", PAGES_TO_MiB(total_pages));
+}
+
+struct mcidev_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct mem_ctl_info *,char *);
+	ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+};
+
+#define to_mci(k) container_of(k, struct mem_ctl_info, edac_mci_kobj)
+#define to_mcidev_attr(a) container_of(a, struct mcidev_attribute, attr)
+
+/* MCI show/store functions for top most object */
+static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
+	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
+
+	if (mcidev_attr->show)
+		return mcidev_attr->show(mem_ctl_info, buffer);
+
+	return -EIO;
+}
+
+static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
+		const char *buffer, size_t count)
+{
+	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
+	struct mcidev_attribute * mcidev_attr = to_mcidev_attr(attr);
+
+	if (mcidev_attr->store)
+		return mcidev_attr->store(mem_ctl_info, buffer, count);
+
+	return -EIO;
+}
+
+static struct sysfs_ops mci_ops = {
+	.show = mcidev_show,
+	.store = mcidev_store
+};
+
+#define MCIDEV_ATTR(_name,_mode,_show,_store)			\
+static struct mcidev_attribute mci_attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+/* default Control file */
+MCIDEV_ATTR(reset_counters,S_IWUSR,NULL,mci_reset_counters_store);
+
+/* default Attribute files */
+MCIDEV_ATTR(mc_name,S_IRUGO,mci_ctl_name_show,NULL);
+MCIDEV_ATTR(size_mb,S_IRUGO,mci_size_mb_show,NULL);
+MCIDEV_ATTR(seconds_since_reset,S_IRUGO,mci_seconds_show,NULL);
+MCIDEV_ATTR(ue_noinfo_count,S_IRUGO,mci_ue_noinfo_show,NULL);
+MCIDEV_ATTR(ce_noinfo_count,S_IRUGO,mci_ce_noinfo_show,NULL);
+MCIDEV_ATTR(ue_count,S_IRUGO,mci_ue_count_show,NULL);
+MCIDEV_ATTR(ce_count,S_IRUGO,mci_ce_count_show,NULL);
+
+/* memory scrubber attribute file */
+MCIDEV_ATTR(sdram_scrub_rate,S_IRUGO|S_IWUSR,mci_sdram_scrub_rate_show,mci_sdram_scrub_rate_store);
+
+static struct mcidev_attribute *mci_attr[] = {
+	&mci_attr_reset_counters,
+	&mci_attr_mc_name,
+	&mci_attr_size_mb,
+	&mci_attr_seconds_since_reset,
+	&mci_attr_ue_noinfo_count,
+	&mci_attr_ce_noinfo_count,
+	&mci_attr_ue_count,
+	&mci_attr_ce_count,
+	&mci_attr_sdram_scrub_rate,
+	NULL
+};
+
+/*
+ * Release of a MC controlling instance
+ */
+static void edac_mci_instance_release(struct kobject *kobj)
+{
+	struct mem_ctl_info *mci;
+
+	mci = to_mci(kobj);
+	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
+	complete(&mci->kobj_complete);
+}
+
+static struct kobj_type ktype_mci = {
+	.release = edac_mci_instance_release,
+	.sysfs_ops = &mci_ops,
+	.default_attrs = (struct attribute **) mci_attr,
+};
+
+
+#define EDAC_DEVICE_SYMLINK	"device"
+
+/*
+ * Create a new Memory Controller kobject instance,
+ *	mc<id> under the 'mc' directory
+ *
+ * Return:
+ *	0	Success
+ *	!0	Failure
+ */
+int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
+{
+	int i;
+	int err;
+	struct csrow_info *csrow;
+	struct kobject *edac_mci_kobj=&mci->edac_mci_kobj;
+
+	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
+	memset(edac_mci_kobj, 0, sizeof(*edac_mci_kobj));
+
+	/* set the name of the mc<id> object */
+	err = kobject_set_name(edac_mci_kobj,"mc%d",mci->mc_idx);
+	if (err)
+		return err;
+
+	/* link to our parent the '..../edac/mc' object */
+	edac_mci_kobj->parent = &edac_memctrl_kobj;
+	edac_mci_kobj->ktype = &ktype_mci;
+
+	/* register the mc<id> kobject */
+	err = kobject_register(edac_mci_kobj);
+	if (err)
+		return err;
+
+	/* create a symlink for the device */
+	err = sysfs_create_link(edac_mci_kobj, &mci->dev->kobj,
+				EDAC_DEVICE_SYMLINK);
+	if (err)
+		goto fail0;
+
+	/* Make directories for each CSROW object
+	 * under the mc<id> kobject
+	 */
+	for (i = 0; i < mci->nr_csrows; i++) {
+		csrow = &mci->csrows[i];
+
+		/* Only expose populated CSROWs */
+		if (csrow->nr_pages > 0) {
+			err = edac_create_csrow_object(edac_mci_kobj,csrow,i);
+			if (err)
+				goto fail1;
+		}
+	}
+
+	return 0;
+
+	/* CSROW error: backout what has already been registered,  */
+fail1:
+	for ( i--; i >= 0; i--) {
+		if (csrow->nr_pages > 0) {
+			init_completion(&csrow->kobj_complete);
+			kobject_unregister(&mci->csrows[i].kobj);
+			wait_for_completion(&csrow->kobj_complete);
+		}
+	}
+
+fail0:
+	init_completion(&mci->kobj_complete);
+	kobject_unregister(edac_mci_kobj);
+	wait_for_completion(&mci->kobj_complete);
+	return err;
+}
+
+/*
+ * remove a Memory Controller instance
+ */
+void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
+{
+	int i;
+
+	debugf0("%s()\n", __func__);
+
+	/* remove all csrow kobjects */
+	for (i = 0; i < mci->nr_csrows; i++) {
+		if (mci->csrows[i].nr_pages > 0) {
+			init_completion(&mci->csrows[i].kobj_complete);
+			kobject_unregister(&mci->csrows[i].kobj);
+			wait_for_completion(&mci->csrows[i].kobj_complete);
+		}
+	}
+
+	sysfs_remove_link(&mci->edac_mci_kobj, EDAC_DEVICE_SYMLINK);
+	init_completion(&mci->kobj_complete);
+	kobject_unregister(&mci->edac_mci_kobj);
+	wait_for_completion(&mci->kobj_complete);
+}
+
+
diff -puN /dev/null drivers/edac/edac_module.c
--- /dev/null
+++ a/drivers/edac/edac_module.c
@@ -0,0 +1,130 @@
+
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+
+#include "edac_mc.h"
+#include "edac_module.h"
+
+#define EDAC_MC_VERSION "Ver: 2.0.3" __DATE__
+
+#ifdef CONFIG_EDAC_DEBUG
+/* Values of 0 to 4 will generate output */
+int edac_debug_level = 1;
+EXPORT_SYMBOL_GPL(edac_debug_level);
+#endif
+
+static struct task_struct *edac_thread;
+
+/*
+ * Check MC status every edac_get_poll_msec().
+ * Check PCI status every edac_get_poll_msec() as well.
+ *
+ * This where the work gets done for edac.
+ *
+ * SMP safe, doesn't use NMI, and auto-rate-limits.
+ */
+static void do_edac_check(void)
+{
+	debugf3("%s()\n", __func__);
+
+	/* perform the poll activities */
+	edac_check_mc_devices();
+	edac_pci_do_parity_check();
+}
+
+/*
+ * Action thread for EDAC to perform the POLL operations
+ */
+static int edac_kernel_thread(void *arg)
+{
+	int msec;
+
+	while (!kthread_should_stop()) {
+
+		do_edac_check();
+
+		/* goto sleep for the interval */
+		msec = (HZ * edac_get_poll_msec()) / 1000;
+		schedule_timeout_interruptible(msec);
+		try_to_freeze();
+	}
+
+	return 0;
+}
+
+/*
+ * edac_init
+ *      module initialization entry point
+ */
+static int __init edac_init(void)
+{
+	edac_printk(KERN_INFO, EDAC_MC, EDAC_MC_VERSION "\n");
+
+	/*
+	 * Harvest and clear any boot/initialization PCI parity errors
+	 *
+	 * FIXME: This only clears errors logged by devices present at time of
+	 * 	module initialization.  We should also do an initial clear
+	 *	of each newly hotplugged device.
+	 */
+	edac_pci_clear_parity_errors();
+
+	/* Create the MC sysfs entries */
+	if (edac_sysfs_memctrl_setup()) {
+		edac_printk(KERN_ERR, EDAC_MC,
+			"Error initializing sysfs code\n");
+		return -ENODEV;
+	}
+
+	/* Create the PCI parity sysfs entries */
+	if (edac_sysfs_pci_setup()) {
+		edac_sysfs_memctrl_teardown();
+		edac_printk(KERN_ERR, EDAC_MC,
+			"PCI: Error initializing sysfs code\n");
+		return -ENODEV;
+	}
+
+	/* create our kernel thread */
+	edac_thread = kthread_run(edac_kernel_thread, NULL, "kedac");
+
+	if (IS_ERR(edac_thread)) {
+		/* remove the sysfs entries */
+		edac_sysfs_memctrl_teardown();
+		edac_sysfs_pci_teardown();
+		return PTR_ERR(edac_thread);
+	}
+
+	return 0;
+}
+
+/*
+ * edac_exit()
+ *      module exit/termination function
+ */
+static void __exit edac_exit(void)
+{
+	debugf0("%s()\n", __func__);
+	kthread_stop(edac_thread);
+
+	/* tear down the sysfs device */
+	edac_sysfs_memctrl_teardown();
+	edac_sysfs_pci_teardown();
+}
+
+/*
+ * Inform the kernel of our entry and exit points
+ */
+module_init(edac_init);
+module_exit(edac_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Doug Thompson www.softwarebitmaker.com, et al");
+MODULE_DESCRIPTION("Core library routines for EDAC reporting");
+
+/* refer to *_sysfs.c files for parameters that are exported via sysfs */
+
+#ifdef CONFIG_EDAC_DEBUG
+module_param(edac_debug_level, int, 0644);
+MODULE_PARM_DESC(edac_debug_level, "Debug level");
+#endif
+
diff -puN /dev/null drivers/edac/edac_module.h
--- /dev/null
+++ a/drivers/edac/edac_module.h
@@ -0,0 +1,55 @@
+
+/*
+ * edac_module.h
+ *
+ * For defining functions/data for within the EDAC_CORE module only
+ *
+ * written by doug thompson <norsk5@xmission.h>
+ */
+
+#ifndef	__EDAC_MODULE_H__
+#define	__EDAC_MODULE_H__
+
+#include <linux/sysdev.h>
+
+#include "edac_core.h"
+
+/*
+ * INTERNAL EDAC MODULE:
+ * EDAC memory controller sysfs create/remove functions
+ * and setup/teardown functions
+ */
+extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
+extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
+extern int edac_sysfs_memctrl_setup(void);
+extern void edac_sysfs_memctrl_teardown(void);
+extern void edac_check_mc_devices(void);
+extern int edac_get_log_ue(void);
+extern int edac_get_log_ce(void);
+extern int edac_get_panic_on_ue(void);
+extern int edac_get_poll_msec(void);
+
+extern int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev);
+extern void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev);
+extern struct sysdev_class *edac_get_edac_class(void);
+
+
+/*
+ * EDAC PCI functions
+ */
+#ifdef	CONFIG_PCI
+extern void edac_pci_do_parity_check(void);
+extern void edac_pci_clear_parity_errors(void);
+extern int edac_sysfs_pci_setup(void);
+extern void edac_sysfs_pci_teardown(void);
+#else   /* CONFIG_PCI */
+/* pre-process these away */
+#define edac_pci_do_parity_check()
+#define edac_pci_clear_parity_errors()
+#define edac_sysfs_pci_setup()  (0)
+#define edac_sysfs_pci_teardown()
+#endif  /* CONFIG_PCI */
+
+
+#endif	/* __EDAC_MODULE_H__ */
+
diff -puN /dev/null drivers/edac/edac_pci_sysfs.c
--- /dev/null
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -0,0 +1,361 @@
+/* edac_mc kernel module
+ * (C) 2005, 2006 Linux Networx (http://lnxi.com)
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ * Written Doug Thompson <norsk5@xmission.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/sysdev.h>
+#include <linux/ctype.h>
+
+#include "edac_mc.h"
+#include "edac_module.h"
+
+
+#ifdef CONFIG_PCI
+static int check_pci_parity = 0;	/* default YES check PCI parity */
+static int panic_on_pci_parity;		/* default no panic on PCI Parity */
+static atomic_t pci_parity_count = ATOMIC_INIT(0);
+
+static struct kobject edac_pci_kobj; /* /sys/devices/system/edac/pci */
+static struct completion edac_pci_kobj_complete;
+
+
+static ssize_t edac_pci_int_show(void *ptr, char *buffer)
+{
+	int *value = ptr;
+	return sprintf(buffer,"%d\n",*value);
+}
+
+static ssize_t edac_pci_int_store(void *ptr, const char *buffer, size_t count)
+{
+	int *value = ptr;
+
+	if (isdigit(*buffer))
+		*value = simple_strtoul(buffer,NULL,0);
+
+	return count;
+}
+
+struct edac_pci_dev_attribute {
+	struct attribute attr;
+	void *value;
+	ssize_t (*show)(void *,char *);
+	ssize_t (*store)(void *, const char *,size_t);
+};
+
+/* Set of show/store abstract level functions for PCI Parity object */
+static ssize_t edac_pci_dev_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	struct edac_pci_dev_attribute *edac_pci_dev;
+	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
+
+	if (edac_pci_dev->show)
+		return edac_pci_dev->show(edac_pci_dev->value, buffer);
+	return -EIO;
+}
+
+static ssize_t edac_pci_dev_store(struct kobject *kobj,
+		struct attribute *attr, const char *buffer, size_t count)
+{
+	struct edac_pci_dev_attribute *edac_pci_dev;
+	edac_pci_dev= (struct edac_pci_dev_attribute*)attr;
+
+	if (edac_pci_dev->show)
+		return edac_pci_dev->store(edac_pci_dev->value, buffer, count);
+	return -EIO;
+}
+
+static struct sysfs_ops edac_pci_sysfs_ops = {
+	.show   = edac_pci_dev_show,
+	.store  = edac_pci_dev_store
+};
+
+#define EDAC_PCI_ATTR(_name,_mode,_show,_store)			\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = &_name,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+#define EDAC_PCI_STRING_ATTR(_name,_data,_mode,_show,_store)	\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.value  = _data,					\
+	.show   = _show,					\
+	.store  = _store,					\
+};
+
+/* PCI Parity control files */
+EDAC_PCI_ATTR(check_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
+	edac_pci_int_store);
+EDAC_PCI_ATTR(panic_on_pci_parity, S_IRUGO|S_IWUSR, edac_pci_int_show,
+	edac_pci_int_store);
+EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
+
+/* Base Attributes of the memory ECC object */
+static struct edac_pci_dev_attribute *edac_pci_attr[] = {
+	&edac_pci_attr_check_pci_parity,
+	&edac_pci_attr_panic_on_pci_parity,
+	&edac_pci_attr_pci_parity_count,
+	NULL,
+};
+
+/* No memory to release */
+static void edac_pci_release(struct kobject *kobj)
+{
+	debugf1("%s()\n", __func__);
+	complete(&edac_pci_kobj_complete);
+}
+
+static struct kobj_type ktype_edac_pci = {
+	.release = edac_pci_release,
+	.sysfs_ops = &edac_pci_sysfs_ops,
+	.default_attrs = (struct attribute **) edac_pci_attr,
+};
+
+/**
+ * edac_sysfs_pci_setup()
+ *
+ *	setup the sysfs for EDAC PCI attributes
+ *	assumes edac_class has already been initialized
+ */
+int edac_sysfs_pci_setup(void)
+{
+	int err;
+	struct sysdev_class *edac_class;
+
+	debugf1("%s()\n", __func__);
+
+	edac_class = edac_get_edac_class();
+
+	memset(&edac_pci_kobj, 0, sizeof(edac_pci_kobj));
+	edac_pci_kobj.parent = &edac_class->kset.kobj;
+	edac_pci_kobj.ktype = &ktype_edac_pci;
+	err = kobject_set_name(&edac_pci_kobj, "pci");
+
+	if (!err) {
+		/* Instanstiate the pci object */
+		/* FIXME: maybe new sysdev_create_subdir() */
+		err = kobject_register(&edac_pci_kobj);
+
+		if (err)
+			debugf1("Failed to register '.../edac/pci'\n");
+		else
+			debugf1("Registered '.../edac/pci' kobject\n");
+	}
+
+	return err;
+}
+
+/*
+ * edac_sysfs_pci_teardown
+ *
+ *	perform the sysfs teardown for the PCI attributes
+ */
+void edac_sysfs_pci_teardown(void)
+{
+	debugf0("%s()\n", __func__);
+	init_completion(&edac_pci_kobj_complete);
+	kobject_unregister(&edac_pci_kobj);
+	wait_for_completion(&edac_pci_kobj_complete);
+}
+
+
+static u16 get_pci_parity_status(struct pci_dev *dev, int secondary)
+{
+	int where;
+	u16 status;
+
+	where = secondary ? PCI_SEC_STATUS : PCI_STATUS;
+	pci_read_config_word(dev, where, &status);
+
+	/* If we get back 0xFFFF then we must suspect that the card has been
+	 * pulled but the Linux PCI layer has not yet finished cleaning up.
+	 * We don't want to report on such devices
+	 */
+
+	if (status == 0xFFFF) {
+		u32 sanity;
+
+		pci_read_config_dword(dev, 0, &sanity);
+
+		if (sanity == 0xFFFFFFFF)
+			return 0;
+	}
+
+	status &= PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR |
+		PCI_STATUS_PARITY;
+
+	if (status)
+		/* reset only the bits we are interested in */
+		pci_write_config_word(dev, where, status);
+
+	return status;
+}
+
+typedef void (*pci_parity_check_fn_t) (struct pci_dev *dev);
+
+/* Clear any PCI parity errors logged by this device. */
+static void edac_pci_dev_parity_clear(struct pci_dev *dev)
+{
+	u8 header_type;
+
+	get_pci_parity_status(dev, 0);
+
+	/* read the device TYPE, looking for bridges */
+	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
+
+	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE)
+		get_pci_parity_status(dev, 1);
+}
+
+/*
+ *  PCI Parity polling
+ *
+ */
+static void edac_pci_dev_parity_test(struct pci_dev *dev)
+{
+	u16 status;
+	u8  header_type;
+
+	/* read the STATUS register on this device
+	 */
+	status = get_pci_parity_status(dev, 0);
+
+	debugf2("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id );
+
+	/* check the status reg for errors */
+	if (status) {
+		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
+			edac_printk(KERN_CRIT, EDAC_PCI,
+				"Signaled System Error on %s\n",
+				pci_name(dev));
+
+		if (status & (PCI_STATUS_PARITY)) {
+			edac_printk(KERN_CRIT, EDAC_PCI,
+				"Master Data Parity Error on %s\n",
+				pci_name(dev));
+
+			atomic_inc(&pci_parity_count);
+		}
+
+		if (status & (PCI_STATUS_DETECTED_PARITY)) {
+			edac_printk(KERN_CRIT, EDAC_PCI,
+				"Detected Parity Error on %s\n",
+				pci_name(dev));
+
+			atomic_inc(&pci_parity_count);
+		}
+	}
+
+	/* read the device TYPE, looking for bridges */
+	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
+
+	debugf2("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id );
+
+	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+		/* On bridges, need to examine secondary status register  */
+		status = get_pci_parity_status(dev, 1);
+
+		debugf2("PCI SEC_STATUS= 0x%04x %s\n",
+				status, dev->dev.bus_id );
+
+		/* check the secondary status reg for errors */
+		if (status) {
+			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR))
+				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
+					"Signaled System Error on %s\n",
+					pci_name(dev));
+
+			if (status & (PCI_STATUS_PARITY)) {
+				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
+					"Master Data Parity Error on "
+					"%s\n", pci_name(dev));
+
+				atomic_inc(&pci_parity_count);
+			}
+
+			if (status & (PCI_STATUS_DETECTED_PARITY)) {
+				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
+					"Detected Parity Error on %s\n",
+					pci_name(dev));
+
+				atomic_inc(&pci_parity_count);
+			}
+		}
+	}
+}
+
+/*
+ * pci_dev parity list iterator
+ *	Scan the PCI device list for one iteration, looking for SERRORs
+ *	Master Parity ERRORS or Parity ERRORs on primary or secondary devices
+ */
+static inline void edac_pci_dev_parity_iterator(pci_parity_check_fn_t fn)
+{
+	struct pci_dev *dev = NULL;
+
+	/* request for kernel access to the next PCI device, if any,
+	 * and while we are looking at it have its reference count
+	 * bumped until we are done with it
+	 */
+	while((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		fn(dev);
+	}
+}
+
+/*
+ * edac_pci_do_parity_check
+ *
+ *	performs the actual PCI parity check operation
+ */
+void edac_pci_do_parity_check(void)
+{
+	unsigned long flags;
+	int before_count;
+
+	debugf3("%s()\n", __func__);
+
+	if (!check_pci_parity)
+		return;
+
+	before_count = atomic_read(&pci_parity_count);
+
+	/* scan all PCI devices looking for a Parity Error on devices and
+	 * bridges
+	 */
+	local_irq_save(flags);
+	edac_pci_dev_parity_iterator(edac_pci_dev_parity_test);
+	local_irq_restore(flags);
+
+	/* Only if operator has selected panic on PCI Error */
+	if (panic_on_pci_parity) {
+		/* If the count is different 'after' from 'before' */
+		if (before_count != atomic_read(&pci_parity_count))
+			panic("EDAC: PCI Parity Error");
+	}
+}
+
+void edac_pci_clear_parity_errors(void)
+{
+	/* Clear any PCI bus parity errors that devices initially have logged
+	 * in their registers.
+	 */
+	edac_pci_dev_parity_iterator(edac_pci_dev_parity_clear);
+}
+
+
+/*
+ * Define the PCI parameter to the module
+ */
+module_param(check_pci_parity, int, 0644);
+MODULE_PARM_DESC(check_pci_parity, "Check for PCI bus parity errors: 0=off 1=on");
+module_param(panic_on_pci_parity, int, 0644);
+MODULE_PARM_DESC(panic_on_pci_parity, "Panic on PCI Bus Parity error: 0=off 1=on");
+
+#endif	/* CONFIG_PCI */
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
