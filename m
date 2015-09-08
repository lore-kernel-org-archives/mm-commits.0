From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-allow-signals-to-interrupt-a-userfault.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:58 -0700
Message-ID: <55ef234a.yNKk/FSZEY9VcmcC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: allow signals to interrupt a userfault
has been removed from the -mm tree.  Its filename was
     userfaultfd-allow-signals-to-interrupt-a-userfault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: allow signals to interrupt a userfault

This is only simple to achieve if the userfault is going to return to
userland (not to the kernel) because we can avoid returning VM_FAULT_RETRY
despite we temporarily released the mmap_sem.  The fault would just be
retried by userland then.  This is safe at least on x86 and powerpc (the
two archs with the syscall implemented so far).

Hint to verify for which archs this is safe: after handle_mm_fault
returns, no access to data structures protected by the mmap_sem must be
done by the fault code in arch/*/mm/fault.c until up_read(&mm->mmap_sem)
is called.

This has two main benefits: signals can run with lower latency in
production (signals aren't blocked by userfaults and userfaults are
immediately repeated after signal processing) and gdb can then trivially
debug the threads blocked in this kind of userfaults coming directly from
userland.

On a side note: while gdb has a need to get signal processed, coredumps
always worked perfectly with userfaults, no matter if the userfault is
triggered by GUP a kernel copy_user or directly from userland.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-allow-signals-to-interrupt-a-userfault fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-allow-signals-to-interrupt-a-userfault
+++ a/fs/userfaultfd.c
@@ -262,7 +262,7 @@ int handle_userfault(struct vm_area_stru
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
 	int ret;
-	bool must_wait;
+	bool must_wait, return_to_userland;
 
 	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
@@ -327,6 +327,9 @@ int handle_userfault(struct vm_area_stru
 	uwq.msg = userfault_msg(address, flags, reason);
 	uwq.ctx = ctx;
 
+	return_to_userland = (flags & (FAULT_FLAG_USER|FAULT_FLAG_KILLABLE)) ==
+		(FAULT_FLAG_USER|FAULT_FLAG_KILLABLE);
+
 	spin_lock(&ctx->fault_pending_wqh.lock);
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
@@ -338,14 +341,16 @@ int handle_userfault(struct vm_area_stru
 	 * following the spin_unlock to happen before the list_add in
 	 * __add_wait_queue.
 	 */
-	set_current_state(TASK_KILLABLE);
+	set_current_state(return_to_userland ? TASK_INTERRUPTIBLE :
+			  TASK_KILLABLE);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
 	must_wait = userfaultfd_must_wait(ctx, address, flags, reason);
 	up_read(&mm->mmap_sem);
 
 	if (likely(must_wait && !ACCESS_ONCE(ctx->released) &&
-		   !fatal_signal_pending(current))) {
+		   (return_to_userland ? !signal_pending(current) :
+		    !fatal_signal_pending(current)))) {
 		wake_up_poll(&ctx->fd_wqh, POLLIN);
 		schedule();
 		ret |= VM_FAULT_MAJOR;
@@ -353,6 +358,30 @@ int handle_userfault(struct vm_area_stru
 
 	__set_current_state(TASK_RUNNING);
 
+	if (return_to_userland) {
+		if (signal_pending(current) &&
+		    !fatal_signal_pending(current)) {
+			/*
+			 * If we got a SIGSTOP or SIGCONT and this is
+			 * a normal userland page fault, just let
+			 * userland return so the signal will be
+			 * handled and gdb debugging works.  The page
+			 * fault code immediately after we return from
+			 * this function is going to release the
+			 * mmap_sem and it's not depending on it
+			 * (unlike gup would if we were not to return
+			 * VM_FAULT_RETRY).
+			 *
+			 * If a fatal signal is pending we still take
+			 * the streamlined VM_FAULT_RETRY failure path
+			 * and there's no need to retake the mmap_sem
+			 * in such case.
+			 */
+			down_read(&mm->mmap_sem);
+			ret = 0;
+		}
+	}
+
 	/*
 	 * Here we race with the list_del; list_add in
 	 * userfaultfd_ctx_read(), however because we don't ever run
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

