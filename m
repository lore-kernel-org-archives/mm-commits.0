From: akpm@linux-foundation.org
Subject: [patch 74/78] mm: use mmget_not_zero() helper
Date: Mon, 27 Feb 2017 14:30:13 -0800
Message-ID: <58b4a875.XtS5oo2B+atfH0yp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vegard.nossum@oracle.com, mhocko@suse.com, peterz@infradead.org, rientjes@google.com

From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: use mmget_not_zero() helper

We already have the helper, we can convert the rest of the kernel
mechanically using:

  git grep -l 'atomic_inc_not_zero.*mm_users' | xargs sed -i 's/atomic_inc_not_zero(&\(.*\)->mm_users)/mmget_not_zero\(\1\)/'

This is needed for a later patch that hooks into the helper, but might be
a worthwhile cleanup on its own.

Link: http://lkml.kernel.org/r/20161218123229.22952-3-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_userptr.c |    2 +-
 drivers/iommu/intel-svm.c               |    2 +-
 fs/proc/base.c                          |    4 ++--
 fs/proc/task_mmu.c                      |    4 ++--
 fs/proc/task_nommu.c                    |    2 +-
 kernel/events/uprobes.c                 |    2 +-
 mm/swapfile.c                           |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem_userptr.c~mm-use-mmget_not_zero-helper drivers/gpu/drm/i915/i915_gem_userptr.c
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c~mm-use-mmget_not_zero-helper
+++ a/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -507,7 +507,7 @@ __i915_gem_userptr_get_pages_worker(stru
 			flags |= FOLL_WRITE;
 
 		ret = -EFAULT;
-		if (atomic_inc_not_zero(&mm->mm_users)) {
+		if (mmget_not_zero(mm)) {
 			down_read(&mm->mmap_sem);
 			while (pinned < npages) {
 				ret = get_user_pages_remote
diff -puN drivers/iommu/intel-svm.c~mm-use-mmget_not_zero-helper drivers/iommu/intel-svm.c
--- a/drivers/iommu/intel-svm.c~mm-use-mmget_not_zero-helper
+++ a/drivers/iommu/intel-svm.c
@@ -579,7 +579,7 @@ static irqreturn_t prq_event_thread(int
 		if (!svm->mm)
 			goto bad_req;
 		/* If the mm is already defunct, don't handle faults. */
-		if (!atomic_inc_not_zero(&svm->mm->mm_users))
+		if (!mmget_not_zero(svm->mm))
 			goto bad_req;
 		down_read(&svm->mm->mmap_sem);
 		vma = find_extend_vma(svm->mm, address);
diff -puN fs/proc/base.c~mm-use-mmget_not_zero-helper fs/proc/base.c
--- a/fs/proc/base.c~mm-use-mmget_not_zero-helper
+++ a/fs/proc/base.c
@@ -813,7 +813,7 @@ static ssize_t mem_rw(struct file *file,
 		return -ENOMEM;
 
 	copied = 0;
-	if (!atomic_inc_not_zero(&mm->mm_users))
+	if (!mmget_not_zero(mm))
 		goto free;
 
 	/* Maybe we should limit FOLL_FORCE to actual ptrace users? */
@@ -921,7 +921,7 @@ static ssize_t environ_read(struct file
 		return -ENOMEM;
 
 	ret = 0;
-	if (!atomic_inc_not_zero(&mm->mm_users))
+	if (!mmget_not_zero(mm))
 		goto free;
 
 	down_read(&mm->mmap_sem);
diff -puN fs/proc/task_mmu.c~mm-use-mmget_not_zero-helper fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-use-mmget_not_zero-helper
+++ a/fs/proc/task_mmu.c
@@ -167,7 +167,7 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+	if (!mm || !mmget_not_zero(mm))
 		return NULL;
 
 	down_read(&mm->mmap_sem);
@@ -1352,7 +1352,7 @@ static ssize_t pagemap_read(struct file
 	unsigned long end_vaddr;
 	int ret = 0, copied = 0;
 
-	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+	if (!mm || !mmget_not_zero(mm))
 		goto out;
 
 	ret = -EINVAL;
diff -puN fs/proc/task_nommu.c~mm-use-mmget_not_zero-helper fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~mm-use-mmget_not_zero-helper
+++ a/fs/proc/task_nommu.c
@@ -219,7 +219,7 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
+	if (!mm || !mmget_not_zero(mm))
 		return NULL;
 
 	down_read(&mm->mmap_sem);
diff -puN kernel/events/uprobes.c~mm-use-mmget_not_zero-helper kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-use-mmget_not_zero-helper
+++ a/kernel/events/uprobes.c
@@ -747,7 +747,7 @@ build_map_info(struct address_space *map
 			continue;
 		}
 
-		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
+		if (!mmget_not_zero(vma->vm_mm))
 			continue;
 
 		info = prev;
diff -puN mm/swapfile.c~mm-use-mmget_not_zero-helper mm/swapfile.c
--- a/mm/swapfile.c~mm-use-mmget_not_zero-helper
+++ a/mm/swapfile.c
@@ -1763,7 +1763,7 @@ int try_to_unuse(unsigned int type, bool
 			while (swap_count(*swap_map) && !retval &&
 					(p = p->next) != &start_mm->mmlist) {
 				mm = list_entry(p, struct mm_struct, mmlist);
-				if (!atomic_inc_not_zero(&mm->mm_users))
+				if (!mmget_not_zero(mm))
 					continue;
 				spin_unlock(&mmlist_lock);
 				mmput(prev_mm);
_
