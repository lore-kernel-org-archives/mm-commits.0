From: akpm@linux-foundation.org
Subject: [merged] mm-preallocate-page-before-lock_page-at-filemap-cow.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:29 -0700
Message-ID: <201107260752.p6Q7qWER003139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab1GZHxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, lvml@5t9.de, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: preallocate page before lock_page() at filemap COW
has been removed from the -mm tree.  Its filename was
     mm-preallocate-page-before-lock_page-at-filemap-cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: preallocate page before lock_page() at filemap COW
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Currently we are keeping faulted page locked throughout whole __do_fault
call (except for page_mkwrite code path) after calling file system's fault
code.  If we do early COW, we allocate a new page which has to be charged
for a memcg (mem_cgroup_newpage_charge).

This function, however, might block for unbounded amount of time if memcg
oom killer is disabled or fork-bomb is running because the only way out of
the OOM situation is either an external event or OOM-situation fix.

In the end we are keeping the faulted page locked and blocking other
processes from faulting it in which is not good at all because we are
basically punishing potentially an unrelated process for OOM condition in
a different group (I have seen stuck system because of ld-2.11.1.so being
locked).

We can do test easily.

 % cgcreate -g memory:A
 % cgset -r memory.limit_in_bytes=64M A
 % cgset -r memory.memsw.limit_in_bytes=64M A
 % cd kernel_dir; cgexec -g memory:A make -j

Then, the whole system will live-locked until you kill 'make -j'
by hands (or push reboot...) This is because some important page in a
a shared library are locked.

Considering again, the new page is not necessary to be allocated
with lock_page() held. And usual page allocation may dive into
long memory reclaim loop with holding lock_page() and can cause
very long latency.

There are 3 ways.
  1. do allocation/charge before lock_page()
     Pros. - simple and can handle page allocation in the same manner.
             This will reduce holding time of lock_page() in general.
     Cons. - we do page allocation even if ->fault() returns error.

  2. do charge after unlock_page(). Even if charge fails, it's just OOM.
     Pros. - no impact to non-memcg path.
     Cons. - implemenation requires special cares of LRU and we need to modify
             page_add_new_anon_rmap()...

  3. do unlock->charge->lock again method.
     Pros. - no impact to non-memcg path.
     Cons. - This may kill LOCK_PAGE_RETRY optimization. We need to release
             lock and get it again...

This patch moves "charge" and memory allocation for COW page
before lock_page(). Then, we can avoid scanning LRU with holding
a lock on a page and latency under lock_page() will be reduced.

Then, above livelock disappears.

[akpm@linux-foundation.org: fix code layout]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Lutz Vieweg <lvml@5t9.de>
Original-idea-by: Michal Hocko <mhocko@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   56 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff -puN mm/memory.c~mm-preallocate-page-before-lock_page-at-filemap-cow mm/memory.c
--- a/mm/memory.c~mm-preallocate-page-before-lock_page-at-filemap-cow
+++ a/mm/memory.c
@@ -3093,14 +3093,34 @@ static int __do_fault(struct mm_struct *
 	pte_t *page_table;
 	spinlock_t *ptl;
 	struct page *page;
+	struct page *cow_page;
 	pte_t entry;
 	int anon = 0;
-	int charged = 0;
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
 
+	/*
+	 * If we do COW later, allocate page befor taking lock_page()
+	 * on the file cache page. This will reduce lock holding time.
+	 */
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+
+		if (unlikely(anon_vma_prepare(vma)))
+			return VM_FAULT_OOM;
+
+		cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		if (!cow_page)
+			return VM_FAULT_OOM;
+
+		if (mem_cgroup_newpage_charge(cow_page, mm, GFP_KERNEL)) {
+			page_cache_release(cow_page);
+			return VM_FAULT_OOM;
+		}
+	} else
+		cow_page = NULL;
+
 	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
@@ -3109,12 +3129,13 @@ static int __do_fault(struct mm_struct *
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 			    VM_FAULT_RETRY)))
-		return ret;
+		goto uncharge_out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
 			unlock_page(vmf.page);
-		return VM_FAULT_HWPOISON;
+		ret = VM_FAULT_HWPOISON;
+		goto uncharge_out;
 	}
 
 	/*
@@ -3132,23 +3153,8 @@ static int __do_fault(struct mm_struct *
 	page = vmf.page;
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!(vma->vm_flags & VM_SHARED)) {
+			page = cow_page;
 			anon = 1;
-			if (unlikely(anon_vma_prepare(vma))) {
-				ret = VM_FAULT_OOM;
-				goto out;
-			}
-			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
-						vma, address);
-			if (!page) {
-				ret = VM_FAULT_OOM;
-				goto out;
-			}
-			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
-				ret = VM_FAULT_OOM;
-				page_cache_release(page);
-				goto out;
-			}
-			charged = 1;
 			copy_user_highpage(page, vmf.page, address, vma);
 			__SetPageUptodate(page);
 		} else {
@@ -3217,8 +3223,8 @@ static int __do_fault(struct mm_struct *
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, page_table);
 	} else {
-		if (charged)
-			mem_cgroup_uncharge_page(page);
+		if (cow_page)
+			mem_cgroup_uncharge_page(cow_page);
 		if (anon)
 			page_cache_release(page);
 		else
@@ -3227,7 +3233,6 @@ static int __do_fault(struct mm_struct *
 
 	pte_unmap_unlock(page_table, ptl);
 
-out:
 	if (dirty_page) {
 		struct address_space *mapping = page->mapping;
 
@@ -3257,6 +3262,13 @@ out:
 unwritable_page:
 	page_cache_release(page);
 	return ret;
+uncharge_out:
+	/* fs's fault handler get error */
+	if (cow_page) {
+		mem_cgroup_uncharge_page(cow_page);
+		page_cache_release(cow_page);
+	}
+	return ret;
 }
 
 static int do_linear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-mempolicyc-make-copy_from_user-provably-correct.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-fix-vmscan-count-in-small-memcgs.patch
memcg-fix-behavior-of-mem_cgroup_resize_limit.patch
memcg-add-memoryvmscan_stat.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch

