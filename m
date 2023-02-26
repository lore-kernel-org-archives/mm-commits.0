Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129E5C7EE23
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBZXtD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBZXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:48:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1052286BC
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987B660C89
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7064C433D2;
        Sun, 26 Feb 2023 23:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455325;
        bh=oNi4biUD/FlPBa6HajIho1WBKTlArcmPk3BwvwrntOY=;
        h=Date:To:From:Subject:From;
        b=eX8nwl9YWnSgzZT6wNXjVm/fnqM6FEofAWiu+s68Sud9FGtSsTckDf20Yox0zixa6
         8HHZGs3SqAM4HMGsHT4BJPlb1tqf8ruWjqwzkeLLKPG1FKbsUqAVOtoU3V7dzmmjGe
         wd/+hlQhA4fbOW9NlDM3wtI2sF3Eh6oa7R2TG1ZI=
Date:   Sun, 26 Feb 2023 15:48:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-speedup-dmapool_debug-with-init_on_alloc.patch removed from -mm tree
Message-Id: <20230226234844.E7064C433D2@smtp.kernel.org>
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


