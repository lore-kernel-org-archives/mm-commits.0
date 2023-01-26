Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E7DC61DB3
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjAZWcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAZWcM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6FD564BF
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D45CBB81F3F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2F2C433EF;
        Thu, 26 Jan 2023 22:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772319;
        bh=l3yXDxqCRV0V2bKFibZgHCfW+Z5S/X2ITlmAKvI4cgs=;
        h=Date:To:From:Subject:From;
        b=HNSnBtAttgPj0u3NP2Y8n28F+zHUjD7ZKo1J76X/OpX7Zva0RH8pMgHNSY2oFb38l
         /ZfRfLUCDJQKIUlBxZpnQDsRapbNRb660iT80ZYyHtekHNWVh/SqQV7odDgjSrASip
         weo3O8/MD5kKMss76+lcWFjK8Tyo4g9MQDVubc5k=
Date:   Thu, 26 Jan 2023 14:31:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-cleanup-integer-types.patch added to mm-unstable branch
Message-Id: <20230126223159.7E2F2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: cleanup integer types
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-cleanup-integer-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-cleanup-integer-types.patch

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
From: Tony Battersby <tonyb@cybernetics.com>
Subject: dmapool: cleanup integer types
Date: Thu, 26 Jan 2023 13:51:17 -0800

To represent the size of a single allocation, dmapool currently uses
'unsigned int' in some places and 'size_t' in other places.  Standardize
on 'unsigned int' to reduce overhead, but use 'size_t' when counting all
the blocks in the entire pool.

Link: https://lkml.kernel.org/r/20230126215125.4069751-5-kbusch@meta.com
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

dmapool-remove-checks-for-dev-==-null.patch
dmapool-use-sysfs_emit-instead-of-scnprintf.patch
dmapool-cleanup-integer-types.patch
dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

