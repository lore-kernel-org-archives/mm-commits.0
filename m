From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-writepage-error-fix.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:33 -0700
Message-ID: <200810302314.m9UNEYQL027518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754462AbYJ3XPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: write_cache_pages writepage error fix
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-writepage-error-fix.patch

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
Subject: mm: write_cache_pages writepage error fix
From: Nick Piggin <npiggin@suse.de>

In write_cache_pages, if ret signals a real error, but we still have some
pages left in the pagevec, done would be set to 1, but the remaining pages
would continue to be processed and ret will be overwritten in the process.
 It could easily be overwritten with success, and thus success will be
returned even if there is an error.  Thus the caller is told all writes
succeeded, wheras in reality some did not.

Fix this by bailing immediately if there is an error, and retaining the
first error code.

This is a data integrity bug.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: jim owens <jowens@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN mm/page-writeback.c~mm-write_cache_pages-writepage-error-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-writepage-error-fix
+++ a/mm/page-writeback.c
@@ -944,12 +944,26 @@ retry:
 			}
 
 			ret = (*writepage)(page, wbc, data);
+			if (unlikely(ret)) {
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+				} else {
+					/*
+					 * done_index is set past this page,
+					 * so media errors will not choke
+					 * background writeout for the entire
+					 * file. This has consequences for
+					 * range_cyclic semantics (ie. it may
+					 * not be suitable for data integrity
+					 * writeout).
+					 */
+					done = 1;
+					break;
+				}
+ 			}
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
-				unlock_page(page);
-				ret = 0;
-			}
-			if (ret || (--nr_to_write <= 0))
+			if (--nr_to_write <= 0)
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
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

