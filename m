Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6F9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A820207BB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597807268;
	bh=UMbTSOY8IWkG+B7HUoLKFVNgmHs/VwyOMS4ve71CohA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=asQJKADygJAQ/MfK2kEfpnIsIM9oxz2P+N2MP9J2BqqMLQlloG6dnpIB1/U7G/w9f
	 5uH7wdtSdoPgm0KaKcTH8W5AKDWG1Q33+kxEoqFl2nljsax5Rg6bwRbi3AIR90UV2A
	 vqiz5yGhI7v9YyREmMN6IXdXGQENl1y+fdhOJ+ck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgHSDVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgHSDVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:21:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB66E207BB;
        Wed, 19 Aug 2020 03:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597807266;
        bh=UMbTSOY8IWkG+B7HUoLKFVNgmHs/VwyOMS4ve71CohA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NGj58+OE7gZzNU/h+x+cA0PFHMQ1XyWKK0/omrcsJZlEzPArj54wiiE1dCef3EgFZ
         f9HlDh5JFaW3VCizumGZuI1uf2AvD9gFnScPJ8bTg+9Yw2XHcETWPU151KkXjO7wjT
         0RZeWmKRARsI6Cer9m6z5RCp8DaOaWeeoLRveEe4=
Date:   Tue, 18 Aug 2020 20:21:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch added to
 -mm tree
Message-ID: <20200819032105.Rmz5W1Tc4%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: replace hard coded function name with __func__
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch
mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch

