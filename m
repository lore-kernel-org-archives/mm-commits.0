Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDE0C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 21:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4074822B3F
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 21:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596229855;
	bh=Mtm0otEqEFv4WYJA/XxFgOlJdoCFvbvTtW0gJA+dKzo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=oqhnkorOTqxSxktApD+xSLEhtx5YkM6Yo0//AtUP7LaatkvAlUA+kGogJYxOvh9aJ
	 DLDrgSGyVZnaRp2rsC3Mb0q16TubLAZ0h/GVNxSXlkjAnbEWqPmJZM/1WEoCIX5bqh
	 SmzRSgADJLeJU7k/mdTCR9E5q++RCixa4Y36ZmGs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgGaVKz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgGaVKy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 17:10:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582BD2087C;
        Fri, 31 Jul 2020 21:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596229854;
        bh=Mtm0otEqEFv4WYJA/XxFgOlJdoCFvbvTtW0gJA+dKzo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=igrMc9UbtDfSymUb34loE6XlsQ2uBEcfNc9PNWxWi+alS6yzI53vqPasqW38MrqhC
         cHaf72zr0MwkRcvi8qTdeaveDYYxHIbnOeCfT5O4eA7c6AQ6a3mYvk1tZrBFkcPUMc
         dw7/Z6fpy7RYGruQgGdvDihDEy4mmPi+xyvSvALA=
Date:   Fri, 31 Jul 2020 14:10:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, qiang.zhang@windriver.com,
        willy@infradead.org
Subject:  [nacked]
 mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch removed from -mm tree
Message-ID: <20200731211053.4pSqAGYMJ%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: add WARN_ON() in dma_pool_destroy
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Zhang Qiang <qiang.zhang@windriver.com>
Subject: mm/dmapool.c: add WARN_ON() in dma_pool_destroy

The pool is being destroyed so all pages which are in the pool should be
free.  If some page is still in use by somebody, we should not just output
error logs, also should also add a WARN message so the stack backtrace may
be used to identify the caller.

Link: http://lkml.kernel.org/r/20200731023939.19206-1-qiang.zhang@windriver.com
Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/dmapool.c~mm-dmapoolc-add-warn_on-in-dma_pool_destroy
+++ a/mm/dmapool.c
@@ -285,7 +285,7 @@ void dma_pool_destroy(struct dma_pool *p
 		struct dma_page *page;
 		page = list_entry(pool->page_list.next,
 				  struct dma_page, page_list);
-		if (is_page_busy(page)) {
+		if (WARN_ON(is_page_busy(page))) {
 			if (pool->dev)
 				dev_err(pool->dev,
 					"dma_pool_destroy %s, %p busy\n",
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are


