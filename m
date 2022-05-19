Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B18C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbiESVEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiESVEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:04:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E3C5BD3B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A666CB8280A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67840C385AA;
        Thu, 19 May 2022 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994283;
        bh=44aWppJ2343N66zXMagq9RxVvFYrOe667/lAiMP89Ps=;
        h=Date:To:From:Subject:From;
        b=1PGDAlTo0wXd+ihjvDfC8fe3SeK8v5NKR8uopzdyuU3s5IPAdTahgx9a8Mbgee3FE
         6zMaJTPQiDmZlmHrzWftu7vq1X+NJ3GZqtOM2eJNzpFJ3OzagoMWx14Z86PoEmmjpq
         8xYlFmUZqiuq9hOscRBYmm3f6ua4ZJb76NuOxw6Q=
Date:   Thu, 19 May 2022 14:04:42 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        akinobu.mita@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-missing-handler-for-__gfp_nowarn-v2.patch removed from -mm tree
Message-Id: <20220519210443.67840C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-missing-handler-for-__gfp_nowarn-v2
has been removed from the -mm tree.  Its filename was
     mm-fix-missing-handler-for-__gfp_nowarn-v2.patch

This patch was dropped because it was folded into mm-fix-missing-handler-for-__gfp_nowarn.patch

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-fix-missing-handler-for-__gfp_nowarn-v2

  - add comment to WARN_ON_ONCE_GFP
  - handle __alloc_contig_migrate_range() case
  - do not deal with:
	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));

Link: https://lkml.kernel.org/r/20220511061951.1114-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-fix-missing-handler-for-__gfp_nowarn-v2
+++ a/mm/internal.h
@@ -35,6 +35,10 @@ struct folio_batch;
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
+/*
+ * Different from WARN_ON_ONCE(), no warning will be issued
+ * when we specify __GFP_NOWARN.
+ */
 #define WARN_ON_ONCE_GFP(cond, gfp)	({				\
 	static bool __section(".data.once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
--- a/mm/page_alloc.c~mm-fix-missing-handler-for-__gfp_nowarn-v2
+++ a/mm/page_alloc.c
@@ -3712,7 +3712,7 @@ struct page *rmqueue(struct zone *prefer
 	 * We most definitely don't want callers attempting to
 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
 	 */
-	WARN_ON_ONCE_GFP((gfp_flags & __GFP_NOFAIL) && (order > 1), gfp_flags);
+	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 
 	do {
 		page = NULL;
@@ -9027,7 +9027,7 @@ int __alloc_contig_migrate_range(struct
 
 	lru_cache_enable();
 	if (ret < 0) {
-		if (ret == -EBUSY)
+		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
 		return ret;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-fix-missing-handler-for-__gfp_nowarn.patch

