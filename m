Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7223CC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjAZWcc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjAZWcO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:32:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C14D5976B
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:32:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF0FB81F3C
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AA9C433EF;
        Thu, 26 Jan 2023 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674772326;
        bh=ckAvrZaDINBJqcN3Ig+3K0as1T/lLrQYtPv7DK0sVn8=;
        h=Date:To:From:Subject:From;
        b=GOimF/j2KjfU/6Ddw1UO8gbGyDEdTwMolO6AV5qflsmdm4UNCirbjqCdVlnMChlrx
         hyz21LWfZRCeIMUmHNdtyxndyolMd6Ym4ewnQ6l/epXtAPzsDsk3qcbGvjI61uQZoQ
         9l+nwtQ9A0+XKOAMczJMfTHeZ2npS+Vnpd9/wF1w=
Date:   Thu, 26 Jan 2023 14:32:06 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dmapool-consolidate-page-initialization.patch added to mm-unstable branch
Message-Id: <20230126223206.C3AA9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dmapool: consolidate page initialization
has been added to the -mm mm-unstable branch.  Its filename is
     dmapool-consolidate-page-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dmapool-consolidate-page-initialization.patch

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
Subject: dmapool: consolidate page initialization
Date: Thu, 26 Jan 2023 13:51:21 -0800

Various fields of the dma pool are set in different places. Move it all
to one function.

Link: https://lkml.kernel.org/r/20230126215125.4069751-9-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/dmapool.c~dmapool-consolidate-page-initialization
+++ a/mm/dmapool.c
@@ -274,6 +274,9 @@ static void pool_initialise_page(struct
 	unsigned int offset = 0;
 	unsigned int next_boundary = pool->boundary;
 
+	pool_init_page(pool, page);
+	page->in_use = 0;
+	page->offset = 0;
 	do {
 		unsigned int next = offset + pool->size;
 		if (unlikely((next + pool->size) >= next_boundary)) {
@@ -300,11 +303,7 @@ static struct dma_page *pool_alloc_page(
 		return NULL;
 	}
 
-	pool_init_page(pool, page);
 	pool_initialise_page(pool, page);
-	page->in_use = 0;
-	page->offset = 0;
-
 	return page;
 }
 
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

