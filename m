From: akpm@linux-foundation.org
Subject: [to-be-updated]
 z3fold-discourage-use-of-pages-that-werent-compacted.patch removed from -mm tree
Date: Wed, 04 Jan 2017 17:27:36 -0800
Message-ID: <586da108.Oj7oHN6Z/GzC0CyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967685AbdAECWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 21:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: discourage use of pages that weren't compacted
has been removed from the -mm tree.  Its filename was
     z3fold-discourage-use-of-pages-that-werent-compacted.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: discourage use of pages that weren't compacted

If a z3fold page couldn't be compacted, we don't want it to be used for
next object allocation in the first place.  It makes more sense to add it
to the end of the relevant unbuddied list.  If that page gets compacted
later, it will be added to the beginning of the list then.

This simple idea gives 5-7% improvement in randrw fio tests and about 10%
improvement in fio sequential read/write.

Link: http://lkml.kernel.org/r/20161115170038.75e127739b66f850e50d7fc1@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN mm/z3fold.c~z3fold-discourage-use-of-pages-that-werent-compacted mm/z3fold.c
--- a/mm/z3fold.c~z3fold-discourage-use-of-pages-that-werent-compacted
+++ a/mm/z3fold.c
@@ -539,11 +539,19 @@ static void z3fold_free(struct z3fold_po
 		free_z3fold_page(zhdr);
 		atomic64_dec(&pool->pages_nr);
 	} else {
-		z3fold_compact_page(zhdr);
+		int compacted = z3fold_compact_page(zhdr);
 		/* Add to the unbuddied list */
 		spin_lock(&pool->lock);
 		freechunks = num_free_chunks(zhdr);
-		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		/*
+		 * If the page has been compacted, we want to use it
+		 * in the first place.
+		 */
+		if (compacted)
+			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
+		else
+			list_add_tail(&zhdr->buddy,
+				      &pool->unbuddied[freechunks]);
 		spin_unlock(&pool->lock);
 		z3fold_page_unlock(zhdr);
 	}
@@ -672,12 +680,16 @@ next:
 				spin_lock(&pool->lock);
 				list_add(&zhdr->buddy, &pool->buddied);
 			} else {
-				z3fold_compact_page(zhdr);
+				int compacted = z3fold_compact_page(zhdr);
 				/* add to unbuddied list */
 				spin_lock(&pool->lock);
 				freechunks = num_free_chunks(zhdr);
-				list_add(&zhdr->buddy,
-					 &pool->unbuddied[freechunks]);
+				if (compacted)
+					list_add(&zhdr->buddy,
+						&pool->unbuddied[freechunks]);
+				else
+					list_add_tail(&zhdr->buddy,
+						&pool->unbuddied[freechunks]);
 			}
 		}
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-fix-header-size-related-issues.patch
z3fold-fix-locking-issues.patch

