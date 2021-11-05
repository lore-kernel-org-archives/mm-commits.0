Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DD8C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328906126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhKEUkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhKEUkh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A006056B;
        Fri,  5 Nov 2021 20:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144677;
        bh=9h0IigcCmrTEt+4eoM3rVMbgJmqxLhcDzX7zddFmjw4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s4SNBDfe1Fiq/fnw/c7NL3wC7RbI1zJsdlzPQ/kHBwkdiBc1+IWJ6buYX+HBNigcD
         9a2KTu6MWR3zQOaK1Y+6dus98KjHYJs8Wf9GZenum7QbDKqRcE+Q4T/fxnBqu6YLel
         DweUYEQCSd1psGM6ZL3dvnsO2x8oPrDafggpHbsY=
Date:   Fri, 05 Nov 2021 13:37:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 063/262] mm: memcontrol: remove the kmem states
Message-ID: <20211105203756.ePVAGAdsI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: remove the kmem states

Now the kmem states is only used to indicate whether the kmem is offline. 
However, we can set ->kmemcg_id to -1 to indicate whether the kmem is
offline.  Finally, we can remove the kmem states to simplify the code.

Link: https://lkml.kernel.org/r/20211025125259.56624-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 -------
 mm/memcontrol.c            |    7 ++-----
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-the-kmem-states
+++ a/include/linux/memcontrol.h
@@ -180,12 +180,6 @@ struct mem_cgroup_thresholds {
 	struct mem_cgroup_threshold_ary *spare;
 };
 
-enum memcg_kmem_state {
-	KMEM_NONE,
-	KMEM_ALLOCATED,
-	KMEM_ONLINE,
-};
-
 #if defined(CONFIG_SMP)
 struct memcg_padding {
 	char x[0];
@@ -318,7 +312,6 @@ struct mem_cgroup {
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
-	enum memcg_kmem_state kmem_state;
 	struct obj_cgroup __rcu *objcg;
 	struct list_head objcg_list; /* list of inherited objcgs */
 #endif
--- a/mm/memcontrol.c~mm-memcontrol-remove-the-kmem-states
+++ a/mm/memcontrol.c
@@ -3626,7 +3626,6 @@ static int memcg_online_kmem(struct mem_
 		return 0;
 
 	BUG_ON(memcg->kmemcg_id >= 0);
-	BUG_ON(memcg->kmem_state);
 
 	memcg_id = memcg_alloc_cache_id();
 	if (memcg_id < 0)
@@ -3643,7 +3642,6 @@ static int memcg_online_kmem(struct mem_
 	static_branch_enable(&memcg_kmem_enabled_key);
 
 	memcg->kmemcg_id = memcg_id;
-	memcg->kmem_state = KMEM_ONLINE;
 
 	return 0;
 }
@@ -3653,11 +3651,9 @@ static void memcg_offline_kmem(struct me
 	struct mem_cgroup *parent;
 	int kmemcg_id;
 
-	if (memcg->kmem_state != KMEM_ONLINE)
+	if (memcg->kmemcg_id == -1)
 		return;
 
-	memcg->kmem_state = KMEM_ALLOCATED;
-
 	parent = parent_mem_cgroup(memcg);
 	if (!parent)
 		parent = root_mem_cgroup;
@@ -3676,6 +3672,7 @@ static void memcg_offline_kmem(struct me
 	memcg_drain_all_list_lrus(kmemcg_id, parent);
 
 	memcg_free_cache_id(kmemcg_id);
+	memcg->kmemcg_id = -1;
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
_
