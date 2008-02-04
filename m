From: akpm@linux-foundation.org
Subject: - timerfd-v3-new-timerfd-api-s390-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:19:40 -0800
Message-ID: <200802040319.m143JLDu011421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbYBDDTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 22:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, davidel@xmailserver.org, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     timerfd-v3-new-timerfd-api-s390-fix
has been removed from the -mm tree.  Its filename was
     timerfd-v3-new-timerfd-api-s390-fix.patch

This patch was dropped because it was folded into timerfd-v3-new-timerfd-api.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd-v3-new-timerfd-api-s390-fix
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_wrapper.S |    8 --------
 arch/s390/kernel/syscalls.S       |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/s390/kernel/compat_wrapper.S~timerfd-v3-new-timerfd-api-s390-fix arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~timerfd-v3-new-timerfd-api-s390-fix
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -1698,14 +1698,6 @@ compat_sys_signalfd_wrapper:
 	llgfr	%r4,%r4			# compat_size_t
 	jg	compat_sys_signalfd
 
-	.globl	compat_sys_timerfd_wrapper
-compat_sys_timerfd_wrapper:
-	lgfr	%r2,%r2			# int
-	lgfr	%r3,%r3			# int
-	lgfr	%r4,%r4			# int
-	llgtr	%r5,%r5			# struct compat_itimerspec *
-	jg	compat_sys_timerfd
-
 	.globl	sys_eventfd_wrapper
 sys_eventfd_wrapper:
 	llgfr	%r2,%r2			# unsigned int
diff -puN arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api-s390-fix arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api-s390-fix
+++ a/arch/s390/kernel/syscalls.S
@@ -325,5 +325,5 @@ SYSCALL(sys_utimes,sys_utimes,compat_sys
 SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
 SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
-SYSCALL(sys_timerfd,sys_ni_syscall,compat_sys_timerfd_wrapper)
+NI_SYSCALL						/* 317 old sys_timer_fd */
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-s390-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-s390.patch
git-sched.patch
taskstats-scaled-time-cleanup.patch
calibrate_delay-must-be-__cpuinit.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
