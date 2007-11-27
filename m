From: akpm@linux-foundation.org
Subject: + timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch added to -mm tree
Date: Tue, 27 Nov 2007 01:04:59 -0800
Message-ID: <200711270904.lAR94xxd003875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbXK0JFp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 04:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, linux-arch@vger.kernel.org, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     timerfd: wire the new timerfd API to the x86 family
has been added to the -mm tree.  Its filename is
     timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 include/asm-x86/unistd_32.h        |    6 ++++--
 include/asm-x86/unistd_64.h        |    9 +++++++--
 4 files changed, 17 insertions(+), 6 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family
+++ a/arch/x86/ia32/ia32entry.S
@@ -723,7 +723,9 @@ ia32_sys_call_table:
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
@@ -327,13 +327,15 @@
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
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
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

timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-kvm.patch
use-wake_up_locked-in-eventpoll.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
