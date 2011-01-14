From: akpm@linux-foundation.org
Subject: [merged] mm-find_get_pages_contig-fixlet.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:41 -0800
Message-ID: <201101142247.p0EMlVcG005005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@kernel.dk, fengguang.wu@intel.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: find_get_pages_contig fixlet
has been removed from the -mm tree.  Its filename was
     mm-find_get_pages_contig-fixlet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: find_get_pages_contig fixlet
From: Nick Piggin <npiggin@kernel.dk>

Testing ->mapping and ->index without a ref is not stable as the page
may have been reused at this point.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-find_get_pages_contig-fixlet mm/filemap.c
--- a/mm/filemap.c~mm-find_get_pages_contig-fixlet
+++ a/mm/filemap.c
@@ -837,9 +837,6 @@ repeat:
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
-		if (page->mapping == NULL || page->index != index)
-			break;
-
 		if (!page_cache_get_speculative(page))
 			goto repeat;
 
@@ -849,6 +846,16 @@ repeat:
 			goto repeat;
 		}
 
+		/*
+		 * must check mapping and index after taking the ref.
+		 * otherwise we can get both false positives and false
+		 * negatives, which is just confusing to the caller.
+		 */
+		if (page->mapping == NULL || page->index != index) {
+			page_cache_release(page);
+			break;
+		}
+
 		pages[ret] = page;
 		ret++;
 		index++;
_

Patches currently in -mm which might be from npiggin@kernel.dk are

origin.patch
linux-next.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

