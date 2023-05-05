Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB540C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjEEWjF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjEEWjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E64EC0
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA666412D
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3230C433EF;
        Fri,  5 May 2023 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326341;
        bh=Z24Fj33b9Pb8sy8Uf37nBFXsKaTMNT7hyqVS0vp2rog=;
        h=Date:To:From:Subject:From;
        b=FNrA0On6zw7qWCa7keCv+a/Js0vceCMlFqGUBj+Iia10W08NFe3tBKNpCxMWp8cZR
         iyVpkmdobzorDyDBuYK3d06DWRtuVWoF+TsO5C1M3JmRtnZp++XvMvDss2HwTnnOZC
         QDNHmHK+qFr1pQHh1LP5+hyh0NiiqWAPJG9aazws=
Date:   Fri, 05 May 2023 15:39:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-cleanup-integer-types.patch removed from -mm tree
Message-Id: <20230505223900.F3230C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: cleanup integer types
has been removed from the -mm tree.  Its filename was
     dmapool-cleanup-integer-types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Battersby <tonyb@cybernetics.com>
Subject: dmapool: cleanup integer types
Date: Thu, 26 Jan 2023 13:51:17 -0800

To represent the size of a single allocation, dmapool currently uses
'unsigned int' in some places and 'size_t' in other places.  Standardize
on 'unsigned int' to reduce overhead, but use 'size_t' when counting all
the blocks in the entire pool.

Link: https://lkml.kernel.org/r/20230126215125.4069751-5-kbusch@meta.com
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/mm/dmapool.c~dmapool-cleanup-integer-types
+++ a/mm/dmapool.c
@@ -43,10 +43,10 @@
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
 	spinlock_t lock;
-	size_t size;
 	struct device *dev;
-	size_t allocation;
-	size_t boundary;
+	unsigned int size;
+	unsigned int allocation;
+	unsigned int boundary;
 	char name[32];
 	struct list_head pools;
 };
@@ -73,7 +73,7 @@ static ssize_t pools_show(struct device
 	mutex_lock(&pools_lock);
 	list_for_each_entry(pool, &dev->dma_pools, pools) {
 		unsigned pages = 0;
-		unsigned blocks = 0;
+		size_t blocks = 0;
 
 		spin_lock_irq(&pool->lock);
 		list_for_each_entry(page, &pool->page_list, page_list) {
@@ -83,9 +83,10 @@ static ssize_t pools_show(struct device
 		spin_unlock_irq(&pool->lock);
 
 		/* per-pool info, no real statistics yet */
-		size += sysfs_emit_at(buf, size, "%-16s %4u %4zu %4zu %2u\n",
+		size += sysfs_emit_at(buf, size, "%-16s %4zu %4zu %4u %2u\n",
 				      pool->name, blocks,
-				      pages * (pool->allocation / pool->size),
+				      (size_t) pages *
+				      (pool->allocation / pool->size),
 				      pool->size, pages);
 	}
 	mutex_unlock(&pools_lock);
@@ -133,7 +134,7 @@ struct dma_pool *dma_pool_create(const c
 	else if (align & (align - 1))
 		return NULL;
 
-	if (size == 0)
+	if (size == 0 || size > INT_MAX)
 		return NULL;
 	else if (size < 4)
 		size = 4;
@@ -146,6 +147,8 @@ struct dma_pool *dma_pool_create(const c
 	else if ((boundary < size) || (boundary & (boundary - 1)))
 		return NULL;
 
+	boundary = min(boundary, allocation);
+
 	retval = kmalloc(sizeof(*retval), GFP_KERNEL);
 	if (!retval)
 		return retval;
@@ -306,7 +309,7 @@ void *dma_pool_alloc(struct dma_pool *po
 {
 	unsigned long flags;
 	struct dma_page *page;
-	size_t offset;
+	unsigned int offset;
 	void *retval;
 
 	might_alloc(mem_flags);
_

Patches currently in -mm which might be from tonyb@cybernetics.com are


