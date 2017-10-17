From: akpm@linux-foundation.org
Subject: + mm-speedup-cancel_dirty_page-for-clean-pages.patch added to -mm tree
Date: Tue, 17 Oct 2017 16:09:18 -0700
Message-ID: <59e68d9e.qXRPq5BPj4m3lRDW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbdJQXJU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: speed up cancel_dirty_page() for clean pages
has been added to the -mm tree.  Its filename is
     mm-speedup-cancel_dirty_page-for-clean-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-speedup-cancel_dirty_page-for-clean-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-speedup-cancel_dirty_page-for-clean-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: speed up cancel_dirty_page() for clean pages

Patch series "Speed up page cache truncation", v1.

When rebasing our enterprise distro to a newer kernel (from 4.4 to 4.12)
we have noticed a regression in bonnie++ benchmark when deleting files. 
Eventually we have tracked this down to a fact that page cache truncation
got slower by about 10%.  There were both gains and losses in the above
interval of kernels but we have been able to identify that commit
83929372f629 "filemap: prepare find and delete operations for huge pages"
caused about 10% regression on its own.

After some investigation it didn't seem easily possible to fix the
regression while maintaining the THP in page cache functionality so we've
decided to optimize the page cache truncation path instead to make up for
the change.  This series is a result of that effort.

Patch 1 is an easy speedup of cancel_dirty_page().  Patches 2-6 refactor
page cache truncation code so that it is easier to batch radix tree
operations.  Patch 7 implements batching of deletes from the radix tree
which more than makes up for the original regression.


This patch (of 7):

cancel_dirty_page() does quite some work even for clean pages (fetching of
mapping, locking of memcg, atomic bit op on page flags) so it accounts for
~2.5% of cost of truncation of a clean page.  That is not much but still
dumb for something we don't need at all.  Check whether a page is actually
dirty and avoid any work if not.

Link: http://lkml.kernel.org/r/20171010151937.26984-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    8 +++++++-
 mm/page-writeback.c |    4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-speedup-cancel_dirty_page-for-clean-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-speedup-cancel_dirty_page-for-clean-pages
+++ a/include/linux/mm.h
@@ -1439,7 +1439,13 @@ void account_page_cleaned(struct page *p
 			  struct bdi_writeback *wb);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
-void cancel_dirty_page(struct page *page);
+void __cancel_dirty_page(struct page *page);
+static inline void cancel_dirty_page(struct page *page)
+{
+	/* Avoid atomic ops, locking, etc. when not actually needed. */
+	if (PageDirty(page))
+		__cancel_dirty_page(page);
+}
 int clear_page_dirty_for_io(struct page *page);
 
 int get_cmdline(struct task_struct *task, char *buffer, int buflen);
diff -puN mm/page-writeback.c~mm-speedup-cancel_dirty_page-for-clean-pages mm/page-writeback.c
--- a/mm/page-writeback.c~mm-speedup-cancel_dirty_page-for-clean-pages
+++ a/mm/page-writeback.c
@@ -2608,7 +2608,7 @@ EXPORT_SYMBOL(set_page_dirty_lock);
  * page without actually doing it through the VM. Can you say "ext3 is
  * horribly ugly"? Thought you could.
  */
-void cancel_dirty_page(struct page *page)
+void __cancel_dirty_page(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -2629,7 +2629,7 @@ void cancel_dirty_page(struct page *page
 		ClearPageDirty(page);
 	}
 }
-EXPORT_SYMBOL(cancel_dirty_page);
+EXPORT_SYMBOL(__cancel_dirty_page);
 
 /*
  * Clear a page's dirty flag, while caring for dirty memory accounting.
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch
mm-speedup-cancel_dirty_page-for-clean-pages.patch
mm-refactor-truncate_complete_page.patch
mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
mm-move-accounting-updates-before-page_cache_tree_delete.patch
mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch
mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
mm-batch-radix-tree-operations-when-truncating-pages.patch

