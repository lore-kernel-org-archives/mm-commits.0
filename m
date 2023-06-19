Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD50C001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFSX0v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjFSXZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F31BC5
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B6560FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35239C433C8;
        Mon, 19 Jun 2023 23:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216997;
        bh=EDeA79OrUvK16hzzo0r3YK6GoXLUMOyu70k905CcgTk=;
        h=Date:To:From:Subject:From;
        b=ZO4RMPLAOOeH33BRw6OYlgjwtZjSrkv8IQu/f5dxwnVrPb3M6+WQApW/D864gc2ld
         xzKOvqp8jdcWXGtfBpplb2l+Vy/e/QPoNYxEs+FFSunVXB4VlPNx9mnJeRmpYPp/6D
         XpGtPf77QapRVksQcsQdGw5gz58xC3GAGP9ZT66c=
Date:   Mon, 19 Jun 2023 16:23:16 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch removed from -mm tree
Message-Id: <20230619232317.35239C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_owner/cma: show pfn in cma/page_owner with hex format
has been removed from the -mm tree.  Its filename was
     mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kassey Li <quic_yingangl@quicinc.com>
Subject: mm/page_owner/cma: show pfn in cma/page_owner with hex format
Date: Tue, 13 Jun 2023 17:25:33 +0800

cma: display pfn as well as pfn_to_page(pfn)

page_owner: display pfn in hex rather than decimal

Link: https://lkml.kernel.org/r/20230613092533.15449-1-quic_yingangl@quicinc.com
Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c        |    4 ++--
 mm/page_owner.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/cma.c~mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format
+++ a/mm/cma.c
@@ -483,8 +483,8 @@ struct page *cma_alloc(struct cma *cma,
 		if (ret != -EBUSY)
 			break;
 
-		pr_debug("%s(): memory range at %p is busy, retrying\n",
-			 __func__, pfn_to_page(pfn));
+		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
+			 __func__, pfn, pfn_to_page(pfn));
 
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
--- a/mm/page_owner.c~mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format
+++ a/mm/page_owner.c
@@ -418,7 +418,7 @@ print_page_owner(char __user *buf, size_
 	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfp_migratetype(page_owner->gfp_mask);
 	ret += scnprintf(kbuf + ret, count - ret,
-			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
+			"PFN 0x%lx type %s Block %lu type %s Flags %pGp\n",
 			pfn,
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
_

Patches currently in -mm which might be from quic_yingangl@quicinc.com are


