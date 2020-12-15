Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D69DC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0324022522
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgLODIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgLODHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:20 -0500
Date:   Mon, 14 Dec 2020 19:07:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001625;
        bh=xZzsS4lsONNJhNuYISpjgqXQQ3lT8dESfsrJfkzovb0=;
        h=From:To:Subject:In-Reply-To:From;
        b=t9yX4QefXfVUqzl1koyhKX26C92W9jgMFdZCKKa6jNWR36wZdb3uvht86q6WFPfea
         JlYLqmNfPZSE1G9GAWP/QAZ+mptKZN9NYtRvws0+YQ1JVcdSgewm75b2TajN685ohJ
         EEKn4uAhAjMyWmJxYQEWjFztw8HdVWcqzOR2Iz04=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 068/200] mm: memcg/slab: rename
 *_lruvec_slab_state to *_lruvec_kmem_state
Message-ID: <20201215030704.SxteSe0N3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: rename *_lruvec_slab_state to *_lruvec_kmem_state

The *_lruvec_slab_state is also suitable for pages allocated from buddy,
not just for the slab objects.  But the function name seems to tell us
that only slab object is applicable.  So we can rename the keyword of slab
to kmem.

Link: https://lkml.kernel.org/r/20201117085249.24319-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++++++---------
 kernel/fork.c              |    2 +-
 mm/memcontrol.c            |    2 +-
 mm/workingset.c            |    8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/include/linux/memcontrol.h
@@ -788,15 +788,15 @@ void __mod_memcg_lruvec_state(struct lru
 			      int val);
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
-void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
-static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__mod_lruvec_slab_state(p, idx, val);
+	__mod_lruvec_kmem_state(p, idx, val);
 	local_irq_restore(flags);
 }
 
@@ -1229,7 +1229,7 @@ static inline void mod_lruvec_page_state
 	mod_node_page_state(page_pgdat(page), idx, val);
 }
 
-static inline void __mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					   int val)
 {
 	struct page *page = virt_to_head_page(p);
@@ -1237,7 +1237,7 @@ static inline void __mod_lruvec_slab_sta
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
-static inline void mod_lruvec_slab_state(void *p, enum node_stat_item idx,
+static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
 	struct page *page = virt_to_head_page(p);
@@ -1332,14 +1332,14 @@ static inline void __dec_lruvec_page_sta
 	__mod_lruvec_page_state(page, idx, -1);
 }
 
-static inline void __inc_lruvec_slab_state(void *p, enum node_stat_item idx)
+static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_slab_state(p, idx, 1);
+	__mod_lruvec_kmem_state(p, idx, 1);
 }
 
-static inline void __dec_lruvec_slab_state(void *p, enum node_stat_item idx)
+static inline void __dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_slab_state(p, idx, -1);
+	__mod_lruvec_kmem_state(p, idx, -1);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
--- a/kernel/fork.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/kernel/fork.c
@@ -385,7 +385,7 @@ static void account_kernel_stack(struct
 		mod_lruvec_page_state(vm->pages[0], NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
 	else
-		mod_lruvec_slab_state(stack, NR_KERNEL_STACK_KB,
+		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
 				      account * (THREAD_SIZE / 1024));
 }
 
--- a/mm/memcontrol.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/mm/memcontrol.c
@@ -853,7 +853,7 @@ void __mod_lruvec_state(struct lruvec *l
 		__mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
+void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
--- a/mm/workingset.c~mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state
+++ a/mm/workingset.c
@@ -445,12 +445,12 @@ void workingset_update_node(struct xa_no
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
 			list_lru_add(&shadow_nodes, &node->private_list);
-			__inc_lruvec_slab_state(node, WORKINGSET_NODES);
+			__inc_lruvec_kmem_state(node, WORKINGSET_NODES);
 		}
 	} else {
 		if (!list_empty(&node->private_list)) {
 			list_lru_del(&shadow_nodes, &node->private_list);
-			__dec_lruvec_slab_state(node, WORKINGSET_NODES);
+			__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
 		}
 	}
 }
@@ -544,7 +544,7 @@ static enum lru_status shadow_lru_isolat
 	}
 
 	list_lru_isolate(lru, item);
-	__dec_lruvec_slab_state(node, WORKINGSET_NODES);
+	__dec_lruvec_kmem_state(node, WORKINGSET_NODES);
 
 	spin_unlock(lru_lock);
 
@@ -559,7 +559,7 @@ static enum lru_status shadow_lru_isolat
 		goto out_invalid;
 	mapping->nrexceptional -= node->nr_values;
 	xa_delete_node(node, workingset_update_node);
-	__inc_lruvec_slab_state(node, WORKINGSET_NODERECLAIM);
+	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
_
