From: akpm@linux-foundation.org
Subject: - m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:45 -0800
Message-ID: <200802052234.m15MYQk2012530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216AbYBEWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: kill arch/m68k/amiga/amiga_ksyms.c
has been removed from the -mm tree.  Its filename was
     m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: kill arch/m68k/amiga/amiga_ksyms.c
From: Adrian Bunk <bunk@kernel.org>

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/Makefile      |    2 -
 arch/m68k/amiga/amiga_ksyms.c |   33 --------------------------------
 arch/m68k/amiga/amisound.c    |    3 ++
 arch/m68k/amiga/chipram.c     |    7 ++++++
 arch/m68k/amiga/config.c      |   12 +++++++++++
 arch/m68k/amiga/pcmcia.c      |    9 ++++++++
 6 files changed, 32 insertions(+), 34 deletions(-)

diff -puN arch/m68k/amiga/Makefile~m68k-kill-arch-m68k-amiga-amiga_ksymsc arch/m68k/amiga/Makefile
--- a/arch/m68k/amiga/Makefile~m68k-kill-arch-m68k-amiga-amiga_ksymsc
+++ a/arch/m68k/amiga/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Linux arch/m68k/amiga source directory
 #
 
-obj-y		:= config.o amiints.o cia.o chipram.o amisound.o amiga_ksyms.o
+obj-y		:= config.o amiints.o cia.o chipram.o amisound.o
 
 obj-$(CONFIG_AMIGA_PCMCIA)	+= pcmcia.o
diff -puN arch/m68k/amiga/amiga_ksyms.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc /dev/null
--- a/arch/m68k/amiga/amiga_ksyms.c
+++ /dev/null
@@ -1,33 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/amigahw.h>
-#include <asm/amigaints.h>
-#include <asm/amipcmcia.h>
-
-extern volatile u_short amiga_audio_min_period;
-extern u_short amiga_audio_period;
-
-/*
- * Add things here when you find the need for it.
- */
-EXPORT_SYMBOL(amiga_model);
-EXPORT_SYMBOL(amiga_chipset);
-EXPORT_SYMBOL(amiga_hw_present);
-EXPORT_SYMBOL(amiga_eclock);
-EXPORT_SYMBOL(amiga_colorclock);
-EXPORT_SYMBOL(amiga_chip_alloc);
-EXPORT_SYMBOL(amiga_chip_free);
-EXPORT_SYMBOL(amiga_chip_avail);
-EXPORT_SYMBOL(amiga_chip_size);
-EXPORT_SYMBOL(amiga_audio_period);
-EXPORT_SYMBOL(amiga_audio_min_period);
-
-#ifdef CONFIG_AMIGA_PCMCIA
-  EXPORT_SYMBOL(pcmcia_reset);
-  EXPORT_SYMBOL(pcmcia_copy_tuple);
-  EXPORT_SYMBOL(pcmcia_program_voltage);
-  EXPORT_SYMBOL(pcmcia_access_speed);
-  EXPORT_SYMBOL(pcmcia_write_enable);
-  EXPORT_SYMBOL(pcmcia_write_disable);
-#endif
diff -puN arch/m68k/amiga/amisound.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc arch/m68k/amiga/amisound.c
--- a/arch/m68k/amiga/amisound.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc
+++ a/arch/m68k/amiga/amisound.c
@@ -12,6 +12,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 #include <asm/amigahw.h>
@@ -31,6 +32,7 @@ static const signed char sine_data[] = {
      */
 
 volatile unsigned short amiga_audio_min_period = 124; /* Default for pre-OCS */
+EXPORT_SYMBOL(amiga_audio_min_period);
 
 #define MAX_PERIOD	(65535)
 
@@ -40,6 +42,7 @@ volatile unsigned short amiga_audio_min_
      */
 
 unsigned short amiga_audio_period = MAX_PERIOD;
+EXPORT_SYMBOL(amiga_audio_period);
 
 static unsigned long clock_constant;
 
diff -puN arch/m68k/amiga/chipram.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc arch/m68k/amiga/chipram.c
--- a/arch/m68k/amiga/chipram.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc
+++ a/arch/m68k/amiga/chipram.c
@@ -13,10 +13,13 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/module.h>
+
 #include <asm/page.h>
 #include <asm/amigahw.h>
 
 unsigned long amiga_chip_size;
+EXPORT_SYMBOL(amiga_chip_size);
 
 static struct resource chipram_res = {
     .name = "Chip RAM", .start = CHIP_PHYSADDR
@@ -67,6 +70,7 @@ void *amiga_chip_alloc(unsigned long siz
 #endif
     return (void *)ZTWO_VADDR(res->start);
 }
+EXPORT_SYMBOL(amiga_chip_alloc);
 
 
     /*
@@ -120,6 +124,7 @@ void amiga_chip_free(void *ptr)
     }
     printk("amiga_chip_free: trying to free nonexistent region at %p\n", ptr);
 }
+EXPORT_SYMBOL(amiga_chip_free);
 
 
 unsigned long amiga_chip_avail(void)
@@ -129,3 +134,5 @@ unsigned long amiga_chip_avail(void)
 #endif
 	return chipavail;
 }
+EXPORT_SYMBOL(amiga_chip_avail);
+
diff -puN arch/m68k/amiga/config.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc
+++ a/arch/m68k/amiga/config.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/zorro.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
@@ -36,13 +37,24 @@
 #include <asm/io.h>
 
 unsigned long amiga_model;
+EXPORT_SYMBOL(amiga_model);
+
 unsigned long amiga_eclock;
+EXPORT_SYMBOL(amiga_eclock);
+
 unsigned long amiga_masterclock;
+
 unsigned long amiga_colorclock;
+EXPORT_SYMBOL(amiga_colorclock);
+
 unsigned long amiga_chipset;
+EXPORT_SYMBOL(amiga_chipset);
+
 unsigned char amiga_vblank;
 unsigned char amiga_psfreq;
+
 struct amiga_hw_present amiga_hw_present;
+EXPORT_SYMBOL(amiga_hw_present);
 
 static char s_a500[] __initdata = "A500";
 static char s_a500p[] __initdata = "A500+";
diff -puN arch/m68k/amiga/pcmcia.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc arch/m68k/amiga/pcmcia.c
--- a/arch/m68k/amiga/pcmcia.c~m68k-kill-arch-m68k-amiga-amiga_ksymsc
+++ a/arch/m68k/amiga/pcmcia.c
@@ -15,6 +15,8 @@
 #include <linux/types.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
+#include <linux/module.h>
+
 #include <asm/amigayle.h>
 #include <asm/amipcmcia.h>
 
@@ -30,6 +32,7 @@ void pcmcia_reset(void)
 	while (time_before(jiffies, reset_start_time + 1*HZ/100));
 	b = gayle_reset;
 }
+EXPORT_SYMBOL(pcmcia_reset);
 
 
 /* copy a tuple, including tuple header. return nb bytes copied */
@@ -61,6 +64,7 @@ int pcmcia_copy_tuple(unsigned char tupl
 
 	return 0;
 }
+EXPORT_SYMBOL(pcmcia_copy_tuple);
 
 void pcmcia_program_voltage(int voltage)
 {
@@ -84,6 +88,7 @@ void pcmcia_program_voltage(int voltage)
 	gayle.config = cfg_byte;
 
 }
+EXPORT_SYMBOL(pcmcia_program_voltage);
 
 void pcmcia_access_speed(int speed)
 {
@@ -101,13 +106,17 @@ void pcmcia_access_speed(int speed)
 	cfg_byte = (cfg_byte & 0xf3) | s;
 	gayle.config = cfg_byte;
 }
+EXPORT_SYMBOL(pcmcia_access_speed);
 
 void pcmcia_write_enable(void)
 {
 	gayle.cardstatus = GAYLE_CS_WR|GAYLE_CS_DA;
 }
+EXPORT_SYMBOL(pcmcia_write_enable);
 
 void pcmcia_write_disable(void)
 {
 	gayle.cardstatus = 0;
 }
+EXPORT_SYMBOL(pcmcia_write_disable);
+
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
deprecate-smbfs-in-favour-of-cifs.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
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
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
