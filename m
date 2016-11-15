From: akpm@linux-foundation.org
Subject: + z3fold-discourage-use-of-pages-that-werent-compacted.patch
 added to -mm tree
Date: Tue, 15 Nov 2016 15:42:08 -0800
Message-ID: <582b9d50.dMstdA75eyaJL3+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752932AbcKOXmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:42:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: discourage use of pages that weren't compacted
has been added to the -mm tree.  Its filename is
     z3fold-discourage-use-of-pages-that-werent-compacted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-discourage-use-of-pages-that-werent-compacted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-discourage-use-of-pages-that-werent-compacted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

z3fold-make-pages_nr-atomic.patch
z3fold-extend-compaction-function.patch
z3fold-use-per-page-spinlock.patch
z3fold-dont-fail-kernel-build-if-z3fold_header-is-too-big.patch
z3fold-discourage-use-of-pages-that-werent-compacted.patch

