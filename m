From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:09 -0700
Message-ID: <57fc19b9.QSjnkoGOe1Y8JcfE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcJJWoK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mst@redhat.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make sure that kthreads will not refault oom reaped memory
has been removed from the -mm tree.  Its filename was
     mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: make sure that kthreads will not refault oom reaped memory

There are only few use_mm() users in the kernel right now.  Most of them
write to the target memory but vhost driver relies on
copy_from_user/get_user from a kernel thread context.  This makes it
impossible to reap the memory of an oom victim which shares the mm with
the vhost kernel thread because it could see a zero page unexpectedly and
theoretically make an incorrect decision visible outside of the killed
task context.

To quote Michael S. Tsirkin:
: Getting an error from __get_user and friends is handled gracefully.
: Getting zero instead of a real value will cause userspace
: memory corruption.

The vhost kernel thread is bound to an open fd of the vhost device which
is not tight to the mm owner life cycle in general.  The device fd can be
inherited or passed over to another process which means that we really
have to be careful about unexpected memory corruption because unlike for
normal oom victims the result will be visible outside of the oom victim
context.

Make sure that no kthread context (users of use_mm) can ever see corrupted
data because of the oom reaper and hook into the page fault path by
checking MMF_UNSTABLE mm flag.  __oom_reap_task_mm will set the flag
before it starts unmapping the address space while the flag is checked
after the page fault has been handled.  If the flag is set then SIGBUS is
triggered so any g-u-p user will get a error code.

Regular tasks do not need this protection because all which share the mm
are killed when the mm is reaped and so the corruption will not outlive
them.

This patch shouldn't have any visible effect at this moment because the
OOM killer doesn't invoke oom reaper for tasks with mm shared with
kthreads yet.

Link: http://lkml.kernel.org/r/1472119394-11342-9-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 mm/memory.c           |   13 +++++++++++++
 mm/oom_kill.c         |    8 ++++++++
 3 files changed, 22 insertions(+)

diff -puN include/linux/sched.h~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory include/linux/sched.h
--- a/include/linux/sched.h~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory
+++ a/include/linux/sched.h
@@ -525,6 +525,7 @@ static inline int get_dumpable(struct mm
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
+#define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff -puN mm/memory.c~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory mm/memory.c
--- a/mm/memory.c~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory
+++ a/mm/memory.c
@@ -3658,6 +3658,19 @@ int handle_mm_fault(struct vm_area_struc
                         mem_cgroup_oom_synchronize(false);
 	}
 
+	/*
+	 * This mm has been already reaped by the oom reaper and so the
+	 * refault cannot be trusted in general. Anonymous refaults would
+	 * lose data and give a zero page instead e.g. This is especially
+	 * problem for use_mm() because regular tasks will just die and
+	 * the corrupted data will not be visible anywhere while kthread
+	 * will outlive the oom victim and potentially propagate the date
+	 * further.
+	 */
+	if (unlikely((current->flags & PF_KTHREAD) && !(ret & VM_FAULT_ERROR)
+				&& test_bit(MMF_UNSTABLE, &vma->vm_mm->flags)))
+		ret = VM_FAULT_SIGBUS;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_mm_fault);
diff -puN mm/oom_kill.c~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory mm/oom_kill.c
--- a/mm/oom_kill.c~mm-make-sure-that-kthreads-will-not-refault-oom-reaped-memory
+++ a/mm/oom_kill.c
@@ -495,6 +495,14 @@ static bool __oom_reap_task_mm(struct ta
 		goto unlock_oom;
 	}
 
+	/*
+	 * Tell all users of get_user/copy_from_user etc... that the content
+	 * is no longer stable. No barriers really needed because unmapping
+	 * should imply barriers already and the reader would hit a page fault
+	 * if it stumbled over a reaped memory.
+	 */
+	set_bit(MMF_UNSTABLE, &mm->flags);
+
 	tlb_gather_mmu(&tlb, mm, 0, -1);
 	for (vma = mm->mmap ; vma; vma = vma->vm_next) {
 		if (is_vm_hugetlb_page(vma))
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch
mm-split-gfp_mask-and-mapping-flags-into-separate-fields.patch

