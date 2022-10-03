Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C51C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJCVPf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiJCVOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421B754C89
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B47CE610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10557C433C1;
        Mon,  3 Oct 2022 21:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831369;
        bh=VBv6zGGYqVrA41K0CRCPCFKp+rsRgOS7I/c3dESsvfM=;
        h=Date:To:From:Subject:From;
        b=pdj9zkATbc5IptmdoErfSz8kEpF5qkbd4At5XrbGbrxfPJksMuFeL4eXPFHR1TpTx
         +ta+zgNUn3TFy8QoUwPP8dr7uWOlNv4T7vb1pz9FUS7P6Q6cs8UolwDUOjc1bC5ohD
         VxcYKqj65HcPe/dOvjpSoJTpkfna6Po7u/r2ecYE=
Date:   Mon, 03 Oct 2022 14:09:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch removed from -mm tree
Message-Id: <20221003210929.10557C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove obsolete macro NR_PCP_ORDER_MASK and NR_PCP_ORDER_WIDTH
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete macro NR_PCP_ORDER_MASK and NR_PCP_ORDER_WIDTH
Date: Fri, 16 Sep 2022 15:22:44 +0800

Since commit 8b10b465d0e1 ("mm/page_alloc: free pages in a single pass
during bulk free"), they're not used anymore.  Remove them.

Link: https://lkml.kernel.org/r/20220916072257.9639-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 mm/page_alloc.c        |    1 -
 2 files changed, 8 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width
+++ a/include/linux/mmzone.h
@@ -564,13 +564,6 @@ enum zone_watermarks {
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
 #define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
 
-/*
- * Shift to encode migratetype and order in the same integer, with order
- * in the least significant bits.
- */
-#define NR_PCP_ORDER_WIDTH 8
-#define NR_PCP_ORDER_MASK ((1<<NR_PCP_ORDER_WIDTH) - 1)
-
 #define min_wmark_pages(z) (z->_watermark[WMARK_MIN] + z->watermark_boost)
 #define low_wmark_pages(z) (z->_watermark[WMARK_LOW] + z->watermark_boost)
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
--- a/mm/page_alloc.c~mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width
+++ a/mm/page_alloc.c
@@ -1584,7 +1584,6 @@ static void free_pcppages_bulk(struct zo
 
 		order = pindex_to_order(pindex);
 		nr_pages = 1 << order;
-		BUILD_BUG_ON(MAX_ORDER >= (1<<NR_PCP_ORDER_WIDTH));
 		do {
 			int mt;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


