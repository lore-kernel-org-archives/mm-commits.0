From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-optimise-page-cleaning.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:40 -0700
Message-ID: <200810302314.m9UNEec2027555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbYJ3XP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: write_cache_pages optimise page cleaning
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-optimise-page-cleaning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: jim owens <jowens@hp.com>
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

mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
reiser4.patch

