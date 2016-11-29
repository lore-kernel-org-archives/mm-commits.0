From: akpm@linux-foundation.org
Subject: + z3fold-fix-locking-issues.patch added to -mm tree
Date: Tue, 29 Nov 2016 15:56:40 -0800
Message-ID: <583e15b8./cASH5gGz3uktkPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbcK2X40 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2016 18:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, arnd@arndb.de, dan.carpenter@oracle.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: fix locking issues
has been added to the -mm tree.  Its filename is
     z3fold-fix-locking-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-fix-locking-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-fix-locking-issues.patch

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
Subject: z3fold: fix locking issues

Commit 570931c ("z3fold: use per-page spinlock") introduced locking
issues in reclaim function reported in [1] and [2]. This patch
addresses these issues, also fixing the check for empty lru list
(it was only checked once, while it should be checked every time
we want to get the last lru entry).

[1] https://lkml.org/lkml/2016/11/25/628
[2] http://www.spinics.net/lists/linux-mm/msg117227.html

Link: http://lkml.kernel.org/r/20161126202121.baba91a6e67858648e5d1d2f@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/z3fold.c~z3fold-fix-locking-issues mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-locking-issues
+++ a/mm/z3fold.c
@@ -615,12 +615,15 @@ static int z3fold_reclaim_page(struct z3
 	unsigned long first_handle = 0, middle_handle = 0, last_handle = 0;
 
 	spin_lock(&pool->lock);
-	if (!pool->ops || !pool->ops->evict || list_empty(&pool->lru) ||
-			retries == 0) {
+	if (!pool->ops || !pool->ops->evict || retries == 0) {
 		spin_unlock(&pool->lock);
 		return -EINVAL;
 	}
 	for (i = 0; i < retries; i++) {
+		if (list_empty(&pool->lru)) {
+			spin_unlock(&pool->lock);
+			return -EINVAL;
+		}
 		page = list_last_entry(&pool->lru, struct page, lru);
 		list_del(&page->lru);
 
@@ -679,8 +682,7 @@ next:
 			 * All buddies are now free, free the z3fold page and
 			 * return success.
 			 */
-			clear_bit(PAGE_HEADLESS, &page->private);
-			if (!test_bit(PAGE_HEADLESS, &page->private))
+			if (!test_and_clear_bit(PAGE_HEADLESS, &page->private))
 				z3fold_page_unlock(zhdr);
 			free_z3fold_page(zhdr);
 			atomic64_dec(&pool->pages_nr);
@@ -692,6 +694,7 @@ next:
 				/* Full, add to buddied list */
 				spin_lock(&pool->lock);
 				list_add(&zhdr->buddy, &pool->buddied);
+				spin_unlock(&pool->lock);
 			} else {
 				int compacted = z3fold_compact_page(zhdr);
 				/* add to unbuddied list */
@@ -703,15 +706,18 @@ next:
 				else
 					list_add_tail(&zhdr->buddy,
 						&pool->unbuddied[freechunks]);
+				spin_unlock(&pool->lock);
 			}
 		}
 
+		if (!test_bit(PAGE_HEADLESS, &page->private))
+			z3fold_page_unlock(zhdr);
+
+		spin_lock(&pool->lock);
 		/* add to beginning of LRU */
 		list_add(&page->lru, &pool->lru);
 	}
 	spin_unlock(&pool->lock);
-	if (!test_bit(PAGE_HEADLESS, &page->private))
-		z3fold_page_unlock(zhdr);
 	return -EAGAIN;
 }
 
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-make-pages_nr-atomic.patch
z3fold-extend-compaction-function.patch
z3fold-use-per-page-spinlock.patch
z3fold-discourage-use-of-pages-that-werent-compacted.patch
z3fold-fix-header-size-related-issues.patch
z3fold-fix-locking-issues.patch

