Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5E1C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjFIX0x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjFIX0u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3C130F5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4140065CD4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B406C433D2;
        Fri,  9 Jun 2023 23:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353208;
        bh=DfruRubdEOqYC402wk2HOeKUKrfPXvw1Wd7Aqht4SgY=;
        h=Date:To:From:Subject:From;
        b=tB8qL4LDHLsrP9/4evsbIiMg0YrRrzoAK6d/RxbkAzbWSEXPwzeVEg0XxvMMpNYAS
         QkA+/McKbxH6yDRXyZq16zUXZg3J64/vyfYUceYxGNUfW/Ouo7RIMAcOn4EiOYFavE
         GByu3moc7fVZ+Eh3X6XHX201b45dmb2Po62joUN0=
Date:   Fri, 09 Jun 2023 16:26:47 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        shakeelb@google.com, dvyukov@google.com, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-use-read_once-write_once-to-access-stock-cached.patch removed from -mm tree
Message-Id: <20230609232648.9B406C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: use READ_ONCE()/WRITE_ONCE() to access stock->cached
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-read_once-write_once-to-access-stock-cached.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: use READ_ONCE()/WRITE_ONCE() to access stock->cached
Date: Tue, 2 May 2023 09:08:39 -0700

A memcg pointer in the percpu stock can be accessed by drain_all_stock()
from another cpu in a lockless way.  In theory it might lead to an issue,
similar to the one which has been discovered with stock->cached_objcg,
where the pointer was zeroed between the check for being NULL and
dereferencing.  In this case the issue is unlikely a real problem, but to
make it bulletproof and similar to stock->cached_objcg, let's annotate all
accesses to stock->cached with READ_ONCE()/WTRITE_ONCE().

Link: https://lkml.kernel.org/r/20230502160839.361544-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-read_once-write_once-to-access-stock-cached
+++ a/mm/memcontrol.c
@@ -2275,7 +2275,7 @@ static bool consume_stock(struct mem_cgr
 	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
+	if (memcg == READ_ONCE(stock->cached) && stock->nr_pages >= nr_pages) {
 		stock->nr_pages -= nr_pages;
 		ret = true;
 	}
@@ -2290,7 +2290,7 @@ static bool consume_stock(struct mem_cgr
  */
 static void drain_stock(struct memcg_stock_pcp *stock)
 {
-	struct mem_cgroup *old = stock->cached;
+	struct mem_cgroup *old = READ_ONCE(stock->cached);
 
 	if (!old)
 		return;
@@ -2303,7 +2303,7 @@ static void drain_stock(struct memcg_sto
 	}
 
 	css_put(&old->css);
-	stock->cached = NULL;
+	WRITE_ONCE(stock->cached, NULL);
 }
 
 static void drain_local_stock(struct work_struct *dummy)
@@ -2338,10 +2338,10 @@ static void __refill_stock(struct mem_cg
 	struct memcg_stock_pcp *stock;
 
 	stock = this_cpu_ptr(&memcg_stock);
-	if (stock->cached != memcg) { /* reset if necessary */
+	if (READ_ONCE(stock->cached) != memcg) { /* reset if necessary */
 		drain_stock(stock);
 		css_get(&memcg->css);
-		stock->cached = memcg;
+		WRITE_ONCE(stock->cached, memcg);
 	}
 	stock->nr_pages += nr_pages;
 
@@ -2383,7 +2383,7 @@ static void drain_all_stock(struct mem_c
 		bool flush = false;
 
 		rcu_read_lock();
-		memcg = stock->cached;
+		memcg = READ_ONCE(stock->cached);
 		if (memcg && stock->nr_pages &&
 		    mem_cgroup_is_descendant(memcg, root_memcg))
 			flush = true;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


