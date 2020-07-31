Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F87CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D6CA2087C
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596227544;
	bh=FMb8sQNcawVqo4kKz6BBxqwuTV+nROxd81dvLGDSvUw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ESHilRoI97Rr8fQv1Nce+5GC1XsD9ZESLYBMH2GH1arbzdN1eDJwbv3qHscMiT77j
	 c059gsRqOdi+FZ33I2AosT301nVXEaBu3LjxW4+FvFVjsrwKupf8KGP3PPn0XXA6WK
	 3IEov1U/dKZ1zCurwmWkOFBZSvd34nM28/sEP4/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgGaUcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgGaUcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:32:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885802087C;
        Fri, 31 Jul 2020 20:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596227541;
        bh=FMb8sQNcawVqo4kKz6BBxqwuTV+nROxd81dvLGDSvUw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gKS2msYA0Wag8Ft2e7AbVBC5WHXQTUNio1DEdWVNy8LFWRJjQ3u+N+brhGCCjIOeG
         iL4jXkf9grUPImNPq+O5bn+l4sxSelQRqpqHF5ViE8o3rQTiG94etWnYrD3e5lgTvf
         77lP/gDGJbkieFl6zXXfHByRO+S6z6s1KumNnUX8=
Date:   Fri, 31 Jul 2020 13:32:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, qiang.zhang@windriver.com,
        willy@infradead.org
Subject:  + mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch added
 to -mm tree
Message-ID: <20200731203221.2eI9uifap%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: add WARN_ON() in dma_pool_destroy
has been added to the -mm tree.  Its filename is
     mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dmapoolc-add-warn_on-in-dma_pool_destroy.patch

