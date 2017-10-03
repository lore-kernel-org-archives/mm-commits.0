From: akpm@linux-foundation.org
Subject: [patch 17/51] z3fold: fix stale list handling
Date: Tue, 03 Oct 2017 16:15:06 -0700
Message-ID: <59d419fa.sM2QRwh314C0e4OA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, ddstreet@ieee.org, Oleksiy.Avramchenko@sony.com

From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix stale list handling

Fix the situation when clear_bit() is called for page->private before the
page pointer is actually assigned.  While at it, remove work_busy() check
because it is costly and does not give 100% guarantee anyway.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: <Oleksiy.Avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/z3fold.c~z3fold-fix-stale-list-handling mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-stale-list-handling
+++ a/mm/z3fold.c
@@ -250,6 +250,7 @@ static void __release_z3fold_page(struct
 
 	WARN_ON(!list_empty(&zhdr->buddy));
 	set_bit(PAGE_STALE, &page->private);
+	clear_bit(NEEDS_COMPACTING, &page->private);
 	spin_lock(&pool->lock);
 	if (!list_empty(&page->lru))
 		list_del(&page->lru);
@@ -303,7 +304,6 @@ static void free_pages_work(struct work_
 		list_del(&zhdr->buddy);
 		if (WARN_ON(!test_bit(PAGE_STALE, &page->private)))
 			continue;
-		clear_bit(NEEDS_COMPACTING, &page->private);
 		spin_unlock(&pool->stale_lock);
 		cancel_work_sync(&zhdr->work);
 		free_z3fold_page(page);
@@ -624,10 +624,8 @@ lookup:
 	 * stale pages list. cancel_work_sync() can sleep so we must make
 	 * sure it won't be called in case we're in atomic context.
 	 */
-	if (zhdr && (can_sleep || !work_pending(&zhdr->work) ||
-	    !unlikely(work_busy(&zhdr->work)))) {
+	if (zhdr && (can_sleep || !work_pending(&zhdr->work))) {
 		list_del(&zhdr->buddy);
-		clear_bit(NEEDS_COMPACTING, &page->private);
 		spin_unlock(&pool->stale_lock);
 		if (can_sleep)
 			cancel_work_sync(&zhdr->work);
_
