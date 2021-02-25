Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3162C4332E
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BF864F3F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhBYTXA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234739AbhBYTUH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953BA64F4B;
        Thu, 25 Feb 2021 19:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280373;
        bh=BswsYASIwkwxDpTmV8QJLcIlnTprcyZgvOCnLvwuJV8=;
        h=Date:From:To:Subject:From;
        b=ClRo9RCrcGUECIKn+763dBEJ/JeEP7kdeBpEpxE2Pph19AkKvff3MYNhujBv1XAP1
         y/UFkFlEyL2/bKdyxLZ6+mO+iaIrjad97GlUzUXvtpmMI2wMc/uAsljQK9r+zTmn9z
         390vHccjbm4My3OJhOdsWlo1jDqihR1CrkicH55w=
Date:   Thu, 25 Feb 2021 11:12:53 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, kent.overstreet@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch removed
 from -mm tree
Message-ID: <20210225191253.fQroD4GHV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: inline __wait_on_page_locked_async into caller
has been removed from the -mm tree.  Its filename was
     mm-filemap-inline-__wait_on_page_locked_async-into-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: inline __wait_on_page_locked_async into caller

The previous patch removed wait_on_page_locked_async(), so inline
__wait_on_page_locked_async into __lock_page_async().

Link: https://lkml.kernel.org/r/20210122160140.223228-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   53 ++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

--- a/mm/filemap.c~mm-filemap-inline-__wait_on_page_locked_async-into-caller
+++ a/mm/filemap.c
@@ -1343,36 +1343,6 @@ int wait_on_page_bit_killable(struct pag
 }
 EXPORT_SYMBOL(wait_on_page_bit_killable);
 
-static int __wait_on_page_locked_async(struct page *page,
-				       struct wait_page_queue *wait, bool set)
-{
-	struct wait_queue_head *q = page_waitqueue(page);
-	int ret = 0;
-
-	wait->page = page;
-	wait->bit_nr = PG_locked;
-
-	spin_lock_irq(&q->lock);
-	__add_wait_queue_entry_tail(q, &wait->wait);
-	SetPageWaiters(page);
-	if (set)
-		ret = !trylock_page(page);
-	else
-		ret = PageLocked(page);
-	/*
-	 * If we were successful now, we know we're still on the
-	 * waitqueue as we're still under the lock. This means it's
-	 * safe to remove and return success, we know the callback
-	 * isn't going to trigger.
-	 */
-	if (!ret)
-		__remove_wait_queue(q, &wait->wait);
-	else
-		ret = -EIOCBQUEUED;
-	spin_unlock_irq(&q->lock);
-	return ret;
-}
-
 /**
  * put_and_wait_on_page_locked - Drop a reference and wait for it to be unlocked
  * @page: The page to wait for.
@@ -1548,7 +1518,28 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
 
 int __lock_page_async(struct page *page, struct wait_page_queue *wait)
 {
-	return __wait_on_page_locked_async(page, wait, true);
+	struct wait_queue_head *q = page_waitqueue(page);
+	int ret = 0;
+
+	wait->page = page;
+	wait->bit_nr = PG_locked;
+
+	spin_lock_irq(&q->lock);
+	__add_wait_queue_entry_tail(q, &wait->wait);
+	SetPageWaiters(page);
+	ret = !trylock_page(page);
+	/*
+	 * If we were successful now, we know we're still on the
+	 * waitqueue as we're still under the lock. This means it's
+	 * safe to remove and return success, we know the callback
+	 * isn't going to trigger.
+	 */
+	if (!ret)
+		__remove_wait_queue(q, &wait->wait);
+	else
+		ret = -EIOCBQUEUED;
+	spin_unlock_irq(&q->lock);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

