Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73996C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbjAZWcS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjAZWcM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCE7F759
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0B661981
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004C2C433EF;
        Thu, 26 Jan 2023 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772325;
        bh=+5l0w4woR9SYLuylYFVnIE/Dv84uwkUxqrpOyDTB7PM=;
        h=Date:To:From:Subject:From;
        b=yssUKnYdWrq5xg5jn2Yzdk4EjiTjDu2RAX+WTXKvWyYKotXTHVXUovgb3dzqOl4Mq
         iBwYCZSi18MZ4lIZE8gAfinSLHibf+skiaiPuAAR3409oLJAu9E7BTutU87nlf+FCK
         mJsAnOsXiXQd1ludfqIp7xoSJZlzRxp5AcC0Ew+o=
Date:   Thu, 26 Jan 2023 14:32:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-rearrange-page-alloc-failure-handling.patch added to mm-unstable branch
Message-Id: <20230126223205.004C2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: rearrange page alloc failure handling
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-rearrange-page-alloc-failure-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-rearrange-page-alloc-failure-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: rearrange page alloc failure handling
Date: Thu, 26 Jan 2023 13:51:20 -0800

Handle the error in a condition so the good path can be in the normal
flow.

Link: https://lkml.kernel.org/r/20230126215125.4069751-8-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/dmapool.c~dmapool-rearrange-page-alloc-failure-handling
+++ a/mm/dmapool.c
@@ -292,17 +292,19 @@ static struct dma_page *pool_alloc_page(
 	page = kmalloc(sizeof(*page), mem_flags);
 	if (!page)
 		return NULL;
+
 	page->vaddr = dma_alloc_coherent(pool->dev, pool->allocation,
 					 &page->dma, mem_flags);
-	if (page->vaddr) {
-		pool_init_page(pool, page);
-		pool_initialise_page(pool, page);
-		page->in_use = 0;
-		page->offset = 0;
-	} else {
+	if (!page->vaddr) {
 		kfree(page);
-		page = NULL;
+		return NULL;
 	}
+
+	pool_init_page(pool, page);
+	pool_initialise_page(pool, page);
+	page->in_use = 0;
+	page->offset = 0;
+
 	return page;
 }
 
_

Patches currently in -mm which might be from kbusch@kernel.org are

dmapool-add-alloc-free-performance-test.patch
dmapool-move-debug-code-to-own-functions.patch
dmapool-rearrange-page-alloc-failure-handling.patch
dmapool-consolidate-page-initialization.patch
dmapool-simplify-freeing.patch
dmapool-dont-memset-on-free-twice.patch
dmapool-link-blocks-across-pages.patch
dmapool-create-destroy-cleanup.patch

