Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8CCC43219
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhK2WXt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhK2WV6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:21:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C15C06FD43
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 12:15:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74720CE140F
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 20:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F60C53FAD;
        Mon, 29 Nov 2021 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638216937;
        bh=q8nmy8aFxLoSI4qQAXMKof1YAHMuZTxsye8AJscN0BQ=;
        h=Date:From:To:Subject:From;
        b=WjcrcB6LUpUddVfNYDG+Uo8scKBQoLQ1LBKM7MmohmAHO7X4G79phipc9CWX2DGG0
         K9GL+xeBOuuQOR9v2bY8AGsx5K55VjiX5FpivINLaJeFLfBUonmD48103UQ/JHC+KM
         7y6n1Nj/d6CyOzj0ACbZXLphJq23SHjVEnynuTiI=
Date:   Mon, 29 Nov 2021 12:15:36 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, lkp@intel.com, longman@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock.patch
 added to -mm tree
Message-ID: <20211129201536.NFKadbuJi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: relocate mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()
has been added to the -mm tree.  Its filename is
     mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: relocate mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()

All the calls to mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()
are done by functions defined within the same "#ifdef CONFIG_MEMCG_KMEM"
compilation block.  When CONFIG_MEMCG_KMEM isn't defined, the following
compilation warnings will be issued [1] and [2].

  mm/memcontrol.c:785:20: warning: unused function 'mod_objcg_mlstate'
  mm/memcontrol.c:2113:33: warning: unused function 'get_obj_stock'

Fix these warning by moving those functions to under the same
CONFIG_MEMCG_KMEM compilation block.  There is no functional change.

[1] https://lore.kernel.org/lkml/202111272014.WOYNLUV6-lkp@intel.com/
[2] https://lore.kernel.org/lkml/202111280551.LXsWYt1T-lkp@intel.com/

Link: https://lkml.kernel.org/r/20211129161140.306488-1-longman@redhat.com
Fixes: 559271146efc ("mm/memcg: optimize user context object stock access")
Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  106 +++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 53 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock
+++ a/mm/memcontrol.c
@@ -776,24 +776,6 @@ void __mod_lruvec_kmem_state(void *p, en
 	rcu_read_unlock();
 }
 
-/*
- * mod_objcg_mlstate() may be called with irq enabled, so
- * mod_memcg_lruvec_state() should be used.
- */
-static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
-				     struct pglist_data *pgdat,
-				     enum node_stat_item idx, int nr)
-{
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
-	rcu_read_unlock();
-}
-
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
@@ -2137,41 +2119,6 @@ static bool obj_stock_flush_required(str
 }
 #endif
 
-/*
- * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
- * sequence used in this case to access content from object stock is slow.
- * To optimize for user context access, there are now two object stocks for
- * task context and interrupt context access respectively.
- *
- * The task context object stock can be accessed by disabling preemption only
- * which is cheap in non-preempt kernel. The interrupt context object stock
- * can only be accessed after disabling interrupt. User context code can
- * access interrupt object stock, but not vice versa.
- */
-static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (likely(in_task())) {
-		*pflags = 0UL;
-		preempt_disable();
-		stock = this_cpu_ptr(&memcg_stock);
-		return &stock->task_obj;
-	}
-
-	local_irq_save(*pflags);
-	stock = this_cpu_ptr(&memcg_stock);
-	return &stock->irq_obj;
-}
-
-static inline void put_obj_stock(unsigned long flags)
-{
-	if (likely(in_task()))
-		preempt_enable();
-	else
-		local_irq_restore(flags);
-}
-
 /**
  * consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
@@ -2816,6 +2763,59 @@ retry:
  */
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
 
+/*
+ * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
+ * sequence used in this case to access content from object stock is slow.
+ * To optimize for user context access, there are now two object stocks for
+ * task context and interrupt context access respectively.
+ *
+ * The task context object stock can be accessed by disabling preemption only
+ * which is cheap in non-preempt kernel. The interrupt context object stock
+ * can only be accessed after disabling interrupt. User context code can
+ * access interrupt object stock, but not vice versa.
+ */
+static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
+{
+	struct memcg_stock_pcp *stock;
+
+	if (likely(in_task())) {
+		*pflags = 0UL;
+		preempt_disable();
+		stock = this_cpu_ptr(&memcg_stock);
+		return &stock->task_obj;
+	}
+
+	local_irq_save(*pflags);
+	stock = this_cpu_ptr(&memcg_stock);
+	return &stock->irq_obj;
+}
+
+static inline void put_obj_stock(unsigned long flags)
+{
+	if (likely(in_task()))
+		preempt_enable();
+	else
+		local_irq_restore(flags);
+}
+
+/*
+ * mod_objcg_mlstate() may be called with irq enabled, so
+ * mod_memcg_lruvec_state() should be used.
+ */
+static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
+				     struct pglist_data *pgdat,
+				     enum node_stat_item idx, int nr)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
+	rcu_read_unlock();
+}
+
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page)
 {
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-relocate-mod_objcg_mlstate-get_obj_stock-and-put_obj_stock.patch

