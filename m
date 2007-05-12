From: akpm@linux-foundation.org
Subject: - signal-timer-event-signalfd-wire-up-x86-arches.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:01 -0700
Message-ID: <200705120535.l4C5Z1LX002240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755304AbXELFfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, ak@suse.de, mtk-manpages@gmx.net, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: signalfd wire up x86 arches
has been removed from the -mm tree.  Its filename was
     signal-timer-event-signalfd-wire-up-x86-arches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: signalfd wire up x86 arches
From: Davide Libenzi <davidel@xmailserver.org>

This patch wires the signalfd system call to the x86 architectures.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/syscall_table.S |    1 +
 arch/x86_64/ia32/ia32entry.S     |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 include/asm-x86_64/unistd.h      |    2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/syscall_table.S~signal-timer-event-signalfd-wire-up-x86-arches arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~signal-timer-event-signalfd-wire-up-x86-arches
+++ a/arch/i386/kernel/syscall_table.S
@@ -320,3 +320,4 @@ ENTRY(sys_call_table)
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
diff -puN arch/x86_64/ia32/ia32entry.S~signal-timer-event-signalfd-wire-up-x86-arches arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~signal-timer-event-signalfd-wire-up-x86-arches
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -716,4 +716,5 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
+	.quad sys_signalfd
 ia32_syscall_end:		
diff -puN include/asm-i386/unistd.h~signal-timer-event-signalfd-wire-up-x86-arches include/asm-i386/unistd.h
--- a/include/asm-i386/unistd.h~signal-timer-event-signalfd-wire-up-x86-arches
+++ a/include/asm-i386/unistd.h
@@ -326,10 +326,11 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
+#define __NR_signalfd		321
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 322
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-x86_64/unistd.h~signal-timer-event-signalfd-wire-up-x86-arches include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~signal-timer-event-signalfd-wire-up-x86-arches
+++ a/include/asm-x86_64/unistd.h
@@ -624,6 +624,8 @@ __SYSCALL(__NR_utimensat, sys_utimensat)
 #define __IGNORE_getcpu		/* implemented as a vsyscall */
 #define __NR_epoll_pwait	281
 __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
+#define __NR_signalfd		282
+__SYSCALL(__NR_signalfd, sys_signalfd)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
