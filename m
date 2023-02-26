Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D788C7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBZXtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBZXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:48:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535E686B1
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07FBDB80C9E
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00E5C433EF;
        Sun, 26 Feb 2023 23:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455322;
        bh=bllXkZ9+gMquXZWVhTOhRLV0YVEuedHl74EG6D4xnaA=;
        h=Date:To:From:Subject:From;
        b=Rx9RBp45eevBrDCdLw08uJXuLzvXm2pcsPnIFgOe9rXT2bOZtzcCMw27vmk/66yfU
         7vpPB7yF25LDi/6ugq5y5Ejq9voU9Awq0+cQNAe1Che/wJ4Q1ZjWw6Kz6Gxm5k05vU
         j4ABDhzJ0udHJhrslZQYab+R44uoSBCrJDgwH3eY=
Date:   Sun, 26 Feb 2023 15:48:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-use-sysfs_emit-instead-of-scnprintf.patch removed from -mm tree
Message-Id: <20230226234842.B00E5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: use sysfs_emit() instead of scnprintf()
has been removed from the -mm tree.  Its filename was
     dmapool-use-sysfs_emit-instead-of-scnprintf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Battersby <tonyb@cybernetics.com>
Subject: dmapool: use sysfs_emit() instead of scnprintf()
Date: Thu, 26 Jan 2023 13:51:16 -0800

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Link: https://lkml.kernel.org/r/20230126215125.4069751-4-kbusch@meta.com
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/dmapool.c~dmapool-use-sysfs_emit-instead-of-scnprintf
+++ a/mm/dmapool.c
@@ -64,18 +64,11 @@ static DEFINE_MUTEX(pools_reg_lock);
 
 static ssize_t pools_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	unsigned temp;
-	unsigned size;
-	char *next;
+	int size;
 	struct dma_page *page;
 	struct dma_pool *pool;
 
-	next = buf;
-	size = PAGE_SIZE;
-
-	temp = scnprintf(next, size, "poolinfo - 0.1\n");
-	size -= temp;
-	next += temp;
+	size = sysfs_emit(buf, "poolinfo - 0.1\n");
 
 	mutex_lock(&pools_lock);
 	list_for_each_entry(pool, &dev->dma_pools, pools) {
@@ -90,16 +83,14 @@ static ssize_t pools_show(struct device
 		spin_unlock_irq(&pool->lock);
 
 		/* per-pool info, no real statistics yet */
-		temp = scnprintf(next, size, "%-16s %4u %4zu %4zu %2u\n",
-				 pool->name, blocks,
-				 pages * (pool->allocation / pool->size),
-				 pool->size, pages);
-		size -= temp;
-		next += temp;
+		size += sysfs_emit_at(buf, size, "%-16s %4u %4zu %4zu %2u\n",
+				      pool->name, blocks,
+				      pages * (pool->allocation / pool->size),
+				      pool->size, pages);
 	}
 	mutex_unlock(&pools_lock);
 
-	return PAGE_SIZE - size;
+	return size;
 }
 
 static DEVICE_ATTR_RO(pools);
_

Patches currently in -mm which might be from tonyb@cybernetics.com are


