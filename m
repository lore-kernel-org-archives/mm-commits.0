Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9C7C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D78C208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633277;
	bh=ht/MejF374a4bh7gnIqmg0K79MnCO8sFjwhnC8sjHrA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H8kaq/Td1HkIGShk//5j3QRT4H7vHpkhuDMd6Mwkj/0I7vJYaD++LXBBwNDMFlv7W
	 GpY6E/tw93zy+OJjbQE/q3xxJ5p/3XuTxO+rmm+jNnZFs/Du/383lRbl4aHtkOCMaB
	 4ezhwPj2BfcNE7DzAzgrjPC04olvrtPXyYvRLFzk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbgJMXyh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59BC021D7B;
        Tue, 13 Oct 2020 23:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633276;
        bh=ht/MejF374a4bh7gnIqmg0K79MnCO8sFjwhnC8sjHrA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i8cn1/PEmDbPGOhlk8rLNSA5hMF2iGdvmm8smRhjI4yX6cSOldykW4ZwhmpJX5wzb
         M0mFMcTsfOfsB13DaxZhndSOe4WXn+Afl4mMbsuQn2AiActq8kFzqqQRQ6HV767of9
         SjgUkzN+DSnol68OKzbibm52NCfwR8lhVA/C99gA=
Date:   Tue, 13 Oct 2020 16:54:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 113/181] mm/dmapool.c: replace open-coded
 list_for_each_entry_safe()
Message-ID: <20201013235435.2m-H0ggeS%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
