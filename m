Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F46C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjAZWci (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjAZWcX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F137E564BF
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8344B81F2F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58754C433EF;
        Thu, 26 Jan 2023 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772330;
        bh=2Pi8HCdshGuRcFhu4CwVkvco7PaeWDuf4vK7Zw3Z9xQ=;
        h=Date:To:From:Subject:From;
        b=zs3KVjs6WZrIYUj+o+ccEjiFFqKUY61MQUEcEsXYTjqO2s7unvsE9c2qBhi1pInYF
         Aayd3X8Lf/FSQkHUIiAAXp5hLT1VkMHsw0YRnCQmGrTI6HCi8c2CvL8TVoWqb1ow/2
         CLll1gfp7GOghEgD6TcAjoL7jHJik1zdmkoSNR7M=
Date:   Thu, 26 Jan 2023 14:32:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-dont-memset-on-free-twice.patch added to mm-unstable branch
Message-Id: <20230126223210.58754C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: don't memset on free twice
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-dont-memset-on-free-twice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-dont-memset-on-free-twice.patch

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

dmapool-add-alloc-free-performance-test.patch
dmapool-move-debug-code-to-own-functions.patch
dmapool-rearrange-page-alloc-failure-handling.patch
dmapool-consolidate-page-initialization.patch
dmapool-simplify-freeing.patch
dmapool-dont-memset-on-free-twice.patch
dmapool-link-blocks-across-pages.patch
dmapool-create-destroy-cleanup.patch

