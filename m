From: akpm@linux-foundation.org
Subject: + memcg-avoid-accounting-special-pages.patch added to -mm tree
Date: Fri, 10 Oct 2008 16:49:13 -0700
Message-ID: <200810102349.m9ANnEWc018352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYJJXtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 19:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: avoid accounting special pages
has been added to the -mm tree.  Its filename is
     memcg-avoid-accounting-special-pages.patch

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
Subject: memcg: avoid accounting special pages
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

There are not-on-LRU pages which can be mapped and they are not worth to
be accounted.  (becasue we can't shrink them and need dirty codes to
handle specical case) We'd like to make use of usual objrmap/radix-tree's
protcol and don't want to account out-of-vm's control pages.

When special_mapping_fault() is called, page->mapping is tend to be NULL
and it's charged as Anonymous page.  insert_page() also handles some
special pages from drivers.

This patch is for avoiding to account special pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   24 ++++++++++++++++--------
 mm/memory.c                          |   25 +++++++++++--------------
 mm/rmap.c                            |    4 ++--
 3 files changed, 29 insertions(+), 24 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-avoid-accounting-special-pages Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-avoid-accounting-special-pages
+++ a/Documentation/controllers/memory.txt
@@ -112,14 +112,22 @@ the per cgroup LRU.
 
 2.2.1 Accounting details
 
-All mapped pages (RSS) and unmapped user pages (Page Cache) are accounted.
-RSS pages are accounted at the time of page_add_*_rmap() unless they've already
-been accounted for earlier. A file page will be accounted for as Page Cache;
-it's mapped into the page tables of a process, duplicate accounting is carefully
-avoided. Page Cache pages are accounted at the time of add_to_page_cache().
-The corresponding routines that remove a page from the page tables or removes
-a page from Page Cache is used to decrement the accounting counters of the
-cgroup.
+All mapped anon pages (RSS) and cache pages (Page Cache) are accounted.
+(some pages which never be reclaimable and will not be on global LRU
+ are not accounted. we just accounts pages under usual vm management.)
+
+RSS pages are accounted at page_fault unless they've already been accounted
+for earlier. A file page will be accounted for as Page Cache when it's
+inserted into inode (radix-tree). While it's mapped into the page tables of
+processes, duplicate accounting is carefully avoided.
+
+A RSS page is unaccounted when it's fully unmapped. A PageCache page is
+unaccounted when it's removed from radix-tree.
+
+At page migration, accounting information is kept.
+
+Note: we just account pages-on-lru because our purpose is to control amount
+of used pages. not-on-lru pages are tend to be out-of-control from vm view.
 
 2.3 Shared Page Accounting
 
diff -puN mm/memory.c~memcg-avoid-accounting-special-pages mm/memory.c
--- a/mm/memory.c~memcg-avoid-accounting-special-pages
+++ a/mm/memory.c
@@ -1323,18 +1323,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = mem_cgroup_charge(page, mm, GFP_KERNEL);
-	if (retval)
-		goto out;
-
 	retval = -EINVAL;
 	if (PageAnon(page))
-		goto out_uncharge;
+		goto out;
 	retval = -ENOMEM;
 	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
-		goto out_uncharge;
+		goto out;
 	retval = -EBUSY;
 	if (!pte_none(*pte))
 		goto out_unlock;
@@ -1350,8 +1346,6 @@ static int insert_page(struct vm_area_st
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
-out_uncharge:
-	mem_cgroup_uncharge_page(page);
 out:
 	return retval;
 }
@@ -2463,6 +2457,7 @@ static int __do_fault(struct mm_struct *
 	struct page *page;
 	pte_t entry;
 	int anon = 0;
+	int charged = 0;
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
 	int ret;
@@ -2503,6 +2498,12 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
+			if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
+				ret = VM_FAULT_OOM;
+				page_cache_release(page);
+				goto out;
+			}
+			charged = 1;
 			/*
 			 * Don't let another task, with possibly unlocked vma,
 			 * keep the mlocked page.
@@ -2543,11 +2544,6 @@ static int __do_fault(struct mm_struct *
 
 	}
 
-	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
-
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	/*
@@ -2585,7 +2581,8 @@ static int __do_fault(struct mm_struct *
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, entry);
 	} else {
-		mem_cgroup_uncharge_page(page);
+		if (charged)
+			mem_cgroup_uncharge_page(page);
 		if (anon)
 			page_cache_release(page);
 		else
diff -puN mm/rmap.c~memcg-avoid-accounting-special-pages mm/rmap.c
--- a/mm/rmap.c~memcg-avoid-accounting-special-pages
+++ a/mm/rmap.c
@@ -705,8 +705,8 @@ void page_remove_rmap(struct page *page,
 			page_clear_dirty(page);
 			set_page_dirty(page);
 		}
-
-		mem_cgroup_uncharge_page(page);
+		if (PageAnon(page))
+			mem_cgroup_uncharge_page(page);
 		__dec_zone_page_state(page,
 			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
 		/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

drivers-mfd-ucb1400_corec-further-unbork.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

