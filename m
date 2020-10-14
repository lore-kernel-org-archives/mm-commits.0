Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E645DC35266
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9638B2224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709317;
	bh=jzauBfYMPtHbObN3EnrKgIXOJBN0J3yoODDs4TnwuQQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LJPZY72Ky1Nxy6DgDd6YjU76iSGIlTVQyX8iVFCNbk+PdBEFTPu9H6YumX8FdwNoU
	 eJh9y0XMf6QfsRCzZXmEK+4TkyEt/cQqbm/0D1V4HCXEiH1/NjFNKrXU50bhrSvWC+
	 nfM/otkJx1syL8YuvC5/Zn7k8AXGKe86Uflf6h+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgJNVBw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgJNVBt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D0420725;
        Wed, 14 Oct 2020 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709308;
        bh=jzauBfYMPtHbObN3EnrKgIXOJBN0J3yoODDs4TnwuQQ=;
        h=Date:From:To:Subject:From;
        b=CZYXGLLpjKRZuP9YTxJSWfOxVZBXSyyrMZSln+XZ5+x1/KPhpQN2gQKWKLLXLeWEf
         0hxKFQLTU5uyJRttuoljKH2ENwJiaHusdKmBtRAd3coMRlNvx2Va6M+3rKpmdsLpJL
         s4UHDOFPU58J7o1WZcwMRvRNH3dQFpJLQwB2DJ6Y=
Date:   Wed, 14 Oct 2020 14:01:48 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch removed
 from -mm tree
Message-ID: <20201014210148._66Ll2hMt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: replace hard coded function name with __func__
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: mm/dmapool.c: replace hard coded function name with __func__

No need to hard code function name when __func__ can be used.

While here, replace specifiers for special types like dma_addr_t.

Link: http://lkml.kernel.org/r/20200814135055.24898-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/mm/dmapool.c~mm-dmapoolc-replace-hard-coded-function-name-with-__func__
+++ a/mm/dmapool.c
@@ -285,11 +285,10 @@ void dma_pool_destroy(struct dma_pool *p
 	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
 		if (is_page_busy(page)) {
 			if (pool->dev)
-				dev_err(pool->dev,
-					"dma_pool_destroy %s, %p busy\n",
+				dev_err(pool->dev, "%s %s, %p busy\n", __func__,
 					pool->name, page->vaddr);
 			else
-				pr_err("dma_pool_destroy %s, %p busy\n",
+				pr_err("%s %s, %p busy\n", __func__,
 				       pool->name, page->vaddr);
 			/* leak the still-in-use consistent memory */
 			list_del(&page->page_list);
@@ -353,12 +352,11 @@ void *dma_pool_alloc(struct dma_pool *po
 			if (data[i] == POOL_POISON_FREED)
 				continue;
 			if (pool->dev)
-				dev_err(pool->dev,
-					"dma_pool_alloc %s, %p (corrupted)\n",
-					pool->name, retval);
+				dev_err(pool->dev, "%s %s, %p (corrupted)\n",
+					__func__, pool->name, retval);
 			else
-				pr_err("dma_pool_alloc %s, %p (corrupted)\n",
-					pool->name, retval);
+				pr_err("%s %s, %p (corrupted)\n",
+					__func__, pool->name, retval);
 
 			/*
 			 * Dump the first 4 bytes even if they are not
@@ -414,12 +412,11 @@ void dma_pool_free(struct dma_pool *pool
 	if (!page) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
-			dev_err(pool->dev,
-				"dma_pool_free %s, %p/%lx (bad dma)\n",
-				pool->name, vaddr, (unsigned long)dma);
+			dev_err(pool->dev, "%s %s, %p/%pad (bad dma)\n",
+				__func__, pool->name, vaddr, &dma);
 		else
-			pr_err("dma_pool_free %s, %p/%lx (bad dma)\n",
-			       pool->name, vaddr, (unsigned long)dma);
+			pr_err("%s %s, %p/%pad (bad dma)\n",
+			       __func__, pool->name, vaddr, &dma);
 		return;
 	}
 
@@ -430,12 +427,11 @@ void dma_pool_free(struct dma_pool *pool
 	if ((dma - page->dma) != offset) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		if (pool->dev)
-			dev_err(pool->dev,
-				"dma_pool_free %s, %p (bad vaddr)/%pad\n",
-				pool->name, vaddr, &dma);
+			dev_err(pool->dev, "%s %s, %p (bad vaddr)/%pad\n",
+				__func__, pool->name, vaddr, &dma);
 		else
-			pr_err("dma_pool_free %s, %p (bad vaddr)/%pad\n",
-			       pool->name, vaddr, &dma);
+			pr_err("%s %s, %p (bad vaddr)/%pad\n",
+			       __func__, pool->name, vaddr, &dma);
 		return;
 	}
 	{
@@ -447,11 +443,11 @@ void dma_pool_free(struct dma_pool *pool
 			}
 			spin_unlock_irqrestore(&pool->lock, flags);
 			if (pool->dev)
-				dev_err(pool->dev, "dma_pool_free %s, dma %pad already free\n",
-					pool->name, &dma);
+				dev_err(pool->dev, "%s %s, dma %pad already free\n",
+					__func__, pool->name, &dma);
 			else
-				pr_err("dma_pool_free %s, dma %pad already free\n",
-				       pool->name, &dma);
+				pr_err("%s %s, dma %pad already free\n",
+				       __func__, pool->name, &dma);
 			return;
 		}
 	}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-min-max-et-al-helpers.patch
list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

