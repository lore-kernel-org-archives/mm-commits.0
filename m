Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9E8C636CC
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjAZWcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjAZWcM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6403E5926A
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047D261978
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586BEC433EF;
        Thu, 26 Jan 2023 22:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772321;
        bh=vEjFdVOOIWO9f8RDAmUPSTUKRaGupjeeqBRSwaTwo9g=;
        h=Date:To:From:Subject:From;
        b=uoi8EUHXaVPWMVo8qQPBlXowGX6HnKhc9R40KQ0d/zhMNUUM8D8fw24DaxzC83Trs
         EGnj+AIDd05vP7rFcUT3O7YTkjLsy6+vdJFq9upwONjvYXxNAvafC2gkAZpYpgMnrO
         fi2Eh9KvBS02E39xF5T1RyKy04JBoqQZoMDfeeUQ=
Date:   Thu, 26 Jan 2023 14:32:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, kbusch@kernel.org,
        hch@lst.de, tonyb@cybernetics.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-speedup-dmapool_debug-with-init_on_alloc.patch added to mm-unstable branch
Message-Id: <20230126223201.586BEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: speedup DMAPOOL_DEBUG with init_on_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

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

dmapool-remove-checks-for-dev-==-null.patch
dmapool-use-sysfs_emit-instead-of-scnprintf.patch
dmapool-cleanup-integer-types.patch
dmapool-speedup-dmapool_debug-with-init_on_alloc.patch

