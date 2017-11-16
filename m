From: akpm@linux-foundation.org
Subject: [patch 096/131] mm: speed up cancel_dirty_page() for clean
 pages
Date: Wed, 15 Nov 2017 17:37:11 -0800
Message-ID: <20171116013711.jtmgUTn2H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40180 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933632AbdKPBhN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:37:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -1440,7 +1440,13 @@ void account_page_cleaned(struct page *p
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
