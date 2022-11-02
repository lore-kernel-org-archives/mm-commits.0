Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62670C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 20:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKBUNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiKBUNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 16:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988EDC0
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 13:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B90761BE3
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 20:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DAFC433D6;
        Wed,  2 Nov 2022 20:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667420005;
        bh=NDxviY9sOYi3CFObh9vzjb0XGQr46+Bmf0MxshxhlMQ=;
        h=Date:To:From:Subject:From;
        b=0o+a0b+Iz/C6TaLaXxeyRxn8GHYIs/jYrjm01gBnD+2wq0XUNERMApeXnaKZfmQRe
         T5UyilSrL7JGUaqEx72vwEeYw0qMtkLbqpdzpX+xMHqK793UwaXViDi7GIqpUGVMKt
         IuVal15ceydErF5Z8dJMQDv6BUnlRmAOL2x1LFr0=
Date:   Wed, 02 Nov 2022 13:13:24 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch removed from -mm tree
Message-Id: <20221102201325.80DAFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: simplify page_zone() and get_deferred_split_queue() with page_pgdat()
has been removed from the -mm tree.  Its filename was
     mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: simplify page_zone() and get_deferred_split_queue() with page_pgdat()
Date: Tue, 1 Nov 2022 10:32:19 +0800

page_zone() is too long, we can shorten it by page_pgdat().

There is no need define pgdat variable if memcg isn't NULL, so use
page_pgdat() to simplify get_deferred_split_queue().

Link: https://lkml.kernel.org/r/20221101023219.752365-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/huge_memory.c   |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat
+++ a/include/linux/mm.h
@@ -1448,14 +1448,14 @@ static inline void page_kasan_tag_reset(
 
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
 
-static inline struct zone *page_zone(const struct page *page)
+static inline pg_data_t *page_pgdat(const struct page *page)
 {
-	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
+	return NODE_DATA(page_to_nid(page));
 }
 
-static inline pg_data_t *page_pgdat(const struct page *page)
+static inline struct zone *page_zone(const struct page *page)
 {
-	return NODE_DATA(page_to_nid(page));
+	return &page_pgdat(page)->node_zones[page_zonenum(page)];
 }
 
 static inline struct zone *folio_zone(const struct folio *folio)
--- a/mm/huge_memory.c~mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat
+++ a/mm/huge_memory.c
@@ -562,19 +562,16 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 static inline struct deferred_split *get_deferred_split_queue(struct page *page)
 {
 	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
 
 	if (memcg)
 		return &memcg->deferred_split_queue;
 	else
-		return &pgdat->deferred_split_queue;
+		return &page_pgdat(page)->deferred_split_queue;
 }
 #else
 static inline struct deferred_split *get_deferred_split_queue(struct page *page)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
-
-	return &pgdat->deferred_split_queue;
+	return &page_pgdat(page)->deferred_split_queue;
 }
 #endif
 
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


