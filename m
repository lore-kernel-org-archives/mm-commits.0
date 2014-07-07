From: akpm@linux-foundation.org
Subject: [merged]
 shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:38 -0700
Message-ID: <53bae2da.QR5HDfYK6YC4Ge29%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:63412 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaGGSLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:39 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so657287veb.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, prabhakar.csengg@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix init_page_accessed use to stop !PageLRU bug
has been removed from the -mm tree.  Its filename was
     shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix init_page_accessed use to stop !PageLRU bug

Under shmem swapping load, I sometimes hit the VM_BUG_ON_PAGE(!PageLRU) in
isolate_lru_pages() at mm/vmscan.c:1281!

Commit 2457aec63745 ("mm: non-atomically mark page accessed during page
cache allocation where possible") looks like interrupted work-in-progress.

mm/filemap.c's call to init_page_accessed() is fine, but not mm/shmem.c's
- shmem_write_begin() is clearly wrong to use it after shmem_getpage(),
when the page is always visible in radix_tree, and often already on LRU.

Revert change to shmem_write_begin(), and use init_page_accessed() or
mark_page_accessed() appropriately for SGP_WRITE in shmem_getpage_gfp().

SGP_WRITE also covers shmem_symlink(), which did not mark_page_accessed()
before; but since many other filesystems use [__]page_symlink(), which did
and does mark the page accessed, consider this as rectifying an oversight.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~shmem-fix-init_page_accessed-use-to-stop-pagelru-bug mm/shmem.c
--- a/mm/shmem.c~shmem-fix-init_page_accessed-use-to-stop-pagelru-bug
+++ a/mm/shmem.c
@@ -1029,6 +1029,9 @@ repeat:
 		goto failed;
 	}
 
+	if (page && sgp == SGP_WRITE)
+		mark_page_accessed(page);
+
 	/* fallocated page? */
 	if (page && !PageUptodate(page)) {
 		if (sgp != SGP_READ)
@@ -1110,6 +1113,9 @@ repeat:
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
 
+		if (sgp == SGP_WRITE)
+			mark_page_accessed(page);
+
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		swap_free(swap);
@@ -1136,6 +1142,9 @@ repeat:
 
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
+		if (sgp == SGP_WRITE)
+			init_page_accessed(page);
+
 		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
@@ -1412,13 +1421,9 @@ shmem_write_begin(struct file *file, str
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
-	int ret;
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	ret = shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
-	if (ret == 0 && *pagep)
-		init_page_accessed(*pagep);
-	return ret;
+	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
 }
 
 static int
_

Patches currently in -mm which might be from hughd@google.com are

revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
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
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

