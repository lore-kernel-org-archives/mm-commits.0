Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E056C3279D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E202224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709316;
	bh=G3c9WdC0fVmj45Vn1FZX9RGsht2aP5jObBjr85ylrR4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fuZzd+CJzkxjwyTdQlb9L/cBRCS1gN1+ICbxynQwdgWMWPjEhG+wiGm4cOACftBbQ
	 ni9gZ5pjCXemblbqFJ/mac+uBezEPjnxcKXKh/Usl5r0QkNQBxAi9plipXN9gx5ppj
	 P25e+w3Br0e0RbcE05V0aAIzjyfvFg/zfAUdAg7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgJNVBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728959AbgJNVBq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF382225C;
        Wed, 14 Oct 2020 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709305;
        bh=G3c9WdC0fVmj45Vn1FZX9RGsht2aP5jObBjr85ylrR4=;
        h=Date:From:To:Subject:From;
        b=RvozIsVlr7hbk4CpZ+JcHBuGcRaP3VCRjuZE7jAMQJZZQJinDVjBFtCXSdv4OTMua
         UrYZ9rsardA4BRGfVPc+tIYntpdQjmyWMAO2UdVZ+abPqLdYs2pW1J3PI9rY5+w2h4
         kp4+vQnXp5yAqjZ0A12GmIbzHC0Ifr+2c+HvxbUw=
Date:   Wed, 14 Oct 2020 14:01:45 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch removed from
 -mm tree
Message-ID: <20201014210145.tHL_aoQud%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: replace open-coded list_for_each_entry_safe()
has been removed from the -mm tree.  Its filename was
     mm-dmapoolc-replace-open-coded-list_for_each_entry_safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kernelh-split-out-min-max-et-al-helpers.patch
list-add-a-macro-to-test-if-entry-is-pointing-to-the-head.patch

