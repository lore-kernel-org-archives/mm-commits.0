From: akpm@linux-foundation.org
Subject: + mm-invoke-oom-killer-from-page-fault.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:40:52 -0700
Message-ID: <200810212140.m9LLeq1B026364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbYJUVl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     mm: invoke oom-killer from page fault
has been added to the -mm tree.  Its filename is
     mm-invoke-oom-killer-from-page-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: invoke oom-killer from page fault
From: Nick Piggin <npiggin@suse.de>

Rather than have the pagefault handler kill a process directly if it gets
a VM_FAULT_OOM, have it call into the OOM killer.

With increasingly sophisticated oom behaviour (cpusets, memory cgroups,
oom killing throttling, oom priority adjustment or selective disabling,
panic on oom, etc), it's silly to unconditionally kill the faulting
process at page fault time.  Create a hook for pagefault oom path to call
into instead.

Only converted x86 and uml so far.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/trap.c |   24 +++-------
 arch/x86/mm/fault.c   |   24 ++--------
 include/linux/mm.h    |    5 ++
 mm/oom_kill.c         |   94 +++++++++++++++++++++++++++-------------
 4 files changed, 84 insertions(+), 63 deletions(-)

diff -puN arch/um/kernel/trap.c~mm-invoke-oom-killer-from-page-fault arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~mm-invoke-oom-killer-from-page-fault
+++ a/arch/um/kernel/trap.c
@@ -64,11 +64,10 @@ good_area:
 
 	do {
 		int fault;
-survive:
+
 		fault = handle_mm_fault(mm, vma, address, is_write);
 		if (unlikely(fault & VM_FAULT_ERROR)) {
 			if (fault & VM_FAULT_OOM) {
-				err = -ENOMEM;
 				goto out_of_memory;
 			} else if (fault & VM_FAULT_SIGBUS) {
 				err = -EACCES;
@@ -104,18 +103,14 @@ out:
 out_nosemaphore:
 	return err;
 
-/*
- * We ran out of memory, or some other thing happened to us that made
- * us unable to handle the page fault gracefully.
- */
 out_of_memory:
-	if (is_global_init(current)) {
-		up_read(&mm->mmap_sem);
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
-	goto out;
+	/*
+	 * We ran out of memory, call the OOM killer, and return the userspace
+	 * (which will retry the fault, or kill us if we got oom-killed).
+	 */
+	up_read(&mm->mmap_sem);
+	pagefault_out_of_memory();
+	return 0;
 }
 
 static void bad_segv(struct faultinfo fi, unsigned long ip)
@@ -214,9 +209,6 @@ unsigned long segv(struct faultinfo fi, 
 		si.si_addr = (void __user *)address;
 		current->thread.arch.faultinfo = fi;
 		force_sig_info(SIGBUS, &si, current);
-	} else if (err == -ENOMEM) {
-		printk(KERN_INFO "VM: killing process %s\n", current->comm);
-		do_exit(SIGKILL);
 	} else {
 		BUG_ON(err != -EFAULT);
 		si.si_signo = SIGSEGV;
diff -puN arch/x86/mm/fault.c~mm-invoke-oom-killer-from-page-fault arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~mm-invoke-oom-killer-from-page-fault
+++ a/arch/x86/mm/fault.c
@@ -680,7 +680,6 @@ void __kprobes do_page_fault(struct pt_r
 	if (unlikely(in_atomic() || !mm))
 		goto bad_area_nosemaphore;
 
-again:
 	/*
 	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -875,25 +874,14 @@ no_context:
 	oops_end(flags, regs, SIGKILL);
 #endif
 
-/*
- * We ran out of memory, or some other thing happened to us that made
- * us unable to handle the page fault gracefully.
- */
 out_of_memory:
+	/*
+	 * We ran out of memory, call the OOM killer, and return the userspace
+	 * (which will retry the fault, or kill us if we got oom-killed).
+	 */
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		/*
-		 * Re-lookup the vma - in theory the vma tree might
-		 * have changed:
-		 */
-		goto again;
-	}
-
-	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & PF_USER)
-		do_group_exit(SIGKILL);
-	goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff -puN include/linux/mm.h~mm-invoke-oom-killer-from-page-fault include/linux/mm.h
--- a/include/linux/mm.h~mm-invoke-oom-killer-from-page-fault
+++ a/include/linux/mm.h
@@ -700,6 +700,11 @@ static inline int page_mapped(struct pag
 
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS)
 
+/*
+ * Can be called by the pagefault handler when it gets a VM_FAULT_OOM.
+ */
+extern void pagefault_out_of_memory(void);
+
 #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
 
 extern void show_free_areas(void);
diff -puN mm/oom_kill.c~mm-invoke-oom-killer-from-page-fault mm/oom_kill.c
--- a/mm/oom_kill.c~mm-invoke-oom-killer-from-page-fault
+++ a/mm/oom_kill.c
@@ -508,6 +508,69 @@ void clear_zonelist_oom(struct zonelist 
 	spin_unlock(&zone_scan_mutex);
 }
 
+/*
+ * Must be called with tasklist_lock held for read.
+ */
+void __out_of_memory(gfp_t gfp_mask, int order)
+{
+	if (sysctl_oom_kill_allocating_task) {
+		oom_kill_process(current, gfp_mask, order, 0, NULL,
+				"Out of memory (oom_kill_allocating_task)");
+
+	} else {
+		unsigned long points;
+		struct task_struct *p;
+
+retry:
+		/*
+		 * Rambo mode: Shoot down a process and hope it solves whatever
+		 * issues we may have.
+		 */
+		p = select_bad_process(&points, NULL);
+
+		if (PTR_ERR(p) == -1UL)
+			return;
+
+		/* Found nothing?!?! Either we hang forever, or we panic. */
+		if (!p) {
+			read_unlock(&tasklist_lock);
+			panic("Out of memory and no killable processes...\n");
+		}
+
+		if (oom_kill_process(p, gfp_mask, order, points, NULL,
+				     "Out of memory"))
+			goto retry;
+	}
+}
+
+/*
+ * pagefault handler calls into here because it is out of memory but
+ * doesn't know exactly how or why.
+ */
+void pagefault_out_of_memory(void)
+{
+	unsigned long freed = 0;
+
+	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
+	if (freed > 0)
+		/* Got some memory back in the last second. */
+		return;
+
+	if (sysctl_panic_on_oom)
+		panic("out of memory from page fault. panic_on_oom is selected.\n");
+
+	read_lock(&tasklist_lock);
+	__out_of_memory(0, 0); /* unknown gfp_mask and order */
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * Give "p" a good chance of killing itself before we
+	 * retry to allocate memory unless "p" is current
+	 */
+	if (!test_thread_flag(TIF_MEMDIE))
+		schedule_timeout_uninterruptible(1);
+}
+
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
@@ -521,8 +584,6 @@ void clear_zonelist_oom(struct zonelist 
  */
 void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 {
-	struct task_struct *p;
-	unsigned long points = 0;
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
 
@@ -543,7 +604,7 @@ void out_of_memory(struct zonelist *zone
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, gfp_mask, order, points, NULL,
+		oom_kill_process(current, gfp_mask, order, 0, NULL,
 				"No available memory (MPOL_BIND)");
 		break;
 
@@ -552,35 +613,10 @@ void out_of_memory(struct zonelist *zone
 			panic("out of memory. panic_on_oom is selected\n");
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
-		if (sysctl_oom_kill_allocating_task) {
-			oom_kill_process(current, gfp_mask, order, points, NULL,
-					"Out of memory (oom_kill_allocating_task)");
-			break;
-		}
-retry:
-		/*
-		 * Rambo mode: Shoot down a process and hope it solves whatever
-		 * issues we may have.
-		 */
-		p = select_bad_process(&points, NULL);
-
-		if (PTR_ERR(p) == -1UL)
-			goto out;
-
-		/* Found nothing?!?! Either we hang forever, or we panic. */
-		if (!p) {
-			read_unlock(&tasklist_lock);
-			panic("Out of memory and no killable processes...\n");
-		}
-
-		if (oom_kill_process(p, gfp_mask, order, points, NULL,
-				     "Out of memory"))
-			goto retry;
