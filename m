Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52C9C77B75
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjEEWjG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjEEWjE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:39:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739F65BA6
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08BE064159
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C976C433D2;
        Fri,  5 May 2023 22:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326342;
        bh=TnHrjDwoEHNtoLvViWqyf3bUWp7LCuBspGiBb4Kygc0=;
        h=Date:To:From:Subject:From;
        b=x2YgHGf4QsKIBcqSxxJPPGjzN+UUWeZB2kP33HyxMFcJNOFjUP5EVgQn3j84hpodT
         hStXJRrtG+L7Z8TZs9gtCjUcgLQyOLjFYtKcpnANNtQiRl41xHP8jxhFUc0VM9oYHG
         TGRiqTK5Hj7/Qsf2fZPFtdRKjTyiyZoi5tmBdVaU=
Date:   Fri, 05 May 2023 15:39:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-speedup-dmapool_debug-with-init_on_alloc.patch removed from -mm tree
Message-Id: <20230505223902.5C976C433D2@smtp.kernel.org>
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
Fixes: 2d55c16c0c54 ("dmapool: create/destroy cleanup")
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


