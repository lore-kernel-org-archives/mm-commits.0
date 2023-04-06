Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8ECC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjDFCoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjDFCoL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57662769D
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D7964259
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194D0C4339C;
        Thu,  6 Apr 2023 02:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749049;
        bh=daS9DtDfpCfbiCs0FFnhsMF2BXIT3o08tDGHGRkUAFA=;
        h=Date:To:From:Subject:From;
        b=Fzr2bUNW+ptDM8K0mnIkSQ6NS1TQXNJ2TWXAM1ZOsKUQDAp0M7hNAxzisOpdq5sK5
         v6jP6pCD53fjKp1usTPBs8t3n9c6LpTvFTplgd6B1sHHKJwTR43SavLdNhZ8ydih9P
         MpJabl+3tNCXXrsRY9/lZT5yyCF7oBI6Gihshh6w=
Date:   Wed, 05 Apr 2023 19:44:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-dont-memset-on-free-twice.patch removed from -mm tree
Message-Id: <20230406024409.194D0C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: don't memset on free twice
has been removed from the -mm tree.  Its filename was
     dmapool-dont-memset-on-free-twice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keith Busch <kbusch@kernel.org>
Subject: dmapool: don't memset on free twice
Date: Thu, 26 Jan 2023 13:51:23 -0800

If debug is enabled, dmapool will poison the range, so no need to clear it
to 0 immediately before writing over it.

Link: https://lkml.kernel.org/r/20230126215125.4069751-11-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/dmapool.c~dmapool-dont-memset-on-free-twice
+++ a/mm/dmapool.c
@@ -160,6 +160,8 @@ static void pool_check_block(struct dma_
 static bool pool_page_err(struct dma_pool *pool, struct dma_page *page,
 			  void *vaddr, dma_addr_t dma)
 {
+	if (want_init_on_free())
+		memset(vaddr, 0, pool->size);
 	return false;
 }
 
@@ -441,8 +443,6 @@ void dma_pool_free(struct dma_pool *pool
 		return;
 	}
 
-	if (want_init_on_free())
-		memset(vaddr, 0, pool->size);
 	if (pool_page_err(pool, page, vaddr, dma)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		return;
_

Patches currently in -mm which might be from kbusch@kernel.org are


