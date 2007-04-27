From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch removed from -mm tree
Date: Fri, 27 Apr 2007 14:21:01 -0700
Message-ID: <200704272121.l3RLL1Tb008064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321AbXD0VVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 17:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: signalfd wire up x86_64 arch
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-signalfd-wire-up-i386-arch.patch

------------------------------------------------------
Subject: signal/timer/event: signalfd wire up x86_64 arch
From: Davide Libenzi <davidel@xmailserver.org>

This patch wires the signalfd system call to the x86_64 architecture.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    1 +
 include/asm-x86_64/unistd.h  |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/ia32/ia32entry.S~signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -716,4 +716,5 @@ ia32_sys_call_table:
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
 	.quad compat_sys_utimensat	/* 320 */
+	.quad sys_signalfd
 ia32_syscall_end:		
diff -puN include/asm-x86_64/unistd.h~signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~signal-timer-event-fds-v9-signalfd-wire-up-x86_64-arch
+++ a/include/asm-x86_64/unistd.h
@@ -621,8 +621,10 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_utimensat		280
 __SYSCALL(__NR_utimensat, sys_utimensat)
+#define __NR_signalfd		281
+__SYSCALL(__NR_signalfd, sys_signalfd)
 
-#define __NR_syscall_max __NR_utimensat
+#define __NR_syscall_max __NR_signalfd
 
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
