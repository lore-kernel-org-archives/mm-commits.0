Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9A6EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjHUUjt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjHUUjb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E2A13E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EAFE64B06
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3345C433C8;
        Mon, 21 Aug 2023 20:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650367;
        bh=HeZLB/0vaom0BXG6YX8FiV/g0OllPrU6PIRldcFm/hc=;
        h=Date:To:From:Subject:From;
        b=WoQ2xoJEx2A0KAYMhcw/vdV925dZdz5RJMVWQvRzmqTY6Fu4CqDCwWkTj86kfq0mj
         XXjzOX6wBMlt2KG9V8wvX6K2WgMWBW7ytECANSlM5ulJqp5trLQ8rjKT/GOCnDhJCq
         cj7mvZRtkt9deYMthE6lBeqKoK28iuAiGfuyopow=
Date:   Mon, 21 Aug 2023 13:39:26 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch removed from -mm tree
Message-Id: <20230821203926.F3345C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: avoid unneeded alike_pages calculation
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: avoid unneeded alike_pages calculation
Date: Tue, 1 Aug 2023 20:37:23 +0800

When free_pages is 0, alike_pages is not used.  So alike_pages calculation
can be avoided by checking free_pages early to save cpu cycles.  Also fix
typo 'comparable'.  It should be 'compatible' here.

Link: https://lkml.kernel.org/r/20230801123723.2225543-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-unneeded-alike_pages-calculation
+++ a/mm/page_alloc.c
@@ -1833,6 +1833,10 @@ static void steal_suitable_fallback(stru
 
 	free_pages = move_freepages_block(zone, page, start_type,
 						&movable_pages);
+	/* moving whole block can fail due to zone boundary conditions */
+	if (!free_pages)
+		goto single_page;
+
 	/*
 	 * Determine how many pages are compatible with our allocation.
 	 * For movable allocation, it's the number of movable pages which
@@ -1854,14 +1858,9 @@ static void steal_suitable_fallback(stru
 		else
 			alike_pages = 0;
 	}
-
-	/* moving whole block can fail due to zone boundary conditions */
-	if (!free_pages)
-		goto single_page;
-
 	/*
 	 * If a sufficient number of pages in the block are either free or of
-	 * comparable migratability as our allocation, claim the whole block.
+	 * compatible migratability as our allocation, claim the whole block.
 	 */
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-add-pageoffline-check.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch

