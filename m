From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
 removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:21 -0700
Message-ID: <53d170d9.THQDv/JBQbYczhMN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34596 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934680AbaGXUrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:23 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so580370vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, hannes@cmpxchg.org, koct9i@gmail.com, lczerner@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix faulting into a hole, not taking i_mutex
has been removed from the -mm tree.  Its filename was
     shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix faulting into a hole, not taking i_mutex

f00cdc6df7d7 ("shmem: fix faulting into a hole while it's punched") was
buggy: Sasha sent a lockdep report to remind us that grabbing i_mutex in
the fault path is a no-no (write syscall may already hold i_mutex while
faulting user buffer).

We tried a completely different approach (see following patch) but that
proved inadequate: good enough for a rational workload, but not good
enough against trinity - which forks off so many mappings of the object
that contention on i_mmap_mutex while hole-puncher holds i_mutex builds
into serious starvation when concurrent faults force the puncher to fall
back to single-page unmap_mapping_range() searches of the i_mmap tree.

So return to the original umbrella approach, but keep away from i_mutex
this time.  We really don't want to bloat every shmem inode with a new
mutex or completion, just to protect this unlikely case from trinity.  So
extend the original with wait_queue_head on stack at the hole-punch end,
and wait_queue item on the stack at the fault end.

This involves further use of i_lock to guard against the races: lockdep
has been happy so far, and I see fs/inode.c:unlock_new_inode() holds
i_lock around wake_up_bit(), which is comparable to what we do here. 
i_lock is more convenient, but we could switch to shmem's info->lock.

This issue has been tagged with CVE-2014-4171, which will require
f00cdc6df7d7 and this and the following patch to be backported: we suggest
to 3.1+, though in fact the trinity forkbomb effect might go back as far
as 2.6.16, when madvise(,,MADV_REMOVE) came in - or might not, since much
has changed, with i_mmap_mutex a spinlock before 3.0.  Anyone running
trinity on 3.0 and earlier?  I don't think we need care.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: <stable@vger.kernel.org>	[3.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   78 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff -puN mm/shmem.c~shmem-fix-faulting-into-a-hole-not-taking-i_mutex mm/shmem.c
--- a/mm/shmem.c~shmem-fix-faulting-into-a-hole-not-taking-i_mutex
+++ a/mm/shmem.c
@@ -85,7 +85,7 @@ static struct vfsmount *shm_mnt;
  * a time): we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
-	int	mode;		/* FALLOC_FL mode currently operating */
+	wait_queue_head_t *waitq; /* faults into hole wait for punch to end */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -760,7 +760,7 @@ static int shmem_writepage(struct page *
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
-			    !shmem_falloc->mode &&
+			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1248,38 +1248,58 @@ static int shmem_fault(struct vm_area_st
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: which in turn
 	 * locks writers out with its hold on i_mutex.  So refrain from
-	 * faulting pages into the hole while it's being punched, and
-	 * wait on i_mutex to be released if vmf->flags permits.
+	 * faulting pages into the hole while it's being punched.  Although
+	 * shmem_undo_range() does remove the additions, it may be unable to
+	 * keep up, as each new page needs its own unmap_mapping_range() call,
+	 * and the i_mmap tree grows ever slower to scan if new vmas are added.
+	 *
+	 * It does not matter if we sometimes reach this check just before the
+	 * hole-punch begins, so that one fault then races with the punch:
+	 * we just need to make racing faults a rare case.
+	 *
+	 * The implementation below would be much simpler if we just used a
+	 * standard mutex or completion: but we cannot take i_mutex in fault,
+	 * and bloating every shmem inode for this unlikely case would be sad.
 	 */
 	if (unlikely(inode->i_private)) {
 		struct shmem_falloc *shmem_falloc;
 
 		spin_lock(&inode->i_lock);
 		shmem_falloc = inode->i_private;
-		if (!shmem_falloc ||
-		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
-		    vmf->pgoff < shmem_falloc->start ||
-		    vmf->pgoff >= shmem_falloc->next)
-			shmem_falloc = NULL;
-		spin_unlock(&inode->i_lock);
-		/*
-		 * i_lock has protected us from taking shmem_falloc seriously
-		 * once return from shmem_fallocate() went back up that stack.
-		 * i_lock does not serialize with i_mutex at all, but it does
-		 * not matter if sometimes we wait unnecessarily, or sometimes
-		 * miss out on waiting: we just need to make those cases rare.
-		 */
-		if (shmem_falloc) {
+		if (shmem_falloc &&
+		    shmem_falloc->waitq &&
+		    vmf->pgoff >= shmem_falloc->start &&
+		    vmf->pgoff < shmem_falloc->next) {
+			wait_queue_head_t *shmem_falloc_waitq;
+			DEFINE_WAIT(shmem_fault_wait);
+
+			ret = VM_FAULT_NOPAGE;
 			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
 			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
+				/* It's polite to up mmap_sem if we can */
 				up_read(&vma->vm_mm->mmap_sem);
-				mutex_lock(&inode->i_mutex);
-				mutex_unlock(&inode->i_mutex);
-				return VM_FAULT_RETRY;
+				ret = VM_FAULT_RETRY;
 			}
-			/* cond_resched? Leave that to GUP or return to user */
-			return VM_FAULT_NOPAGE;
+
+			shmem_falloc_waitq = shmem_falloc->waitq;
+			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock(&inode->i_lock);
+			schedule();
+
+			/*
+			 * shmem_falloc_waitq points into the shmem_fallocate()
+			 * stack of the hole-punching task: shmem_falloc_waitq
+			 * is usually invalid by the time we reach here, but
+			 * finish_wait() does not dereference it in that case;
+			 * though i_lock needed lest racing with wake_up_all().
+			 */
+			spin_lock(&inode->i_lock);
+			finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
+			spin_unlock(&inode->i_lock);
+			return ret;
 		}
+		spin_unlock(&inode->i_lock);
 	}
 
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
@@ -1774,13 +1794,13 @@ static long shmem_fallocate(struct file
 
 	mutex_lock(&inode->i_mutex);
 
-	shmem_falloc.mode = mode & ~FALLOC_FL_KEEP_SIZE;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
+		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
 
+		shmem_falloc.waitq = &shmem_falloc_waitq;
 		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
@@ -1792,8 +1812,13 @@ static long shmem_fallocate(struct file
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
+
+		spin_lock(&inode->i_lock);
+		inode->i_private = NULL;
+		wake_up_all(&shmem_falloc_waitq);
+		spin_unlock(&inode->i_lock);
 		error = 0;
-		goto undone;
+		goto out;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
@@ -1809,6 +1834,7 @@ static long shmem_fallocate(struct file
 		goto out;
 	}
 
+	shmem_falloc.waitq = NULL;
 	shmem_falloc.start = start;
 	shmem_falloc.next  = start;
 	shmem_falloc.nr_falloced = 0;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

