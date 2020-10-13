Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C90C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54833208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633281;
	bh=PrdJfzPITBDB8flflc7gf2/wKz2jZPezQLUwMi6VXMM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CNAWrSuVc/mGYjViMBDh8BXapyLRwPO/I8y00imF/g2ulIDPEKZcWNAumE1fqcuhH
	 OSCH03rnVTnnmIVSChs/fI5vaBOCGSaOf39M7744jD1RmuNMe8w/Qajceu93akvDLS
	 zTXTGnWXuVqPWRZzK0N1fDEfk6PBrKEXQu/ZO3LE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgJMXyl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXyk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8490221D7B;
        Tue, 13 Oct 2020 23:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633279;
        bh=PrdJfzPITBDB8flflc7gf2/wKz2jZPezQLUwMi6VXMM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RPgcM10buno64o5N2Jgu58nFVDIqMDVhArJjv/ujYrVG8iJau+s60D0WC6mC0idcs
         7HHAr9j8K1AIPQTEG1tai7tYjnQlDjPdpr7/dGLfJ3J6sQ+IcbKT+Lknn9deNRey6t
         u03fyZmxTv+FhTT8aXi/d3rFoWguocWVe65kOyQs=
Date:   Tue, 13 Oct 2020 16:54:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 114/181] mm/dmapool.c: replace hard coded function
 name with __func__
Message-ID: <20201013235438.s1igAoKBU%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
