Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA94C43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbiCVVr0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbiCVVrP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8875F8F0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7148CB81D77
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF3BC340EC;
        Tue, 22 Mar 2022 21:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985545;
        bh=J09gnwx+pM4OrqpRiCN3GoxRGIEM2JJo77DhAVWt2/o=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Z29Wx5GtoDHoMxP/UeJv0ahkKwvT7trNuaLYNZYmdV5hP9wwM38v/0M0h1JnS6uZ3
         4ZAyhMilkOT0yTM9hfGX3ypoYuhRsMWTMu1iPLN9uBVbQnomGeh5K/4aAK4LkGR9hm
         jbJy5M2iUhFSr+KzeM25ZzroUYyWoISJFWA21BzI=
Date:   Tue, 22 Mar 2022 14:45:44 -0700
To:     songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        longman@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 142/227] mm/list_lru: optimize memcg_reparent_list_lru_node()
Message-Id: <20220322214545.0AF3BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/list_lru: optimize memcg_reparent_list_lru_node()

Since commit 2c80cd57c743 ("mm/list_lru.c: fix list_lru_count_node() to be
race free"), we are tracking the total number of lru entries in a
list_lru_node in its nr_items field.  In the case of
memcg_reparent_list_lru_node(), there is nothing to be done if nr_items is
0.  We don't even need to take the nlru->lock as no new lru entry could be
added by a racing list_lru_add() to the draining src_idx memcg at this
point.

On systems that serve a lot of containers, it is possible that there can
be thousands of list_lru's present due to the fact that each container may
mount its own container specific filesystems.  As a typical container uses
only a few cpus, it is likely that only the list_lru_node that contains
those cpus will be utilized while the rests may be empty.  In other words,
there can be a lot of list_lru_node with 0 nr_items.  By skipping a
lock/unlock operation and loading a cacheline from memcg_lrus, a sizeable
number of cpu cycles can be saved.  That can be substantial if we are
talking about thousands of list_lru_node's with 0 nr_items.

Link: https://lkml.kernel.org/r/20220309144000.1470138-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/list_lru.c~mm-list_lru-optimize-memcg_reparent_list_lru_node
+++ a/mm/list_lru.c
@@ -395,6 +395,12 @@ static void memcg_reparent_list_lru_node
 	struct list_lru_one *src, *dst;
 
 	/*
+	 * If there is no lru entry in this nlru, we can skip it immediately.
+	 */
+	if (!READ_ONCE(nlru->nr_items))
+		return;
+
+	/*
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
_
