Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BF6C77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjEEWjC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjEEWjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9551049C5
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3281B64155
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFA3C433D2;
        Fri,  5 May 2023 22:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326339;
        bh=ZmfATF17hwTT5VcPGId3O09UcnxMnNG/CzYwe7RKoLc=;
        h=Date:To:From:Subject:From;
        b=ZyRtM44IxuyX11fHojMh9O4sZIlvzgtvUUA7z2eifud4y7sojMKFwtPP652we5aRG
         CYDYh5kKgdy4eaYLHOhurbE/2yLSa/MNHJHKzpSMGvXQRc5t5Rk09osNjqsWTQW1d6
         xcQmvWhaI3q5jFhkEGoc+6934/Mzifx+mrRP0kgs=
Date:   Fri, 05 May 2023 15:38:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-use-sysfs_emit-instead-of-scnprintf.patch removed from -mm tree
Message-Id: <20230505223859.8BFA3C433D2@smtp.kernel.org>
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
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

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


