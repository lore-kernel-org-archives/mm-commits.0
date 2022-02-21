Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454C0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Feb 2022 19:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiBUT1P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 14:27:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiBUT1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 14:27:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8D65FC
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 11:26:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A234B8171B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8EBC340E9;
        Mon, 21 Feb 2022 19:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645471602;
        bh=TgVI/4wiQfropnJU4Zg9dMufpuvU3gCUUcSYd2O1B+M=;
        h=Date:To:From:Subject:From;
        b=gsVlL9gS2F1ZsC+n03KJFk9Y+BYZFlxqWauiLTqQ4U7NzgbkJefag2wTDW0yNxAio
         cvshxVeniNOZeXKNo0tyskZj7b8Ecf5O4eg9J9ISoGvnigiswWjWRK7rMVHhHzLvme
         JbvzDTJPlA35r5z4Td7Q5pqKmSfdog826Nrs1wsY=
Date:   Mon, 21 Feb 2022 11:26:41 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, peterz@infradead.org,
        oliver.sang@intel.com, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, longman@redhat.com, guro@fb.com,
        bigeasy@linutronix.de, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch added to -mm tree
Message-Id: <20220221192641.EA8EBC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()
has been added to the -mm tree.  Its filename is
     mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/memcg: opencode the inner part of obj_cgroup_uncharge_pages() in drain_obj_stock()

Provide the inner part of refill_stock() as __refill_stock() without
disabling interrupts.  This eases the integration of local_lock_t where
recursive locking must be avoided.  Open code obj_cgroup_uncharge_pages()
in drain_obj_stock() and use __refill_stock().  The caller of
drain_obj_stock() already disables interrupts.

[bigeasy@linutronix.de: patch body around Johannes' diff]
Link: https://lkml.kernel.org/r/20220221182540.380526-5-bigeasy@linutronix.de
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
@@ -2244,12 +2244,9 @@ static void drain_local_stock(struct wor
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
@@ -2261,7 +2258,14 @@ static void refill_stock(struct mem_cgro
 
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
 
@@ -3178,8 +3182,16 @@ static void drain_obj_stock(struct memcg
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

mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch
mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch

