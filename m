Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C395EC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 01:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243625AbiDABD1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 21:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiDABD1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 21:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AAC223229
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 18:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ADC1618D1
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 01:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CAFC340EE;
        Fri,  1 Apr 2022 01:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648774897;
        bh=36T+1i76UPMQCKdQhF8HvP/2zIxONPHwoK6sHBmwyOY=;
        h=Date:To:From:Subject:From;
        b=tNlvcWeY7i7M2IuJwR2wrfUu7eD22jFLuQEqkLOVeMy91Cdp3M/shxGuri/6dMQg0
         iBBfZ5DwqC8pSuqbJFuokrEWLvQe5PtoFvWQr/KMFCteMgaCr9wmNnOBlL99SRIlmd
         D6dlhhMi/ob706OhC2ogJXLDJAMEQoWkkV1nl+rY=
Date:   Thu, 31 Mar 2022 18:01:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-list_lru-fix-possible-race-in-memcg_reparent_list_lru_node.patch removed from -mm tree
Message-Id: <20220401010137.98CAFC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru: fix possible race in memcg_reparent_list_lru_node()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-fix-possible-race-in-memcg_reparent_list_lru_node.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/list_lru: fix possible race in memcg_reparent_list_lru_node()

Muchun Song found out there could be a race between list_lru_add() and
memcg_reparent_list_lru_node() causing the later function to miss
reparenting of a lru entry as shown below:

CPU0:                           CPU1:
list_lru_add()
    spin_lock(&nlru->lock)
    l = list_lru_from_kmem(memcg)
                                memcg_reparent_objcgs(memcg)
                                memcg_reparent_list_lrus(memcg)
                                    memcg_reparent_list_lru()
                                        memcg_reparent_list_lru_node()
                                            if (!READ_ONCE(nlru->nr_items))
                                                // Miss reparenting
                                                return
    // Assume 0->1
    l->nr_items++
    // Assume 0->1
    nlru->nr_items++

Though it is not likely that a list_lru_node that has 0 item suddenly has
a newly added lru entry at the end of its life.  The race is still
theoretically possible.

With the lock/unlock pair used within the percpu_ref_kill() which is the
last function call of memcg_reparent_objcgs(), any read issued in
memcg_reparent_list_lru_node() will not be reordered before the
reparenting of objcgs.

Adding a !spin_is_locked()/smp_rmb()/!READ_ONCE(nlru->nr_items) check to
ensure that either the reading of nr_items is valid or the racing
list_lru_add() will see the reparented objcg.

Link: https://lkml.kernel.org/r/20220330172646.2687555-1-longman@redhat.com
Fixes: 405cc51fc104 ("mm/list_lru: optimize memcg_reparent_list_lru_node()")
Reported-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-possible-race-in-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,10 +395,33 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
-	 * If there is no lru entry in this nlru, we can skip it immediately.
+	 * With the lock/unlock pair used within the percpu_ref_kill()
+	 * which is the last function call of memcg_reparent_objcgs(), any
+	 * read issued here will not be reordered before the reparenting
+	 * of objcgs.
+	 *
+	 * Assuming a racing list_lru_add():
+	 * list_lru_add()
+	 *				<- memcg_reparent_list_lru_node()
+	 *   spin_lock(&nlru->lock)
+	 *   l = list_lru_from_kmem(memcg)
+	 *   nlru->nr_items++
+	 *   spin_unlock(&nlru->lock)
+	 *				<- memcg_reparent_list_lru_node()
+	 *
+	 * The !spin_is_locked(&nlru->lock) check is true means it is
+	 * either before the spin_lock() or after the spin_unlock(). In the
+	 * former case, list_lru_add() will see the reparented objcg and so
+	 * won't touch the lru to be reparented. In the later case, it will
+	 * see the updated nr_items. So we can use the optimization that if
+	 * there is no lru entry in this nlru, skip it immediately.
 	 */
-	if (!READ_ONCE(nlru->nr_items))
-		return;
+	if (!spin_is_locked(&nlru->lock)) {
+		/* nr_items read must be ordered after nlru->lock */
+		smp_rmb();
+		if (!READ_ONCE(nlru->nr_items))
+			return;
+	}
 
 	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
@@ -407,7 +430,7 @@ static void memcg_reparent_list_lru_node
 	spin_lock_irq(&nlru->lock);
 
 	src = list_lru_from_memcg_idx(lru, nid, src_idx);
-	if (!src)
+	if (!src || !src->nr_items)
 		goto out;
 	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
 
_

Patches currently in -mm which might be from longman@redhat.com are

mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

