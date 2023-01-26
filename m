Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9124AC61DA7
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjAZWcN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjAZWcL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E5262240
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26594B81F3E
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78ADC433EF;
        Thu, 26 Jan 2023 22:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772317;
        bh=txzguABxbgX5HXeiQD1GigIZx+DZSA1l4Fbq8fBcKgk=;
        h=Date:To:From:Subject:From;
        b=qBDA89rmVht28cbXZhRThJNse+QN7g7fk/WHBHdZoE5iaTZDdVBX00gxjNbcd12Kd
         Ux6SL7t/MKISZYutpPaYYvXdh6FIDTG6N0R9TtnybszFdRZEgsBKXV1SkdNpr+8DUg
         wfWoD7fZ+c7kTXoIxl0HPokxFOv2PoiZsFN20U2A=
Date:   Thu, 26 Jan 2023 14:31:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-use-sysfs_emit-instead-of-scnprintf.patch added to mm-unstable branch
Message-Id: <20230126223157.B78ADC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: use sysfs_emit() instead of scnprintf()
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-use-sysfs_emit-instead-of-scnprintf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-use-sysfs_emit-instead-of-scnprintf.patch

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

dmapool-remove-checks-for-dev-==-null.patch
dmapool-use-sysfs_emit-instead-of-scnprintf.patch
dmapool-cleanup-integer-types.patch
dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

