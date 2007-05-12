From: akpm@linux-foundation.org
Subject: - signal-timer-event-timerfd-wire-up-x86-arches.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:09 -0700
Message-ID: <200705120535.l4C5Z96v002260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756112AbXELFfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, ak@suse.de, mtk-manpages@gmx.net, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: timerfd wire up x86 arches
has been removed from the -mm tree.  Its filename was
     signal-timer-event-timerfd-wire-up-x86-arches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: timerfd wire up x86 arches
From: Davide Libenzi <davidel@xmailserver.org>

This patch wires the timerfd system call to the x86 architectures.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/syscall_table.S |    1 +
 arch/x86_64/ia32/ia32entry.S     |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 include/asm-x86_64/unistd.h      |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/syscall_table.S~signal-timer-event-timerfd-wire-up-x86-arches arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/arch/i386/kernel/syscall_table.S
@@ -321,3 +321,4 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
+	.long sys_timerfd
diff -puN arch/x86_64/ia32/ia32entry.S~signal-timer-event-timerfd-wire-up-x86-arches arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -717,4 +717,5 @@ ia32_sys_call_table:
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
 	.quad sys_signalfd
+	.quad sys_timerfd
 ia32_syscall_end:		
diff -puN include/asm-i386/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/include/asm-i386/unistd.h
@@ -327,10 +327,11 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
+#define __NR_timerfd		322
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 322
+#define NR_syscalls 323
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-x86_64/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/include/asm-x86_64/unistd.h
@@ -626,6 +626,8 @@ __SYSCALL(__NR_utimensat, sys_utimensat)
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 #define __NR_signalfd		282
 __SYSCALL(__NR_signalfd, sys_signalfd)
+#define __NR_timerfd		282
+__SYSCALL(__NR_timerfd, sys_timerfd)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
