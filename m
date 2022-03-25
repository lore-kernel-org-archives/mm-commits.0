Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62881C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiCYBcP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbiCYBb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D7F38BF5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7306617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B102C340EC;
        Fri, 25 Mar 2022 01:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171824;
        bh=XELsiXL0rzLckuStzF/8cAvlnYBBXjcVIuL/xfQqTQs=;
        h=Date:To:From:Subject:From;
        b=tci/uABzHSpX9GHHavr+DiVun3I0E4ukQp5WV8aKOAlCuKkNYDvWAHXkSPdfxzh+3
         GdOOP50Q5QoDRutjEjiRUNe1Tgo5k1a3ckFb3y7iKOF4JxgWB1MUKz2S1URK8iPqzJ
         JBOmVSRrHE/I+7P2M1w+SvVREQTRkwSeovq5bywc=
Date:   Thu, 24 Mar 2022 18:30:23 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, peterz@infradead.org,
        oliver.sang@intel.com, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, longman@redhat.com, guro@fb.com,
        bigeasy@linutronix.de, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch removed from -mm tree
Message-Id: <20220325013024.3B102C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()
has been removed from the -mm tree.  Its filename was
     mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/memcg: opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()

Provide the inner part of refill_stock() as __refill_stock() without
disabling interrupts.  This eases the integration of local_lock_t where
recursive locking must be avoided.  Open code obj_cgroup_uncharge_pages()
in drain_obj_stock() and use __refill_stock().  The caller of
drain_obj_stock() already disables interrupts.

[bigeasy@linutronix.de: patch body around Johannes' diff]
Link: https://lkml.kernel.org/r/20220226204144.1008339-5-bigeasy@linutronix.de
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock
+++ a/mm/memcontrol.c
@@ -2251,12 +2251,9 @@ static void drain_local_stock(struct wor
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned long flags;
-
-	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached != memcg) { /* reset if necessary */
@@ -2268,7 +2265,14 @@ static void refill_stock(struct mem_cgro
 
 	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
 		drain_stock(stock);
+}
+
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	unsigned long flags;
 
+	local_irq_save(flags);
+	__refill_stock(memcg, nr_pages);
 	local_irq_restore(flags);
 }
 
@@ -3185,8 +3189,16 @@ static void drain_obj_stock(struct memcg
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages)
-			obj_cgroup_uncharge_pages(old, nr_pages);
+		if (nr_pages) {
+			struct mem_cgroup *memcg;
+
+			memcg = get_mem_cgroup_from_objcg(old);
+
+			memcg_account_kmem(memcg, -nr_pages);
+			__refill_stock(memcg, nr_pages);
+
+			css_put(&memcg->css);
+		}
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-madvise-madv_dontneed_locked.patch

