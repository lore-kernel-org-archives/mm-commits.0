From: akpm@linux-foundation.org
Subject: + m68knommu-add-missing-syscalls.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:37:15 -0700
Message-ID: <200709110537.l8B5bFOc027644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760530AbXIKFh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k(nommu): add missing syscalls
has been added to the -mm tree.  Its filename is
     m68knommu-add-missing-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k(nommu): add missing syscalls
From: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/entry.S             |   10 ++++++++++
 arch/m68knommu/kernel/syscalltable.S |   10 ++++++++++
 include/asm-m68k/unistd.h            |   12 +++++++++++-
 include/asm-m68knommu/unistd.h       |   12 +++++++++++-
 4 files changed, 42 insertions(+), 2 deletions(-)

diff -puN arch/m68k/kernel/entry.S~m68knommu-add-missing-syscalls arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~m68knommu-add-missing-syscalls
+++ a/arch/m68k/kernel/entry.S
@@ -735,4 +735,14 @@ sys_call_table:
 	.long sys_tee
 	.long sys_vmsplice
 	.long sys_move_pages		/* 310 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_kexec_load
+	.long sys_getcpu
+	.long sys_epoll_pwait		/* 315 */
+	.long sys_utimensat
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate		/* 320 */
 
diff -puN arch/m68knommu/kernel/syscalltable.S~m68knommu-add-missing-syscalls arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~m68knommu-add-missing-syscalls
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -329,6 +329,16 @@ ENTRY(sys_call_table)
 	.long sys_tee
 	.long sys_vmsplice
 	.long sys_move_pages		/* 310 */
+	.long sys_sched_setaffinity
+	.long sys_sched_getaffinity
+	.long sys_kexec_load
+	.long sys_getcpu
+	.long sys_epoll_pwait		/* 315 */
+	.long sys_utimensat
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
+	.long sys_fallocate		/* 320 */
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
diff -puN include/asm-m68knommu/unistd.h~m68knommu-add-missing-syscalls include/asm-m68knommu/unistd.h
--- a/include/asm-m68knommu/unistd.h~m68knommu-add-missing-syscalls
+++ a/include/asm-m68knommu/unistd.h
@@ -314,10 +314,20 @@
 #define __NR_tee		308
 #define __NR_vmsplice		309
 #define __NR_move_pages		310
+#define __NR_sched_setaffinity	311
+#define __NR_sched_getaffinity	312
+#define __NR_kexec_load		313
+#define __NR_getcpu		314
+#define __NR_epoll_pwait	315
+#define __NR_utimensat		316
+#define __NR_signalfd		317
+#define __NR_timerfd		318
+#define __NR_eventfd		319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		311
+#define NR_syscalls		321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-m68k/unistd.h~m68knommu-add-missing-syscalls include/asm-m68k/unistd.h
--- a/include/asm-m68k/unistd.h~m68knommu-add-missing-syscalls
+++ a/include/asm-m68k/unistd.h
@@ -313,10 +313,20 @@
 #define __NR_tee		308
 #define __NR_vmsplice		309
 #define __NR_move_pages		310
+#define __NR_sched_setaffinity	311
+#define __NR_sched_getaffinity	312
+#define __NR_kexec_load		313
+#define __NR_getcpu		314
+#define __NR_epoll_pwait	315
+#define __NR_utimensat		316
+#define __NR_signalfd		317
+#define __NR_timerfd		318
+#define __NR_eventfd		319
+#define __NR_fallocate		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		311
+#define NR_syscalls		321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68knommu-add-missing-syscalls.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
atyfb-atyfb-unshare-pseudo_palette.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
bitops-introduce-lock-ops.patch
