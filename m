From: akpm@linux-foundation.org
Subject: + timerfd-v3-new-timerfd-api-s390-fix.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:50:37 -0800
Message-ID: <200712052250.lB5Mob0a029122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXLEWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, davidel@xmailserver.org, mtk.manpages@gmail.com


The patch titled
     timerfd-v3-new-timerfd-api-s390-fix
has been added to the -mm tree.  Its filename is
     timerfd-v3-new-timerfd-api-s390-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-s390-fix.patch
git-s390.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
