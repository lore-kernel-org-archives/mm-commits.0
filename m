From: akpm@linux-foundation.org
Subject: + video-sis-remove-compat-code.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:25 -0700
Message-ID: <200805061836.m46IaPuQ021209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbYEFSgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, thomas@winischhofer.net


The patch titled
     video/sis/: remove compat code
has been added to the -mm tree.  Its filename is
     video-sis-remove-compat-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/sis/: remove compat code
From: Adrian Bunk <bunk@kernel.org>

This patch removes compat code for older kernel versions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/init.h       |    1 
 drivers/video/sis/init301.h    |    1 
 drivers/video/sis/initextlfb.c |    1 
 drivers/video/sis/osdef.h      |    1 
 drivers/video/sis/sis.h        |   22 +++------------
 drivers/video/sis/sis_accel.c  |    1 
 drivers/video/sis/sis_main.c   |   44 +++++++------------------------
 drivers/video/sis/sis_main.h   |    4 +-
 drivers/video/sis/vgatypes.h   |    4 --
 9 files changed, 17 insertions(+), 62 deletions(-)

diff -puN drivers/video/sis/init.h~video-sis-remove-compat-code drivers/video/sis/init.h
--- a/drivers/video/sis/init.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/init.h
@@ -73,7 +73,6 @@
 #ifdef SIS_CP
 #undef SIS_CP
 #endif
-#include <linux/version.h>
 #include <linux/types.h>
 #include <asm/io.h>
 #include <linux/fb.h>
diff -puN drivers/video/sis/init301.h~video-sis-remove-compat-code drivers/video/sis/init301.h
--- a/drivers/video/sis/init301.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/init301.h
@@ -67,7 +67,6 @@
 #ifdef SIS_CP
 #undef SIS_CP
 #endif
-#include <linux/version.h>
 #include <linux/types.h>
 #include <asm/io.h>
 #include <linux/fb.h>
diff -puN drivers/video/sis/initextlfb.c~video-sis-remove-compat-code drivers/video/sis/initextlfb.c
--- a/drivers/video/sis/initextlfb.c~video-sis-remove-compat-code
+++ a/drivers/video/sis/initextlfb.c
@@ -30,7 +30,6 @@
 #include "vgatypes.h"
 #include "vstruct.h"
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/fb.h>
 
diff -puN drivers/video/sis/osdef.h~video-sis-remove-compat-code drivers/video/sis/osdef.h
--- a/drivers/video/sis/osdef.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/osdef.h
@@ -87,7 +87,6 @@
 /**********************************************************************/
 
 #ifdef SIS_LINUX_KERNEL
-#include <linux/version.h>
 
 #ifdef CONFIG_FB_SIS_300
 #define SIS300
diff -puN drivers/video/sis/sis.h~video-sis-remove-compat-code drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/sis.h
@@ -24,8 +24,6 @@
 #ifndef _SIS_H_
 #define _SIS_H_
 
-#include <linux/version.h>
-
 #include "osdef.h"
 #include <video/sisfb.h>
 
@@ -42,16 +40,6 @@
 #define SIS_NEW_CONFIG_COMPAT
 #endif	/* CONFIG_COMPAT */
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
-#define SIS_IOTYPE1 void __iomem
-#define SIS_IOTYPE2 __iomem
-#define SISINITSTATIC static
-#else
-#define SIS_IOTYPE1 unsigned char
-#define SIS_IOTYPE2
-#define SISINITSTATIC
-#endif
-
 #undef SISFBDEBUG
 
 #ifdef SISFBDEBUG
@@ -505,8 +493,8 @@ struct sis_video_info {
 
 	unsigned long	UMAsize, LFBsize;
 
-	SIS_IOTYPE1	*video_vbase;
-	SIS_IOTYPE1	*mmio_vbase;
+	void __iomem	*video_vbase;
+	void __iomem	*mmio_vbase;
 
 	unsigned char	*bios_abase;
 
@@ -533,8 +521,8 @@ struct sis_video_info {
 	int		sisfb_nocrt2rate;
 
 	u32		heapstart;		/* offset  */
-	SIS_IOTYPE1	*sisfb_heap_start;	/* address */
-	SIS_IOTYPE1	*sisfb_heap_end;	/* address */
+	void __iomem	*sisfb_heap_start;	/* address */
+	void __iomem	*sisfb_heap_end;	/* address */
 	u32		sisfb_heap_size;
 	int		havenoheap;
 
@@ -612,7 +600,7 @@ struct sis_video_info {
 	u8		detectedpdca;
 	u8		detectedlcda;
 
-	SIS_IOTYPE1	*hwcursor_vbase;
+	void __iomem	*hwcursor_vbase;
 
 	int		chronteltype;
 	int		tvxpos, tvypos;
diff -puN drivers/video/sis/sis_accel.c~video-sis-remove-compat-code drivers/video/sis/sis_accel.c
--- a/drivers/video/sis/sis_accel.c~video-sis-remove-compat-code
+++ a/drivers/video/sis/sis_accel.c
@@ -28,7 +28,6 @@
  *			for more information and updates)
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/fb.h>
diff -puN drivers/video/sis/sis_main.c~video-sis-remove-compat-code drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~video-sis-remove-compat-code
+++ a/drivers/video/sis/sis_main.c
@@ -33,7 +33,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -41,13 +40,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17)
-#include <linux/tty.h>
-#else
 #include <linux/screen_info.h>
-#endif
-
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/selection.h>
@@ -1167,11 +1160,7 @@ sisfb_set_mode(struct sis_video_info *iv
 	unsigned short modeno = ivideo->mode_no;
 
 	/* >=2.6.12's fbcon clears the screen anyway */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)
-	if(!clrscrn) modeno |= 0x80;
-#else
 	modeno |= 0x80;
-#endif
 
 	outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
 
@@ -1436,11 +1425,8 @@ sisfb_set_par(struct fb_info *info)
 	if((err = sisfb_do_set_var(&info->var, 1, info)))
 		return err;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,10)
-	sisfb_get_fix(&info->fix, info->currcon, info);
-#else
 	sisfb_get_fix(&info->fix, -1, info);
-#endif
+
 	return 0;
 }
 
@@ -1676,14 +1662,8 @@ sisfb_blank(int blank, struct fb_info *i
 
 /* ----------- FBDev related routines for all series ---------- */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,15)
 static int	sisfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg)
-#else
-static int	sisfb_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg,
-				struct fb_info *info)
-#endif
 {
 	struct sis_video_info	*ivideo = (struct sis_video_info *)info->par;
 	struct sis_memreq	sismemreq;
@@ -3986,8 +3966,7 @@ sisfb_handle_command(struct sis_video_in
 }
 
 #ifndef MODULE
-SISINITSTATIC int __init
-sisfb_setup(char *options)
+static int __init sisfb_setup(char *options)
 {
 	char *this_opt;
 
@@ -4086,9 +4065,9 @@ sisfb_setup(char *options)
 #endif
 
 static int __devinit
-sisfb_check_rom(SIS_IOTYPE1 *rom_base, struct sis_video_info *ivideo)
+sisfb_check_rom(void __iomem *rom_base, struct sis_video_info *ivideo)
 {
-	SIS_IOTYPE1 *rom;
+	void __iomem *rom;
 	int romptr;
 
 	if((readb(rom_base) != 0x55) || (readb(rom_base + 1) != 0xaa))
@@ -4117,10 +4096,9 @@ static unsigned char * __devinit
 sisfb_find_rom(struct pci_dev *pdev)
 {
 	struct sis_video_info *ivideo = pci_get_drvdata(pdev);
-	SIS_IOTYPE1 *rom_base;
+	void __iomem *rom_base;
 	unsigned char *myrombase = NULL;
 	u32 temp;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 	size_t romsize;
 
 	/* First, try the official pci ROM functions (except
@@ -4151,7 +4129,6 @@ sisfb_find_rom(struct pci_dev *pdev)
 	}
 
 	if(myrombase) return myrombase;
-#endif
 
 	/* Otherwise do it the conventional way. */
 
@@ -4225,7 +4202,7 @@ sisfb_post_map_vram(struct sis_video_inf
 static int __devinit
 sisfb_post_300_buswidth(struct sis_video_info *ivideo)
 {
-	SIS_IOTYPE1 *FBAddress = ivideo->video_vbase;
+	void __iomem *FBAddress = ivideo->video_vbase;
 	unsigned short temp;
 	unsigned char reg;
 	int i, j;
@@ -4273,7 +4250,7 @@ sisfb_post_300_rwtest(struct sis_video_i
 			int PseudoRankCapacity, int PseudoAdrPinCount,
 			unsigned int mapsize)
 {
-	SIS_IOTYPE1 *FBAddr = ivideo->video_vbase;
+	void __iomem *FBAddr = ivideo->video_vbase;
 	unsigned short sr14;
 	unsigned int k, RankCapacity, PageCapacity, BankNumHigh, BankNumMid;
 	unsigned int PhysicalAdrOtherPage, PhysicalAdrHigh, PhysicalAdrHalfPage;
@@ -5829,7 +5806,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 	ivideo->engineok = 0;
 
 	ivideo->sisfb_was_boot_device = 0;
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
+
 	if(pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW) {
 		if(ivideo->sisvga_enabled)
 			ivideo->sisfb_was_boot_device = 1;
@@ -5840,7 +5817,6 @@ sisfb_probe(struct pci_dev *pdev, const 
 				"as the primary VGA device\n");
 		}
 	}
-#endif
 
 	ivideo->sisfb_parm_mem = sisfb_parm_mem;
 	ivideo->sisfb_accel = sisfb_accel;
@@ -6010,7 +5986,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 		ivideo->modeprechange = reg & 0x7f;
 	} else if(ivideo->sisvga_enabled) {
 #if defined(__i386__) || defined(__x86_64__)
-		unsigned char SIS_IOTYPE2 *tt = ioremap(0x400, 0x100);
+		unsigned char __iomem *tt = ioremap(0x400, 0x100);
 		if(tt) {
 			ivideo->modeprechange = readb(tt + 0x49);
 			iounmap(tt);
@@ -6503,7 +6479,7 @@ static struct pci_driver sisfb_driver = 
 	.remove 	= __devexit_p(sisfb_remove)
 };
 
-SISINITSTATIC int __init sisfb_init(void)
+static int __init sisfb_init(void)
 {
 #ifndef MODULE
 	char *options = NULL;
diff -puN drivers/video/sis/sis_main.h~video-sis-remove-compat-code drivers/video/sis/sis_main.h
--- a/drivers/video/sis/sis_main.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/sis_main.h
@@ -665,11 +665,11 @@ static struct _customttable {
 
 /* Interface used by the world */
 #ifndef MODULE
-SISINITSTATIC int sisfb_setup(char *options);
+static int sisfb_setup(char *options);
 #endif
 
 /* Interface to the low level console driver */
-SISINITSTATIC int sisfb_init(void);
+static int sisfb_init(void);
 
 /* fbdev routines */
 static int	sisfb_get_fix(struct fb_fix_screeninfo *fix, int con,
diff -puN drivers/video/sis/vgatypes.h~video-sis-remove-compat-code drivers/video/sis/vgatypes.h
--- a/drivers/video/sis/vgatypes.h~video-sis-remove-compat-code
+++ a/drivers/video/sis/vgatypes.h
@@ -53,10 +53,6 @@
 #ifndef _VGATYPES_H_
 #define _VGATYPES_H_
 
-#ifdef SIS_LINUX_KERNEL
-#include <linux/version.h>
-#endif
-
 #define SISIOMEMTYPE
 
 #ifdef SIS_LINUX_KERNEL
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

