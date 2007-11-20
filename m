From: akpm@linux-foundation.org
Subject: + m68k-kill-arch-m68k-atari-atari_ksymsc.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:07 -0800
Message-ID: <200711200215.lAK2F7nb008961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762613AbXKTCPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: kill arch/m68k/atari/atari_ksyms.c
has been added to the -mm tree.  Its filename is
     m68k-kill-arch-m68k-atari-atari_ksymsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: kill arch/m68k/atari/atari_ksyms.c
From: Adrian Bunk <bunk@kernel.org>

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/atari/Makefile      |    2 -
 arch/m68k/atari/ataints.c     |    3 ++
 arch/m68k/atari/atari_ksyms.c |   35 --------------------------------
 arch/m68k/atari/atasound.c    |    2 +
 arch/m68k/atari/config.c      |   11 ++++++++++
 arch/m68k/atari/debug.c       |    6 +++++
 arch/m68k/atari/stdma.c       |    5 ++++
 arch/m68k/atari/stram.c       |    3 ++
 8 files changed, 31 insertions(+), 36 deletions(-)

diff -puN arch/m68k/atari/Makefile~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/Makefile
--- a/arch/m68k/atari/Makefile~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y		:= config.o time.o debug.o ataints.o stdma.o \
-			atasound.o stram.o atari_ksyms.o
+			atasound.o stram.o
 
 ifeq ($(CONFIG_PCI),y)
 obj-$(CONFIG_HADES)	+= hades-pci.o
diff -puN arch/m68k/atari/ataints.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/ataints.c
--- a/arch/m68k/atari/ataints.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/ataints.c
@@ -40,6 +40,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
 #include <linux/seq_file.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 #include <asm/traps.h>
@@ -446,6 +447,7 @@ unsigned long atari_register_vme_int(voi
 	free_vme_vec_bitmap |= 1 << i;
 	return VME_SOURCE_BASE + i;
 }
+EXPORT_SYMBOL(atari_register_vme_int);
 
 
 void atari_unregister_vme_int(unsigned long irq)
@@ -455,5 +457,6 @@ void atari_unregister_vme_int(unsigned l
 		free_vme_vec_bitmap &= ~(1 << irq);
 	}
 }
+EXPORT_SYMBOL(atari_unregister_vme_int);
 
 
diff -puN arch/m68k/atari/atari_ksyms.c~m68k-kill-arch-m68k-atari-atari_ksymsc /dev/null
--- a/arch/m68k/atari/atari_ksyms.c
+++ /dev/null
@@ -1,35 +0,0 @@
-#include <linux/module.h>
-
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-#include <asm/atarihw.h>
-#include <asm/atariints.h>
-#include <asm/atarikb.h>
-#include <asm/atari_joystick.h>
-#include <asm/atari_stdma.h>
-#include <asm/atari_stram.h>
-
-extern void atari_microwire_cmd( int cmd );
-extern int atari_MFP_init_done;
-extern int atari_SCC_init_done;
-extern int atari_SCC_reset_done;
-
-EXPORT_SYMBOL(atari_mch_cookie);
-EXPORT_SYMBOL(atari_mch_type);
-EXPORT_SYMBOL(atari_hw_present);
-EXPORT_SYMBOL(atari_switches);
-EXPORT_SYMBOL(atari_dont_touch_floppy_select);
-EXPORT_SYMBOL(atari_register_vme_int);
-EXPORT_SYMBOL(atari_unregister_vme_int);
-EXPORT_SYMBOL(stdma_lock);
-EXPORT_SYMBOL(stdma_release);
-EXPORT_SYMBOL(stdma_others_waiting);
-EXPORT_SYMBOL(stdma_islocked);
-EXPORT_SYMBOL(atari_stram_alloc);
-EXPORT_SYMBOL(atari_stram_free);
-
-EXPORT_SYMBOL(atari_MFP_init_done);
-EXPORT_SYMBOL(atari_SCC_init_done);
-EXPORT_SYMBOL(atari_SCC_reset_done);
-
-EXPORT_SYMBOL(atari_microwire_cmd);
diff -puN arch/m68k/atari/atasound.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/atasound.c
--- a/arch/m68k/atari/atasound.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/atasound.c
@@ -22,6 +22,7 @@
 #include <linux/fcntl.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include <asm/atarihw.h>
 #include <asm/system.h>
@@ -43,6 +44,7 @@ void atari_microwire_cmd (int cmd)
 	while( tt_microwire.mask != 0x7ff)
 		;
 }
+EXPORT_SYMBOL(atari_microwire_cmd);
 
 
 /* PSG base frequency */
diff -puN arch/m68k/atari/config.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/config.c
--- a/arch/m68k/atari/config.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/config.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/vt_kern.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
@@ -43,10 +44,20 @@
 #include <asm/io.h>
 
 u_long atari_mch_cookie;
+EXPORT_SYMBOL(atari_mch_cookie);
+
 u_long atari_mch_type;
+EXPORT_SYMBOL(atari_mch_type);
+
 struct atari_hw_present atari_hw_present;
+EXPORT_SYMBOL(atari_hw_present);
+
 u_long atari_switches;
+EXPORT_SYMBOL(atari_switches);
+
 int atari_dont_touch_floppy_select;
+EXPORT_SYMBOL(atari_dont_touch_floppy_select);
+
 int atari_rtc_year_offset;
 
 /* local function prototypes */
diff -puN arch/m68k/atari/debug.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/debug.c
--- a/arch/m68k/atari/debug.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/debug.c
@@ -15,17 +15,23 @@
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 
 /* Flag that Modem1 port is already initialized and used */
 int atari_MFP_init_done;
+EXPORT_SYMBOL(atari_MFP_init_done);
+
 /* Flag that Modem1 port is already initialized and used */
 int atari_SCC_init_done;
+EXPORT_SYMBOL(atari_SCC_init_done);
+
 /* Can be set somewhere, if a SCC master reset has already be done and should
  * not be repeated; used by kgdb */
 int atari_SCC_reset_done;
+EXPORT_SYMBOL(atari_SCC_reset_done);
 
 static struct console atari_console_driver = {
 	.name	= "debug",
diff -puN arch/m68k/atari/stdma.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/stdma.c
--- a/arch/m68k/atari/stdma.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/stdma.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/module.h>
 
 #include <asm/atari_stdma.h>
 #include <asm/atariints.h>
@@ -91,6 +92,7 @@ void stdma_lock(irq_handler_t handler, v
 	stdma_isr_data = data;
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(stdma_lock);
 
 
 /*
@@ -117,6 +119,7 @@ void stdma_release(void)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(stdma_release);
 
 
 /*
@@ -134,6 +137,7 @@ int stdma_others_waiting(void)
 {
 	return waitqueue_active(&stdma_wait);
 }
+EXPORT_SYMBOL(stdma_others_waiting);
 
 
 /*
@@ -155,6 +159,7 @@ int stdma_islocked(void)
 {
 	return stdma_locked;
 }
+EXPORT_SYMBOL(stdma_islocked);
 
 
 /*
diff -puN arch/m68k/atari/stram.c~m68k-kill-arch-m68k-atari-atari_ksymsc arch/m68k/atari/stram.c
--- a/arch/m68k/atari/stram.c~m68k-kill-arch-m68k-atari-atari_ksymsc
+++ a/arch/m68k/atari/stram.c
@@ -20,6 +20,7 @@
 #include <linux/bootmem.h>
 #include <linux/mount.h>
 #include <linux/blkdev.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/machdep.h>
@@ -208,6 +209,7 @@ void *atari_stram_alloc(long size, const
 	}
 	return( addr );
 }
+EXPORT_SYMBOL(atari_stram_alloc);
 
 void atari_stram_free( void *addr )
 
@@ -237,6 +239,7 @@ void atari_stram_free( void *addr )
 	printk( KERN_ERR "atari_stram_free: cannot free block at %p "
 			"(called from %p)\n", addr, __builtin_return_address(0) );
 }
+EXPORT_SYMBOL(atari_stram_free);
 
 
 /* ------------------------------------------------------------------------ */
_

Patches currently in -mm which might be from bunk@kernel.org are

m68k-export-atari_keyb_init.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
