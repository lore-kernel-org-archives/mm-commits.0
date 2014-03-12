From: akpm@linux-foundation.org
Subject: + memcg-rename-high-level-charging-functions.patch added to -mm
 tree
Date: Wed, 12 Mar 2014 14:04:05 -0700
Message-ID: <5320cbc5.wZamlGXm2NAhIYyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaCLVEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 17:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: + memcg-rename-high-level-charging-functions.patch added to -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 14:04:05 -0700


The patch titled
     Subject: memcg: rename high level charging functions
has been added to the -mm tree.  Its filename is
     memcg-rename-high-level-charging-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-rename-high-level-charging-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-rename-high-level-charging-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: rename high level charging functions

mem_cgroup_newpage_charge is used only for charging anonymous memory so it
is better to rename it to mem_cgroup_charge_anon.

mem_cgroup_cache_charge is used for file backed memory so rename it to
mem_cgroup_charge_file.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memcg_test.txt |    4 ++--
 include/linux/memcontrol.h           |    8 ++++----
 mm/filemap.c                         |    2 +-
 mm/huge_memory.c                     |    8 ++++----
 mm/memcontrol.c                      |    4 ++--
 mm/memory.c                          |    6 +++---
 mm/shmem.c                           |    6 +++---
 7 files changed, 19 insertions(+), 19 deletions(-)

diff -puN Documentation/cgroups/memcg_test.txt~memcg-rename-high-level-charging-functions Documentation/cgroups/memcg_test.txt
--- a/Documentation/cgroups/memcg_test.txt~memcg-rename-high-level-charging-functions
+++ a/Documentation/cgroups/memcg_test.txt
@@ -24,7 +24,7 @@ Please note that implementation details
 
    a page/swp_entry may be charged (usage += PAGE_SIZE) at
 
-	mem_cgroup_newpage_charge()
+	mem_cgroup_charge_anon()
 	  Called at new page fault and Copy-On-Write.
 
 	mem_cgroup_try_charge_swapin()
@@ -32,7 +32,7 @@ Please note that implementation details
 	  Followed by charge-commit-cancel protocol. (With swap accounting)
 	  At commit, a charge recorded in swap_cgroup is removed.
 
-	mem_cgroup_cache_charge()
+	mem_cgroup_charge_file()
 	  Called at add_to_page_cache()
 
 	mem_cgroup_cache_charge_swapin()
diff -puN include/linux/memcontrol.h~memcg-rename-high-level-charging-functions include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-rename-high-level-charging-functions
+++ a/include/linux/memcontrol.h
@@ -65,7 +65,7 @@ struct mem_cgroup_reclaim_cookie {
  * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
  */
 
-extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
+extern int mem_cgroup_charge_anon(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
 extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
@@ -74,7 +74,7 @@ extern void mem_cgroup_commit_charge_swa
 					struct mem_cgroup *memcg);
 extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg);
 
-extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+extern int mem_cgroup_charge_file(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
 
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
@@ -234,13 +234,13 @@ void mem_cgroup_print_bad_page(struct pa
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
-static inline int mem_cgroup_newpage_charge(struct page *page,
+static inline int mem_cgroup_charge_anon(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
 }
 
-static inline int mem_cgroup_cache_charge(struct page *page,
+static inline int mem_cgroup_charge_file(struct page *page,
 					struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
diff -puN mm/filemap.c~memcg-rename-high-level-charging-functions mm/filemap.c
--- a/mm/filemap.c~memcg-rename-high-level-charging-functions
+++ a/mm/filemap.c
@@ -563,7 +563,7 @@ static int __add_to_page_cache_locked(st
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
 
-	error = mem_cgroup_cache_charge(page, current->mm,
+	error = mem_cgroup_charge_file(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		return error;
diff -puN mm/huge_memory.c~memcg-rename-high-level-charging-functions mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-rename-high-level-charging-functions
+++ a/mm/huge_memory.c
@@ -827,7 +827,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(page, mm, GFP_KERNEL))) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -968,7 +968,7 @@ static int do_huge_pmd_wp_page_fallback(
 					       __GFP_OTHER_NODE,
 					       vma, address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
-			     mem_cgroup_newpage_charge(pages[i], mm,
+			     mem_cgroup_charge_anon(pages[i], mm,
 						       GFP_KERNEL))) {
 			if (pages[i])
 				put_page(pages[i]);
@@ -1101,7 +1101,7 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2359,7 +2359,7 @@ static void collapse_huge_page(struct mm
 	if (!new_page)
 		return;
 
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL)))
 		return;
 
 	/*
diff -puN mm/memcontrol.c~memcg-rename-high-level-charging-functions mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-high-level-charging-functions
+++ a/mm/memcontrol.c
@@ -3850,7 +3850,7 @@ out:
 	return ret;
 }
 
-int mem_cgroup_newpage_charge(struct page *page,
+int mem_cgroup_charge_anon(struct page *page,
 			      struct mm_struct *mm, gfp_t gfp_mask)
 {
 	unsigned int nr_pages = 1;
@@ -3986,7 +3986,7 @@ void mem_cgroup_commit_charge_swapin(str
 					  MEM_CGROUP_CHARGE_TYPE_ANON);
 }
 
-int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
+int mem_cgroup_charge_file(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
diff -puN mm/memory.c~memcg-rename-high-level-charging-functions mm/memory.c
--- a/mm/memory.c~memcg-rename-high-level-charging-functions
+++ a/mm/memory.c
@@ -2804,7 +2804,7 @@ gotten:
 	}
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
+	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
 	mmun_start  = address & PAGE_MASK;
@@ -3257,7 +3257,7 @@ static int do_anonymous_page(struct mm_s
 	 */
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
+	if (mem_cgroup_charge_anon(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -3513,7 +3513,7 @@ static int do_cow_fault(struct mm_struct
 	if (!new_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)) {
+	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL)) {
 		page_cache_release(new_page);
 		return VM_FAULT_OOM;
 	}
diff -puN mm/shmem.c~memcg-rename-high-level-charging-functions mm/shmem.c
--- a/mm/shmem.c~memcg-rename-high-level-charging-functions
+++ a/mm/shmem.c
@@ -683,7 +683,7 @@ int shmem_unuse(swp_entry_t swap, struct
 	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
 	 * Charged back to the user (not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	error = mem_cgroup_charge_file(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
 	/* No radix_tree_preload: swap entry keeps a place for page in tree */
@@ -1080,7 +1080,7 @@ repeat:
 				goto failed;
 		}
 
-		error = mem_cgroup_cache_charge(page, current->mm,
+		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
@@ -1134,7 +1134,7 @@ repeat:
 
 		SetPageSwapBacked(page);
 		__set_page_locked(page);
-		error = mem_cgroup_cache_charge(page, current->mm,
+		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
 			goto decused;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch

