From: akpm@linux-foundation.org
Subject: [patch 06/11] mm/z3fold.c: avoid modifying HEADLESS page and
 minor cleanup
Date: Fri, 03 Jun 2016 14:55:47 -0700
Message-ID: <5751fce3.M646ux1qEH3e80Tp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbcFCVzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, ddstreet@ieee.org, sjenning@redhat.com

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
