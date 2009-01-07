From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-writepage-error-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:33 -0800
Message-ID: <200901072211.n07MBX2s011887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279AbZAGWLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages writepage error fix
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-writepage-error-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

