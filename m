From: akpm@linux-foundation.org
Subject: + mm-find_get_pages_contig-fixlet.patch added to -mm tree
Date: Thu, 11 Nov 2010 22:06:01 -0800
Message-ID: <201011120608.oAC68aud024537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab0KLGJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 01:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@kernel.dk, fengguang.wu@intel.com, minchan.kim@gmail.com


The patch titled
     mm: find_get_pages_contig fixlet
has been added to the -mm tree.  Its filename is
     mm-find_get_pages_contig-fixlet.patch

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
@@ -846,9 +846,6 @@ repeat:
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
-		if (page->mapping == NULL || page->index != index)
-			break;
-
 		if (!page_cache_get_speculative(page))
 			goto repeat;
 
@@ -858,6 +855,16 @@ repeat:
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

atomic-add-atomic_inc_not_zero_hint.patch
radix-tree-fix-rcu-bug.patch
linux-next.patch
cifs-dont-overwrite-dentry-name-in-d_revalidate.patch
jfs-dont-overwrite-dentry-name-in-d_revalidate.patch
mm-find_get_pages_contig-fixlet.patch

