From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-optimise-page-cleaning.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:39 -0800
Message-ID: <200901072211.n07MBdXN011944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754280AbZAGWLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages optimise page cleaning
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-optimise-page-cleaning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages optimise page cleaning
From: Nick Piggin <npiggin@suse.de>

In write_cache_pages, if we get stuck behind another process that is
cleaning pages, we will be forced to wait for them to finish, then perform
our own writeout (if it was redirtied during the long wait), then wait for
that.

If a page under writeout is still clean, we can skip waiting for it (if
we're part of a data integrity sync, we'll be waiting for all writeout
pages afterwards, so we'll still be waiting for the other guy's write
that's cleaned the page).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-optimise-page-cleaning mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-optimise-page-cleaning
+++ a/mm/page-writeback.c
@@ -945,11 +945,20 @@ continue_unlock:
 				goto continue_unlock;
 			}
 
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (PageWriteback(page)) {
+				if (wbc->sync_mode != WB_SYNC_NONE)
+					wait_on_page_writeback(page);
+				else
+					goto continue_unlock;
+			}
 
-			if (PageWriteback(page) ||
-			    !clear_page_dirty_for_io(page))
+			BUG_ON(PageWriteback(page));
+			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
 			ret = (*writepage)(page, wbc, data);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

