Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5790C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E85EB20866
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597807264;
	bh=LZ6nGzBAohG9esCSgaW7d7nokpsx9FhjdqREUZTngtE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=L3nMc0So/bxL2B2d3d0e7L/ZdVqvjjCmudtZmxXG7amKIPWWB+Pn/pt/ff0oUh+/h
	 T7clUslN7KodwdlfcLmMyfdA5b3/jAVAjKIsl6xmAr3az1G2D7FPCYDUEtlOVoUdhL
	 +wsTAiGASYU0qFJgZuUiJCyI7hDrBMtJZe4GY0o0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgHSDVE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgHSDVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:21:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1160207BB;
        Wed, 19 Aug 2020 03:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597807264;
        bh=LZ6nGzBAohG9esCSgaW7d7nokpsx9FhjdqREUZTngtE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xY8z3M3BAe3N31prQBpgPiUrcgfgNGTIhGBqIp8WQrwYOaP7dUD4lKQJk+aqj91Sf
         AmIN1fX3SljxWjm2eD7a7qkPRZlOLs/HattIDwny7HiYLY1KIssx0984Zt+hJJCb4s
         AcrOIQI7bcYhLVVQ4ozYu5NWezPUfR4NgyblIJbw=
Date:   Tue, 18 Aug 2020 20:21:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  +
 mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch added to -mm
 tree
Message-ID: <20200819032103.yNnuY69GA%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: replace open-coded list_for_each_entry_safe()
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch

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
Subject: mm/dmapool.c: replace open-coded list_for_each_entry_safe()

There is a place in the code where open-coded version of
list_for_each_entry_safe() is used.  Replace that with the standard macro.

Link: http://lkml.kernel.org/r/20200814135055.24898-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/dmapool.c~mm-dmapoolc-replace-open-coded-list_for_each_entry_safe
+++ a/mm/dmapool.c
@@ -266,6 +266,7 @@ static void pool_free_page(struct dma_po
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	struct dma_page *page, *tmp;
 	bool empty = false;
 
 	if (unlikely(!pool))
@@ -281,10 +282,7 @@ void dma_pool_destroy(struct dma_pool *p
 		device_remove_file(pool->dev, &dev_attr_pools);
 	mutex_unlock(&pools_reg_lock);
 
-	while (!list_empty(&pool->page_list)) {
-		struct dma_page *page;
-		page = list_entry(pool->page_list.next,
-				  struct dma_page, page_list);
+	list_for_each_entry_safe(page, tmp, &pool->page_list, page_list) {
 		if (is_page_busy(page)) {
 			if (pool->dev)
 				dev_err(pool->dev,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch
mm-dmapoolc-replace-hard-coded-function-name-with-__func__.patch

