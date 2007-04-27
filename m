From: akpm@linux-foundation.org
Subject: + signal-timer-event-timerfd-wire-up-x86-arches.patch added to -mm tree
Date: Fri, 27 Apr 2007 14:20:50 -0700
Message-ID: <200704272120.l3RLKoFY008055@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320AbXD0VU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 17:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, ak@suse.de, mtk-manpages@gmx.net


The patch titled
     signal/timer/event: timerfd wire up x86 arches
has been added to the -mm tree.  Its filename is
     signal-timer-event-timerfd-wire-up-x86-arches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 include/asm-x86_64/unistd.h      |    4 +++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/syscall_table.S~signal-timer-event-timerfd-wire-up-x86-arches arch/i386/kernel/syscall_table.S
--- a/arch/i386/kernel/syscall_table.S~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/arch/i386/kernel/syscall_table.S
@@ -321,3 +321,4 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
+	.long sys_timerfd
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
diff -puN arch/x86_64/ia32/ia32entry.S~signal-timer-event-timerfd-wire-up-x86-arches arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -717,4 +717,5 @@ ia32_sys_call_table:
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
 	.quad sys_signalfd
+	.quad sys_timerfd
 ia32_syscall_end:		
diff -puN include/asm-x86_64/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~signal-timer-event-timerfd-wire-up-x86-arches
+++ a/include/asm-x86_64/unistd.h
@@ -623,8 +623,10 @@ __SYSCALL(__NR_move_pages, sys_move_page
 __SYSCALL(__NR_utimensat, sys_utimensat)
 #define __NR_signalfd		281
 __SYSCALL(__NR_signalfd, sys_signalfd)
+#define __NR_timerfd		282
+__SYSCALL(__NR_timerfd, sys_timerfd)
 
-#define __NR_syscall_max __NR_signalfd
+#define __NR_syscall_max __NR_timerfd
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-optimizations-and-cleanups.patch
epoll-optimizations-and-cleanups-tidy.patch
introduce-a-handy-list_first_entry-macro-v2.patch
signal-timer-event-fds-v9-anonymous-inode-source.patch
signal-timer-event-fds-v9-anonymous-inode-source-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix-fix.patch
signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-signalfd-compat-code.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix-fix.patch
signal-timer-event-timerfd-wire-up-x86-arches.patch
signal-timer-event-fds-v9-timerfd-compat-code.patch
signal-timer-event-fds-v9-eventfd-core.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix-fix.patch
signal-timer-event-fds-v9-eventfd-wire-up-i386-arch.patch
signal-timer-event-fds-v9-eventfd-wire-up-x86_64-arch.patch
signal-timer-event-fds-v9-kaio-eventfd-support-example.patch
epoll-use-anonymous-inodes.patch
epoll-cleanups-epoll-no-module.patch
epoll-cleanups-epoll-remove-static-pre-declarations-and-akpm-ize-the-code.patch
