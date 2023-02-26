Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFB0C7EE2F
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBZXtC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBZXtA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A9B869C
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:48:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A9E60C2B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFA9C433EF;
        Sun, 26 Feb 2023 23:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455328;
        bh=VvdpziTB/laXyIc/AEtf04Gtgo7ejo9PRgIpnUjC/V4=;
        h=Date:To:From:Subject:From;
        b=Lzx1MmUucUfBp+LN19Le1aSpFCznzs5rJS9knA7yiyMJM2JTYE5t7Idmq2GkY7Fto
         TByysy813r6c++oCixHkQpcwTleug4Vhg+BoqcF5Ta+FS7rzWhkcE39g831I2G6n48
         goUk6nPqPYVLKVk+cP5XMo1pddZIJrkQcuxdhofU=
Date:   Sun, 26 Feb 2023 15:48:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tonyb@cybernetics.com, hch@lst.de, kbusch@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dmapool-consolidate-page-initialization.patch removed from -mm tree
Message-Id: <20230226234848.5CFA9C433EF@smtp.kernel.org>
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


