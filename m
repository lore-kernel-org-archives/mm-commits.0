Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A539C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjDFCoR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjDFCoG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133F88A5F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ADFF6420B
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4382C433EF;
        Thu,  6 Apr 2023 02:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749044;
        bh=bqN2zc8AVzM/Cn3lgYVEIubZjhb+7hKlh8O3ZljVRNo=;
        h=Date:To:From:Subject:From;
        b=OyEgJBdK3UCO6aE04S3Ln7DRhgUyrtsrj3tCEeR/ujASBnEsPMk74ZfBmQHjaK8TN
         LbU53XZ4oLYSR/GP5whkM8rKrlCV7qbctdsiUBiiKtGasji4MeIs87AMfw4NkWzmug
         7G88AxUDnkgiagdSSRDRr27KPy38HJDYNWWHLvRo=
Date:   Wed, 05 Apr 2023 19:44:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-speedup-dmapool_debug-with-init_on_alloc.patch removed from -mm tree
Message-Id: <20230406024403.E4382C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: speedup DMAPOOL_DEBUG with init_on_alloc
has been removed from the -mm tree.  Its filename was
     dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Battersby <tonyb@cybernetics.com>
Subject: dmapool: speedup DMAPOOL_DEBUG with init_on_alloc
Date: Thu, 26 Jan 2023 13:51:18 -0800

Avoid double-memset of the same allocated memory in dma_pool_alloc() when
both DMAPOOL_DEBUG is enabled and init_on_alloc=1.

Link: https://lkml.kernel.org/r/20230126215125.4069751-6-kbusch@meta.com
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/dmapool.c~dmapool-speedup-dmapool_debug-with-init_on_alloc
+++ a/mm/dmapool.c
@@ -356,7 +356,7 @@ void *dma_pool_alloc(struct dma_pool *po
 			break;
 		}
 	}
-	if (!(mem_flags & __GFP_ZERO))
+	if (!want_init_on_alloc(mem_flags))
 		memset(retval, POOL_POISON_ALLOCATED, pool->size);
 #endif
 	spin_unlock_irqrestore(&pool->lock, flags);
_

Patches currently in -mm which might be from tonyb@cybernetics.com are


