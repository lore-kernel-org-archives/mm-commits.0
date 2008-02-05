From: akpm@linux-foundation.org
Subject: - m68k-kill-arch-m68k-mac-mac_ksymsc.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:41 -0800
Message-ID: <200802052234.m15MYMr5012524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761066AbYBEWmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: kill arch/m68k/mac/mac_ksyms.c
has been removed from the -mm tree.  Its filename was
     m68k-kill-arch-m68k-mac-mac_ksymsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: kill arch/m68k/mac/mac_ksyms.c
From: Adrian Bunk <bunk@kernel.org>

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mac/Makefile    |    2 +-
 arch/m68k/mac/mac_ksyms.c |    8 --------
 arch/m68k/mac/via.c       |    5 ++++-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/m68k/mac/Makefile~m68k-kill-arch-m68k-mac-mac_ksymsc arch/m68k/mac/Makefile
--- a/arch/m68k/mac/Makefile~m68k-kill-arch-m68k-mac-mac_ksymsc
+++ a/arch/m68k/mac/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y		:= config.o bootparse.o macints.o iop.o via.o oss.o psc.o \
-			baboon.o macboing.o debug.o misc.o mac_ksyms.o
+			baboon.o macboing.o debug.o misc.o
diff -puN arch/m68k/mac/mac_ksyms.c~m68k-kill-arch-m68k-mac-mac_ksymsc /dev/null
--- a/arch/m68k/mac/mac_ksyms.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-
-/* Says whether we're using A/UX interrupts or not */
-extern int via_alt_mapping;
-
-EXPORT_SYMBOL(via_alt_mapping);
diff -puN arch/m68k/mac/via.c~m68k-kill-arch-m68k-mac-mac_ksymsc arch/m68k/mac/via.c
--- a/arch/m68k/mac/via.c~m68k-kill-arch-m68k-mac-mac_ksymsc
+++ a/arch/m68k/mac/via.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
@@ -41,7 +42,9 @@ volatile __u8 *via1, *via2;
 /* See note in mac_via.h about how this is possibly not useful */
 volatile long *via_memory_bogon=(long *)&via_memory_bogon;
 #endif
-int rbv_present, via_alt_mapping;
+int rbv_present;
+int via_alt_mapping;
+EXPORT_SYMBOL(via_alt_mapping);
 __u8 rbv_clear;
 
 /*
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
