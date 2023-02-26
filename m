Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2212DC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBZXtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBZXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563AF903B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D96B80BE8
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EE2C433D2;
        Sun, 26 Feb 2023 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455330;
        bh=QrHWJ2qOXhAA3Pr+ioOFaF4nH3NXpBraO6YytzoUFR0=;
        h=Date:To:From:Subject:From;
        b=EfOqlYuBzyc/CushkoEDf3+S1hxb+yMkcpMKLcv39RvQcsmN2GZZ2anA1X9YOceBX
         1/ssPoYtRXvAagDki6XX+Kx0XqSJSdFzPhY9zZ+CsTBia3DH08/9+E5xjgsT7UYcSj
         nOMLqh918KJ+1AteOR6eca+KIbRY3NgceJiNevfs=
Date:   Sun, 26 Feb 2023 15:48:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-dont-memset-on-free-twice.patch removed from -mm tree
Message-Id: <20230226234850.98EE2C433D2@smtp.kernel.org>
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


