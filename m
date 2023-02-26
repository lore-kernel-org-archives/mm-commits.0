Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03F9C7EE23
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBZXtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjBZXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D69868A
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2C6060C89
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46700C433EF;
        Sun, 26 Feb 2023 23:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455327;
        bh=y0kn9ekOO0fOt3LxRurG3VOTHV0+tyEIgCrwE4SbuL0=;
        h=Date:To:From:Subject:From;
        b=tBkXmoDmV1tDn90q+Ggm7dRSkpj9NVgU4Nq/kE8c9FU0/Dr6PVlCHQVpDu9eb4yFj
         WSTiC+c06Ev6oq4W0L4G3j5zizzd5JcrAtI1Dv41CYkf1m8hc6YnKi8Nh81AAB93zp
         UqYk4nW3DkNl1wz2IvDOHlHvEtKcda0aLecN8SjI=
Date:   Sun, 26 Feb 2023 15:48:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-rearrange-page-alloc-failure-handling.patch removed from -mm tree
Message-Id: <20230226234847.46700C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: rearrange page alloc failure handling
has been removed from the -mm tree.  Its filename was
     dmapool-rearrange-page-alloc-failure-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


