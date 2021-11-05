Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E6AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1852761263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhKEUke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhKEUkd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E132611C0;
        Fri,  5 Nov 2021 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144673;
        bh=FZcD3yo9NxFRA7vGHyNmjobiIoJIRxzisn67CwJuB+0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YbDLvOYq77twMFEiUh7N0MnH8Ia5H5ZzKUv/RjfHe0xmFLPIfMF6HsDS4OlRbfay/
         rhPqK9yChT6bdtYowHnkEIPuRuPpjnKzUw5pjM8tuMxyNa+kDTUiq7o/glW5XbnnyZ
         oPQHtafHsoiZ2P3ojSDFbWp/qQRlndWDZvZ2Q9Tc=
Date:   Fri, 05 Nov 2021 13:37:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 062/262] mm: memcontrol: remove kmemcg_id
 reparenting
Message-ID: <20211105203753.q3Y-GvB-j%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
