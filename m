Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4774C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C09460E73
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244555AbhJ0VVI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:32964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244382AbhJ0VUj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4EFA610C7;
        Wed, 27 Oct 2021 21:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635369493;
        bh=HpuSvz3nmrfRemCeu+s5ecTO7tTD3pdacnp+W6tU8HI=;
        h=Date:From:To:Subject:From;
        b=2pZ6IH3nxTnIod3dugGZw1+EwjBfEEGxsxrqOb05TPuhVy1esyMNvuSijNeO0U2x2
         tasDR4eIfaSjqOjTad/BPL90ZL2d1EBjumDE7zZa6Q/Uaue7ugYXkbiLPGp61tqsrS
         Tf/5Wk7QtGft1z9VgczCK27/EcvTQKVbVGj6Zh/I=
Date:   Wed, 27 Oct 2021 14:18:12 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  + mm-memcontrol-remove-kmemcg_id-reparenting.patch added
 to -mm tree
Message-ID: <20211027211812.Iott9iKkg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove kmemcg_id reparenting
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-kmemcg_id-reparenting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-kmemcg_id-reparenting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-kmemcg_id-reparenting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: remove kmemcg_id reparenting

Since slab objects and kmem pages are charged to object cgroup instead of
memory cgroup, memcg_reparent_objcgs() will reparent this cgroup and all
its descendants to its parent cgroup.  This already makes further
list_lru_add()'s add elements to the parent's list.  So it is unnecessary
to change kmemcg_id of an offline cgroup to its parent's id.  It just
wastes CPU cycles.  Just to remove those redundant code.

Link: https://lkml.kernel.org/r/20211025125102.56533-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-kmemcg_id-reparenting
+++ a/mm/memcontrol.c
@@ -3650,8 +3650,7 @@ static int memcg_online_kmem(struct mem_
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
-	struct cgroup_subsys_state *css;
-	struct mem_cgroup *parent, *child;
+	struct mem_cgroup *parent;
 	int kmemcg_id;
 
 	if (memcg->kmem_state != KMEM_ONLINE)
@@ -3669,21 +3668,11 @@ static void memcg_offline_kmem(struct me
 	BUG_ON(kmemcg_id < 0);
 
 	/*
-	 * Change kmemcg_id of this cgroup and all its descendants to the
-	 * parent's id, and then move all entries from this cgroup's list_lrus
-	 * to ones of the parent. After we have finished, all list_lrus
-	 * corresponding to this cgroup are guaranteed to remain empty. The
-	 * ordering is imposed by list_lru_node->lock taken by
+	 * After we have finished memcg_reparent_objcgs(), all list_lrus
+	 * corresponding to this cgroup are guaranteed to remain empty.
+	 * The ordering is imposed by list_lru_node->lock taken by
 	 * memcg_drain_all_list_lrus().
 	 */
-	rcu_read_lock(); /* can be called from css_free w/o cgroup_mutex */
-	css_for_each_descendant_pre(css, &memcg->css) {
-		child = mem_cgroup_from_css(css);
-		BUG_ON(child->kmemcg_id != kmemcg_id);
-		child->kmemcg_id = parent->kmemcg_id;
-	}
-	rcu_read_unlock();
-
 	memcg_drain_all_list_lrus(kmemcg_id, parent);
 
 	memcg_free_cache_id(kmemcg_id);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-remove-holding-lru-lock.patch
mm-list_lru-fix-the-return-value-of-list_lru_count_one.patch
mm-memcontrol-remove-kmemcg_id-reparenting.patch
mm-memcontrol-remove-the-kmem-states.patch

