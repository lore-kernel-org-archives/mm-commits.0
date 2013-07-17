From: akpm@linux-foundation.org
Subject: + mm-cleanup-add_to_page_cache_locked.patch added to -mm tree
Date: Wed, 17 Jul 2013 14:12:35 -0700
Message-ID: <51e708c3.1l7uX4roN8HOq10n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3GQVMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-cleanup-add_to_page_cache_locked.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:12:35 -0700


The patch titled
     Subject: mm: cleanup add_to_page_cache_locked()
has been added to the -mm tree.  Its filename is
     mm-cleanup-add_to_page_cache_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-add_to_page_cache_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-add_to_page_cache_locked.patch

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
Subject: mm: cleanup add_to_page_cache_locked()

Make add_to_page_cache_locked() cleaner:

 - unindent most code of the function by inverting one condition;
 - streamline code no-error path;
 - move insert error path outside normal code path;
 - call radix_tree_preload_end() earlier;

No functional changes.

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

 mm/filemap.c |   48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff -puN mm/filemap.c~mm-cleanup-add_to_page_cache_locked mm/filemap.c
--- a/mm/filemap.c~mm-cleanup-add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -467,32 +467,34 @@ int add_to_page_cache_locked(struct page
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
-		goto out;
+		return error;
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
-	if (error == 0) {
-		page_cache_get(page);
-		page->mapping = mapping;
-		page->index = offset;
-
-		spin_lock_irq(&mapping->tree_lock);
-		error = radix_tree_insert(&mapping->page_tree, offset, page);
-		if (likely(!error)) {
-			mapping->nrpages++;
-			__inc_zone_page_state(page, NR_FILE_PAGES);
-			spin_unlock_irq(&mapping->tree_lock);
-			trace_mm_filemap_add_to_page_cache(page);
-		} else {
-			page->mapping = NULL;
-			/* Leave page->index set: truncation relies upon it */
-			spin_unlock_irq(&mapping->tree_lock);
-			mem_cgroup_uncharge_cache_page(page);
-			page_cache_release(page);
-		}
-		radix_tree_preload_end();
-	} else
+	if (error) {
 		mem_cgroup_uncharge_cache_page(page);
-out:
+		return error;
+	}
+
+	page_cache_get(page);
+	page->mapping = mapping;
+	page->index = offset;
+
+	spin_lock_irq(&mapping->tree_lock);
+	error = radix_tree_insert(&mapping->page_tree, offset, page);
+	radix_tree_preload_end();
+	if (unlikely(error))
+		goto err_insert;
+	mapping->nrpages++;
+	__inc_zone_page_state(page, NR_FILE_PAGES);
+	spin_unlock_irq(&mapping->tree_lock);
+	trace_mm_filemap_add_to_page_cache(page);
+	return 0;
+err_insert:
+	page->mapping = NULL;
+	/* Leave page->index set: truncation relies upon it */
+	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
+	page_cache_release(page);
 	return error;
 }
 EXPORT_SYMBOL(add_to_page_cache_locked);
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

