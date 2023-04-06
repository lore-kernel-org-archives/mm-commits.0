Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B350FC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbjDFCoW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbjDFCoI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5F87EF0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC9A64220
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04443C433EF;
        Thu,  6 Apr 2023 02:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749047;
        bh=FhreUhThK6ZGZheTJIkXaw2eSTRb55oeOXePnkWnfnI=;
        h=Date:To:From:Subject:From;
        b=urZfIbuSbu+L/prdg2EpiJcRMW82YcT/KPEnzLTrbmWGB9BCuKcoMxcsdj+btAZXP
         Emw+5SIi5TjPblILAt0eynIk0rgw6hPtomlB8sfPR878nNzjnU82iw01R6A72IKbIm
         AATHcKx74FSa7+vHki2607SEx4r6QtFX9M58N14o=
Date:   Wed, 05 Apr 2023 19:44:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-consolidate-page-initialization.patch removed from -mm tree
Message-Id: <20230406024407.04443C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dmapool: consolidate page initialization
has been removed from the -mm tree.  Its filename was
     dmapool-consolidate-page-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


