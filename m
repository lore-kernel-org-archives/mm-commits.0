From: akpm@linux-foundation.org
Subject: - timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:44 -0800
Message-ID: <200802052226.m15MQPOq011622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55093 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761057AbYBEW0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk-manpages@gmx.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timerfd: wire the new timerfd API to the x86 family
has been removed from the -mm tree.  Its filename was
     timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: wire the new timerfd API to the x86 family
From: Davide Libenzi <davidel@xmailserver.org>

Wires up the new timerfd API to the x86 family.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    4 +++-
 arch/x86/kernel/syscall_table_32.S |    4 +++-
 include/asm-x86/unistd_32.h        |    4 +++-
 include/asm-x86/unistd_64.h        |    9 +++++++--
 4 files changed, 16 insertions(+), 5 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family
+++ a/arch/x86/ia32/ia32entry.S
@@ -722,7 +722,9 @@ ia32_sys_call_table:
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
 	.quad compat_sys_signalfd
-	.quad compat_sys_timerfd
+	.quad sys_timerfd_create
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad compat_sys_timerfd_settime	/* 325 */
+	.quad compat_sys_timerfd_gettime
 ia32_syscall_end:
diff -puN arch/x86/kernel/syscall_table_32.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -321,6 +321,8 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_timerfd_create
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_timerfd_settime	/* 325 */
+	.long sys_timerfd_gettime
diff -puN include/asm-x86/unistd_32.h~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family include/asm-x86/unistd_32.h
--- a/include/asm-x86/unistd_32.h~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family
+++ a/include/asm-x86/unistd_32.h
@@ -327,9 +327,11 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-#define __NR_timerfd		322
+#define __NR_timerfd_create	322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
 
 #ifdef __KERNEL__
 
diff -puN include/asm-x86/unistd_64.h~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family include/asm-x86/unistd_64.h
--- a/include/asm-x86/unistd_64.h~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family
+++ a/include/asm-x86/unistd_64.h
@@ -629,12 +629,17 @@ __SYSCALL(__NR_utimensat, sys_utimensat)
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd				282
 __SYSCALL(__NR_signalfd, sys_signalfd)
-#define __NR_timerfd				283
-__SYSCALL(__NR_timerfd, sys_timerfd)
+#define __NR_timerfd_create			283
+__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
 #define __NR_eventfd				284
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_timerfd_settime			286
+__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
+#define __NR_timerfd_gettime			287
+__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
+
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
timerfd-fix-remaining-architectures.patch
git-kvm.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
