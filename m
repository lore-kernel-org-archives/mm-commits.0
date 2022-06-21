Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87B0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352977AbiFUUIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353601AbiFUUIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDED18364
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F089DB81B1C
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8C7C3411C;
        Tue, 21 Jun 2022 20:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842116;
        bh=Cp6Zr85wERX2NAJ9aeVI2wCL/dVMOHE5mYmjIBiohPI=;
        h=Date:To:From:Subject:From;
        b=LdaNcMcx8W1yyNX7NbdA4O8/Q1g0hG/jr0vYL2zExOg2Q5vWTVotIZ4C1JmHuxeYq
         ZkHQRTc575eA6HLwU7fbwPUoM0FfzvBNpsIkicfTL1p/HoPW/UgUQj6EnykOWLP1s7
         Tkzme5VaSIDZTXyOc+XLTT+LVO2RE51zGlAQy3tg=
Date:   Tue, 21 Jun 2022 13:08:27 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-introduce-memcg_reparent_ops.patch added to mm-unstable branch
Message-Id: <20220621200834.BF8C7C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: introduce memcg_reparent_ops
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-introduce-memcg_reparent_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-introduce-memcg_reparent_ops.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: introduce memcg_reparent_ops
Date: Tue, 21 Jun 2022 20:56:55 +0800

In the previous patch, we know how to make the lruvec lock safe when LRU
pages are reparented.  We should do something like following.

    memcg_reparent_objcgs(memcg)
        1) lock
        // lruvec belongs to memcg and lruvec_parent belongs to parent memcg.
        spin_lock(&lruvec->lru_lock);
        spin_lock(&lruvec_parent->lru_lock);

        2) relocate from current memcg to its parent
        // Move all the pages from the lruvec list to the parent lruvec list.

        3) unlock
        spin_unlock(&lruvec_parent->lru_lock);
        spin_unlock(&lruvec->lru_lock);

Apart from the page lruvec lock, the deferred split queue lock (THP only)
also needs to do something similar.  So we extract the necessary three
steps in the memcg_reparent_objcgs().

    memcg_reparent_objcgs(memcg)
        1) lock
        memcg_reparent_ops->lock(memcg, parent);

        2) relocate
        memcg_reparent_ops->relocate(memcg, reparent);

        3) unlock
        memcg_reparent_ops->unlock(memcg, reparent);

Now there are two different locks (e.g.  lruvec lock and deferred split
queue lock) need to use this infrastructure.  In the next patch, we will
use those APIs to make those locks safe when the LRU pages reparented.

Link: https://lkml.kernel.org/r/20220621125658.64935-9-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   20 +++++++++++
 mm/memcontrol.c            |   60 ++++++++++++++++++++++++++++-------
 2 files changed, 68 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-introduce-memcg_reparent_ops
+++ a/include/linux/memcontrol.h
@@ -353,6 +353,26 @@ struct mem_cgroup {
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
+struct memcg_reparent_ops {
+	/*
+	 * Note that interrupt is disabled before calling those callbacks,
+	 * so the interrupt should remain disabled when leaving those callbacks.
+	 */
+	void (*lock)(struct mem_cgroup *src, struct mem_cgroup *dst);
+	void (*relocate)(struct mem_cgroup *src, struct mem_cgroup *dst);
+	void (*unlock)(struct mem_cgroup *src, struct mem_cgroup *dst);
+};
+
+#define DEFINE_MEMCG_REPARENT_OPS(name)					\
+	const struct memcg_reparent_ops memcg_##name##_reparent_ops = {	\
+		.lock		= name##_reparent_lock,			\
+		.relocate	= name##_reparent_relocate,		\
+		.unlock		= name##_reparent_unlock,		\
+	}
+
+#define DECLARE_MEMCG_REPARENT_OPS(name)				\
+	extern const struct memcg_reparent_ops memcg_##name##_reparent_ops
+
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
  * TODO: maybe necessary to use big numbers in big irons.
--- a/mm/memcontrol.c~mm-memcontrol-introduce-memcg_reparent_ops
+++ a/mm/memcontrol.c
@@ -335,24 +335,60 @@ static struct obj_cgroup *obj_cgroup_all
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static void objcg_reparent_lock(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	spin_lock(&objcg_lock);
+}
+
+static void objcg_reparent_relocate(struct mem_cgroup *src, struct mem_cgroup *dst)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
-	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
+	objcg = rcu_replace_pointer(src->objcg, NULL, true);
+	/* 1) Ready to reparent active objcg. */
+	list_add(&objcg->list, &src->objcg_list);
+	/* 2) Reparent active objcg and already reparented objcgs to dst. */
+	list_for_each_entry(iter, &src->objcg_list, list)
+		WRITE_ONCE(iter->memcg, dst);
+	/* 3) Move already reparented objcgs to the dst's list */
+	list_splice(&src->objcg_list, &dst->objcg_list);
+}
 
-	spin_lock_irq(&objcg_lock);
+static void objcg_reparent_unlock(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	spin_unlock(&objcg_lock);
+}
 
-	/* 1) Ready to reparent active objcg. */
-	list_add(&objcg->list, &memcg->objcg_list);
-	/* 2) Reparent active objcg and already reparented objcgs to parent. */
-	list_for_each_entry(iter, &memcg->objcg_list, list)
-		WRITE_ONCE(iter->memcg, parent);
-	/* 3) Move already reparented objcgs to the parent's list */
-	list_splice(&memcg->objcg_list, &parent->objcg_list);
+static DEFINE_MEMCG_REPARENT_OPS(objcg);
+
+static const struct memcg_reparent_ops *memcg_reparent_ops[] = {
+	&memcg_objcg_reparent_ops,
+};
+
+#define DEFINE_MEMCG_REPARENT_FUNC(phase)				\
+	static void memcg_reparent_##phase(struct mem_cgroup *src,	\
+					   struct mem_cgroup *dst)	\
+	{								\
+		int i;							\
+									\
+		for (i = 0; i < ARRAY_SIZE(memcg_reparent_ops); i++)	\
+			memcg_reparent_ops[i]->phase(src, dst);		\
+	}
+
+DEFINE_MEMCG_REPARENT_FUNC(lock)
+DEFINE_MEMCG_REPARENT_FUNC(relocate)
+DEFINE_MEMCG_REPARENT_FUNC(unlock)
+
+static void memcg_reparent_objcgs(struct mem_cgroup *src)
+{
+	struct mem_cgroup *dst = parent_mem_cgroup(src);
+	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
 
-	spin_unlock_irq(&objcg_lock);
+	local_irq_disable();
+	memcg_reparent_lock(src, dst);
+	memcg_reparent_relocate(src, dst);
+	memcg_reparent_unlock(src, dst);
+	local_irq_enable();
 
 	percpu_ref_kill(&objcg->refcnt);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

