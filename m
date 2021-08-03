Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89F8C4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 20:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8935C61078
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 20:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhHCUSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 16:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhHCUSa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 16:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B489660F45;
        Tue,  3 Aug 2021 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628021899;
        bh=5OKMIoLNl4te34aDbkHMDBIdrUVOHVx0bLPUOJDkK9s=;
        h=Date:From:To:Subject:From;
        b=ENRSV62nMxscpKPB//kzopk4iyVw3vTd0pjfc5Ojt1Tzdjm6fe89+2QLC0Mj+vieu
         1MXha8n1zrqOXnmO3wiwFgJW7VV6OGv/XLSiXQUcyPA0kuM+TsorMoRJ3MvYpv5MaO
         CiC7EkCQAw+kjnOH6Pl/quN2kQEcR3Lx8mUM351A=
Date:   Tue, 03 Aug 2021 13:18:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        songmuchun@bytedance.com, shakeelb@google.com, mhocko@kernel.org,
        lgoncalv@redhat.com, hannes@cmpxchg.org, guro@fb.com,
        longman@redhat.com
Subject:  + mm-memcg-disable-task-obj_stock-for-preempt_rt.patch
 added to -mm tree
Message-ID: <20210803201816.GN6NB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: disable task obj_stock for PREEMPT_RT
has been added to the -mm tree.  Its filename is
     mm-memcg-disable-task-obj_stock-for-preempt_rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-disable-task-obj_stock-for-preempt_rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-disable-task-obj_stock-for-preempt_rt.patch

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
Subject: mm/memcg: disable task obj_stock for PREEMPT_RT

For PREEMPT_RT kernel, preempt_disable() and local_irq_save() are
typically converted to local_lock() and local_lock_irqsave() respectively.
These two variants of local_lock() are essentially the same.  Thus, there
is no performance advantage in choosing one over the other.

As there is no point in maintaining two different sets of obj_stock, it is
simpler and more efficient to just disable task_obj and use only irq_obj
for PREEMPT_RT.  However, task_obj will still be there in the
memcg_stock_pcp structure even though it is not used in this
configuration.

Link: https://lkml.kernel.org/r/20210803175519.22298-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-disable-task-obj_stock-for-preempt_rt
+++ a/mm/memcontrol.c
@@ -2093,12 +2093,22 @@ static bool obj_stock_flush_required(str
  * which is cheap in non-preempt kernel. The interrupt context object stock
  * can only be accessed after disabling interrupt. User context code can
  * access interrupt object stock, but not vice versa.
+ *
+ * For PREEMPT_RT kernel, preempt_disable() and local_irq_save() may have
+ * to be changed to variants of local_lock(). This eliminates the
+ * performance advantage of using preempt_disable(). Fall back to always
+ * use local_irq_save() and use only irq_obj for simplicity.
  */
+static inline bool use_task_obj_stock(void)
+{
+	return !IS_ENABLED(CONFIG_PREEMPT_RT) && likely(in_task());
+}
+
 static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
 {
 	struct memcg_stock_pcp *stock;
 
-	if (likely(in_task())) {
+	if (use_task_obj_stock()) {
 		*pflags = 0UL;
 		preempt_disable();
 		stock = this_cpu_ptr(&memcg_stock);
@@ -2112,7 +2122,7 @@ static inline struct obj_stock *get_obj_
 
 static inline void put_obj_stock(unsigned long flags)
 {
-	if (likely(in_task()))
+	if (use_task_obj_stock())
 		preempt_enable();
 	else
 		local_irq_restore(flags);
@@ -2185,7 +2195,7 @@ static void drain_local_stock(struct wor
 
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_obj_stock(&stock->irq_obj);
-	if (in_task())
+	if (use_task_obj_stock())
 		drain_obj_stock(&stock->task_obj);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
@@ -3163,7 +3173,7 @@ static bool obj_stock_flush_required(str
 {
 	struct mem_cgroup *memcg;
 
-	if (in_task() && stock->task_obj.cached_objcg) {
+	if (use_task_obj_stock() && stock->task_obj.cached_objcg) {
 		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-fix-incorrect-flushing-of-lruvec-data-in-obj_stock.patch
mm-memcg-disable-task-obj_stock-for-preempt_rt.patch

