From: akpm@linux-foundation.org
Subject: +
 thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch added to
 -mm tree
Date: Wed, 17 Jul 2013 14:12:33 -0700
Message-ID: <51e708c1.3KRkK3DsW2hnquf8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3GQVMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:12:33 -0700


The patch titled
     Subject: thp: account anon transparent huge pages into NR_ANON_PAGES
has been added to the -mm tree.  Its filename is
     thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: account anon transparent huge pages into NR_ANON_PAGES

We use NR_ANON_PAGES as base for reporting AnonPages to user.  There's not
much sense in not accounting transparent huge pages there, but add them on
printing to user.

Let's account transparent huge pages in NR_ANON_PAGES in the first place.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    6 ------
 fs/proc/meminfo.c   |    6 ------
 mm/huge_memory.c    |    1 -
 mm/rmap.c           |   18 +++++++++---------
 4 files changed, 9 insertions(+), 22 deletions(-)

diff -puN drivers/base/node.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages drivers/base/node.c
--- a/drivers/base/node.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/drivers/base/node.c
@@ -125,13 +125,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)
-			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR),
-#else
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
-#endif
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
diff -puN fs/proc/meminfo.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/fs/proc/meminfo.c
@@ -132,13 +132,7 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		K(global_page_state(NR_ANON_PAGES)
-		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		  HPAGE_PMD_NR),
-#else
 		K(global_page_state(NR_ANON_PAGES)),
-#endif
 		K(global_page_state(NR_FILE_MAPPED)),
 		K(global_page_state(NR_SHMEM)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
diff -puN mm/huge_memory.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/mm/huge_memory.c
@@ -1666,7 +1666,6 @@ static void __split_huge_page_refcount(s
 	BUG_ON(atomic_read(&page->_count) <= 0);
 
 	__mod_zone_page_state(zone, NR_ANON_TRANSPARENT_HUGEPAGES, -1);
-	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
 
 	ClearPageCompound(page);
 	compound_unlock(page);
diff -puN mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages mm/rmap.c
--- a/mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/mm/rmap.c
@@ -1055,11 +1055,11 @@ void do_page_add_anon_rmap(struct page *
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
-		if (!PageTransHuge(page))
-			__inc_zone_page_state(page, NR_ANON_PAGES);
-		else
+		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+				hpage_nr_pages(page));
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1088,10 +1088,10 @@ void page_add_new_anon_rmap(struct page
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
-	if (!PageTransHuge(page))
-		__inc_zone_page_state(page, NR_ANON_PAGES);
-	else
+	if (PageTransHuge(page))
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+			hpage_nr_pages(page));
 	__page_set_anon_rmap(page, vma, address, 1);
 	if (!mlocked_vma_newpage(vma, page)) {
 		SetPageActive(page);
@@ -1151,11 +1151,11 @@ void page_remove_rmap(struct page *page)
 		goto out;
 	if (anon) {
 		mem_cgroup_uncharge_page(page);
-		if (!PageTransHuge(page))
-			__dec_zone_page_state(page, NR_ANON_PAGES);
-		else
+		if (PageTransHuge(page))
 			__dec_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+				hpage_nr_pages(page));
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
thp-mm-locking-tail-page-is-a-bug.patch

