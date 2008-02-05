From: akpm@linux-foundation.org
Subject: - m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:51 -0800
Message-ID: <200802052234.m15MYW5u012536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120AbYBEWmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
has been removed from the -mm tree.  Its filename was
     m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
From: Adrian Bunk <bunk@kernel.org>

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mvme16x/Makefile        |    2 +-
 arch/m68k/mvme16x/config.c        |    2 ++
 arch/m68k/mvme16x/mvme16x_ksyms.c |    6 ------
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/m68k/mvme16x/Makefile~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc arch/m68k/mvme16x/Makefile
--- a/arch/m68k/mvme16x/Makefile~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc
+++ a/arch/m68k/mvme16x/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/mvme16x source directory
 #
 
-obj-y		:= config.o rtc.o mvme16x_ksyms.o
+obj-y		:= config.o rtc.o
diff -puN arch/m68k/mvme16x/config.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc arch/m68k/mvme16x/config.c
--- a/arch/m68k/mvme16x/config.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc
+++ a/arch/m68k/mvme16x/config.c
@@ -25,6 +25,7 @@
 #include <linux/genhd.h>
 #include <linux/rtc.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/system.h>
@@ -58,6 +59,7 @@ static irq_handler_t tick_handler;
 
 
 unsigned short mvme16x_config;
+EXPORT_SYMBOL(mvme16x_config);
 
 
 int mvme16x_parse_bootinfo(const struct bi_record *bi)
diff -puN arch/m68k/mvme16x/mvme16x_ksyms.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc /dev/null
--- a/arch/m68k/mvme16x/mvme16x_ksyms.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/mvme16xhw.h>
-
-EXPORT_SYMBOL(mvme16x_config);
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
