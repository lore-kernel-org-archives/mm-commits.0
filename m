From: akpm@linux-foundation.org
Subject: [merged]
 z3fold-avoid-modifying-headless-page-and-minor-cleanup.patch removed from
 -mm tree
Date: Mon, 06 Jun 2016 12:06:48 -0700
Message-ID: <5755c9c8.PY6ceqzD7uCHVDDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcFFTGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 15:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: avoid modifying HEADLESS page and minor cleanup
has been removed from the -mm tree.  Its filename was
     z3fold-avoid-modifying-headless-page-and-minor-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: avoid modifying HEADLESS page and minor cleanup

Fix erroneous z3fold header access in a HEADLESS page in reclaim function,
and change one remaining direct handle-to-buddy conversion to use the
appropriate helper.

Link: http://lkml.kernel.org/r/5748706F.9020208@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN mm/z3fold.c~z3fold-avoid-modifying-headless-page-and-minor-cleanup mm/z3fold.c
--- a/mm/z3fold.c~z3fold-avoid-modifying-headless-page-and-minor-cleanup
+++ a/mm/z3fold.c
@@ -412,7 +412,7 @@ static void z3fold_free(struct z3fold_po
 		/* HEADLESS page stored */
 		bud = HEADLESS;
 	} else {
-		bud = (handle - zhdr->first_num) & BUDDY_MASK;
+		bud = handle_to_buddy(handle);
 
 		switch (bud) {
 		case FIRST:
@@ -572,15 +572,19 @@ next:
 			pool->pages_nr--;
 			spin_unlock(&pool->lock);
 			return 0;
-		} else if (zhdr->first_chunks != 0 &&
-			   zhdr->last_chunks != 0 && zhdr->middle_chunks != 0) {
-			/* Full, add to buddied list */
-			list_add(&zhdr->buddy, &pool->buddied);
-		} else if (!test_bit(PAGE_HEADLESS, &page->private)) {
-			z3fold_compact_page(zhdr);
-			/* add to unbuddied list */
-			freechunks = num_free_chunks(zhdr);
-			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		}  else if (!test_bit(PAGE_HEADLESS, &page->private)) {
+			if (zhdr->first_chunks != 0 &&
+			    zhdr->last_chunks != 0 &&
+			    zhdr->middle_chunks != 0) {
+				/* Full, add to buddied list */
+				list_add(&zhdr->buddy, &pool->buddied);
+			} else {
+				z3fold_compact_page(zhdr);
+				/* add to unbuddied list */
+				freechunks = num_free_chunks(zhdr);
+				list_add(&zhdr->buddy,
+					 &pool->unbuddied[freechunks]);
+			}
 		}
 
 		/* add to beginning of LRU */
_

Patches currently in -mm which might be from vitalywool@gmail.com are


