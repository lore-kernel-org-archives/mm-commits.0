From: akpm@linux-foundation.org
Subject: +
 unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch added to
 -mm tree
Date: Wed, 12 Aug 2015 16:04:26 -0700
Message-ID: <55cbd0fa.DsI4mKZMhcuv3kB7%akpm__4013.22429902411$1439420678$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbHLXE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, jln@google.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, rickyz@chromium.org, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: unshare: unsharing a thread does not require unsharing a vm
has been added to the -mm tree.  Its filename is
     unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: unshare: unsharing a thread does not require unsharing a vm

Checking mm_users > 1 does not mean a process is multithreaded.  For
example, reading /proc/PID/maps temporarily increments mm_users, allowing
other processes to (accidentally) interfere with unshare() calls.

This fixes observed failures of unshare(CLONE_NEWUSER) incorrectly
returning EINVAL if another processes happened to be simultaneously
reading the maps file.


The logic in the initial commit of unshare made creating a new thread
group for a process contingent upon creating a new memory address space
for that process.  That is wrong.  Two separate processes in different
thread groups can share a memory address space and clone allows creation
of such proceses.

This is significant because it was observed that mm_users > 1 does not
mean that a process is multi-threaded, as reading /proc/PID/maps
temporarily increments mm_users, which allows other processes to
(accidentally) interfere with unshare() calls.

Correct the check in check_unshare_flags() to test for
!thread_group_empty() for CLONE_THREAD, CLONE_SIGHAND, and CLONE_VM.  For
sighand->count > 1 for CLONE_SIGHAND and CLONE_VM.  For
!current_is_single_threaded instead of mm_users > 1 for CLONE_VM.

By using the correct checks in unshare this removes the possibility of an
accidental denial of service attack.

Additionally using the correct checks in unshare ensures that only an
explicit unshare(CLONE_VM) can possibly trigger the slow path of
current_is_single_threaded().  As an explict unshare(CLONE_VM) is
pointless it is not expected there are many applications that make that
call.

Fixes: b2e0d98705e60e45 ("userns: Implement unshare of the user namespace")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Ricky Zhou <rickyz@chromium.org>
Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Julien Tinnes <jln@google.com>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN kernel/fork.c~unshare-unsharing-a-thread-does-not-require-unsharing-a-vm kernel/fork.c
--- a/kernel/fork.c~unshare-unsharing-a-thread-does-not-require-unsharing-a-vm
+++ a/kernel/fork.c
@@ -1873,13 +1873,21 @@ static int check_unshare_flags(unsigned
 				CLONE_NEWUSER|CLONE_NEWPID))
 		return -EINVAL;
 	/*
-	 * Not implemented, but pretend it works if there is nothing to
-	 * unshare. Note that unsharing CLONE_THREAD or CLONE_SIGHAND
-	 * needs to unshare vm.
+	 * Not implemented, but pretend it works if there is nothing
+	 * to unshare.  Note that unsharing the address space or the
+	 * signal handlers also need to unshare the signal queues (aka
+	 * CLONE_THREAD).
 	 */
 	if (unshare_flags & (CLONE_THREAD | CLONE_SIGHAND | CLONE_VM)) {
-		/* FIXME: get_task_mm() increments ->mm_users */
-		if (atomic_read(&current->mm->mm_users) > 1)
+		if (!thread_group_empty(current))
+			return -EINVAL;
+	}
+	if (unshare_flags & (CLONE_SIGHAND | CLONE_VM)) {
+		if (atomic_read(&current->sighand->count) > 1)
+			return -EINVAL;
+	}
+	if (unshare_flags & CLONE_VM) {
+		if (!current_is_single_threaded())
 			return -EINVAL;
 	}
 
@@ -1948,16 +1956,16 @@ SYSCALL_DEFINE1(unshare, unsigned long,
 	if (unshare_flags & CLONE_NEWUSER)
 		unshare_flags |= CLONE_THREAD | CLONE_FS;
 	/*
-	 * If unsharing a thread from a thread group, must also unshare vm.
-	 */
-	if (unshare_flags & CLONE_THREAD)
-		unshare_flags |= CLONE_VM;
-	/*
 	 * If unsharing vm, must also unshare signal handlers.
 	 */
 	if (unshare_flags & CLONE_VM)
 		unshare_flags |= CLONE_SIGHAND;
 	/*
+	 * If unsharing a signal handlers, must also unshare the signal queues.
+	 */
+	if (unshare_flags & CLONE_SIGHAND)
+		unshare_flags |= CLONE_THREAD;
+	/*
 	 * If unsharing namespace, must also unshare filesystem information.
 	 */
 	if (unshare_flags & CLONE_NEWNS)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

proc-change-proc_subdir_lock-to-a-rwlock.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec.patch
kexec-split-kexec_load-syscall-from-kexec-core-code.patch
kdump-vmcoreinfo-report-actual-value-of-phys_base.patch
sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch
unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch
usernspidns-force-thread-group-sharing-not-signal-handler-sharing.patch
linux-next.patch

