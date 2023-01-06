Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03840C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbjAFAmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbjAFAmG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:42:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95EE5F4A8
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61105B81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3565C433D2;
        Fri,  6 Jan 2023 00:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965721;
        bh=fWkc6B9gjeJD02wJuFViXK4gHJW2DQfCy+CxBjZS6JM=;
        h=Date:To:From:Subject:From;
        b=SSJ7UrD9f+DBe9u3KTZl1UUJwWE7iqYZuD0iUWnMkwdthHVZojdut04HIsbqjvRzV
         W3PVNigdKWy2UcQLqOUqkBsUismiXKgIQdlBPHUlyODm9W1c2IQ95Z9SW4OtOSmMnW
         HkLE67oMsO2EyJHKqakr3Z0DsBjbtr0rhcbRDOV8=
Date:   Thu, 05 Jan 2023 16:42:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, jhladky@redhat.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch added to mm-unstable branch
Message-Id: <20230106004201.D3565C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()
Date: Thu, 5 Jan 2023 16:05:34 +0000

Preallocations are common in the VMA code to avoid allocating under
certain locking conditions.  The preallocations must also cover the
worst-case scenario.  Removing the GFP_ZERO flag from the
kmem_cache_alloc() (and bulk variant) calls will reduce the amount of time
spent zeroing memory that may not be used.  Only zero out the necessary
area to keep track of the allocations in the maple state.  Zero the entire
node prior to using it in the tree.

This required internal changes to node counting on allocation, so the test
code is also updated.

This restores some micro-benchmark performance: up to +9% in mmtests mmap1
by my testing +10% to +20% in mmap, mmapaddr, mmapmany tests reported by
Red Hat

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2149636
Link: https://lkml.kernel.org/r/20230105160427.2988454-1-Liam.Howlett@oracle.com
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c                 |   80 +++++++++++++++--------------
 tools/testing/radix-tree/maple.c |   18 +++---
 2 files changed, 52 insertions(+), 46 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk
+++ a/lib/maple_tree.c
@@ -149,13 +149,12 @@ struct maple_subtree_state {
 /* Functions */
 static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 {
-	return kmem_cache_alloc(maple_node_cache, gfp | __GFP_ZERO);
+	return kmem_cache_alloc(maple_node_cache, gfp);
 }
 
 static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 {
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp | __GFP_ZERO, size,
-				     nodes);
+	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
@@ -1125,9 +1124,10 @@ static inline struct maple_node *mas_pop
 {
 	struct maple_alloc *ret, *node = mas->alloc;
 	unsigned long total = mas_allocated(mas);
+	unsigned int req = mas_alloc_req(mas);
 
 	/* nothing or a request pending. */
-	if (unlikely(!total))
+	if (WARN_ON(!total))
 		return NULL;
 
 	if (total == 1) {
@@ -1137,27 +1137,25 @@ static inline struct maple_node *mas_pop
 		goto single_node;
 	}
 
-	if (!node->node_count) {
+	if (node->node_count == 1) {
 		/* Single allocation in this node. */
 		mas->alloc = node->slot[0];
-		node->slot[0] = NULL;
 		mas->alloc->total = node->total - 1;
 		ret = node;
 		goto new_head;
 	}
-
 	node->total--;
-	ret = node->slot[node->node_count];
-	node->slot[node->node_count--] = NULL;
+	ret = node->slot[--node->node_count];
+	node->slot[node->node_count] = NULL;
 
 single_node:
 new_head:
-	ret->total = 0;
-	ret->node_count = 0;
-	if (ret->request_count) {
-		mas_set_alloc_req(mas, ret->request_count + 1);
-		ret->request_count = 0;
+	if (req) {
+		req++;
+		mas_set_alloc_req(mas, req);
 	}
+
+	memset(ret, 0, sizeof(*ret));
 	return (struct maple_node *)ret;
 }
 
@@ -1176,21 +1174,20 @@ static inline void mas_push_node(struct
 	unsigned long count;
 	unsigned int requested = mas_alloc_req(mas);
 
-	memset(reuse, 0, sizeof(*reuse));
 	count = mas_allocated(mas);
 
-	if (count && (head->node_count < MAPLE_ALLOC_SLOTS - 1)) {
-		if (head->slot[0])
-			head->node_count++;
-		head->slot[head->node_count] = reuse;
+	reuse->request_count = 0;
+	reuse->node_count = 0;
+	if (count && (head->node_count < MAPLE_ALLOC_SLOTS)) {
+		head->slot[head->node_count++] = reuse;
 		head->total++;
 		goto done;
 	}
 
 	reuse->total = 1;
 	if ((head) && !((unsigned long)head & 0x1)) {
-		head->request_count = 0;
 		reuse->slot[0] = head;
+		reuse->node_count = 1;
 		reuse->total += head->total;
 	}
 
@@ -1209,7 +1206,6 @@ static inline void mas_alloc_nodes(struc
 {
 	struct maple_alloc *node;
 	unsigned long allocated = mas_allocated(mas);
-	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
 	unsigned int count;
 	void **slots = NULL;
@@ -1225,24 +1221,29 @@ static inline void mas_alloc_nodes(struc
 		WARN_ON(!allocated);
 	}
 
-	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS - 1) {
+	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS) {
 		node = (struct maple_alloc *)mt_alloc_one(gfp);
 		if (!node)
 			goto nomem_one;
 
-		if (allocated)
+		if (allocated) {
 			node->slot[0] = mas->alloc;
+			node->node_count = 1;
+		} else {
+			node->node_count = 0;
+		}
 
-		success++;
 		mas->alloc = node;
+		node->total = ++allocated;
 		requested--;
 	}
 
 	node = mas->alloc;
+	node->request_count = 0;
 	while (requested) {
 		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->slot[0]) {
-			unsigned int offset = node->node_count + 1;
+		if (node->node_count) {
+			unsigned int offset = node->node_count;
 
 			slots = (void **)&node->slot[offset];
 			max_req -= offset;
@@ -1256,15 +1257,13 @@ static inline void mas_alloc_nodes(struc
 			goto nomem_bulk;
 
 		node->node_count += count;
-		/* zero indexed. */
-		if (slots == (void **)&node->slot)
-			node->node_count--;
-
-		success += count;
+		allocated += count;
 		node = node->slot[0];
+		node->node_count = 0;
+		node->request_count = 0;
 		requested -= count;
 	}
-	mas->alloc->total = success;
+	mas->alloc->total = allocated;
 	return;
 
 nomem_bulk:
@@ -1273,7 +1272,7 @@ nomem_bulk:
 nomem_one:
 	mas_set_alloc_req(mas, requested);
 	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
-		mas->alloc->total = success;
+		mas->alloc->total = allocated;
 	mas_set_err(mas, -ENOMEM);
 }
 
@@ -5744,6 +5743,7 @@ int mas_preallocate(struct ma_state *mas
 void mas_destroy(struct ma_state *mas)
 {
 	struct maple_alloc *node;
+	unsigned long total;
 
 	/*
 	 * When using mas_for_each() to insert an expected number of elements,
@@ -5766,14 +5766,20 @@ void mas_destroy(struct ma_state *mas)
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
 
-	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
+	total = mas_allocated(mas);
+	while (total) {
 		node = mas->alloc;
 		mas->alloc = node->slot[0];
-		if (node->node_count > 0)
-			mt_free_bulk(node->node_count,
-				     (void __rcu **)&node->slot[1]);
+		if (node->node_count > 1) {
+			size_t count = node->node_count - 1;
+
+			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
+			total -= count;
+		}
 		kmem_cache_free(maple_node_cache, node);
+		total--;
 	}
+
 	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
--- a/tools/testing/radix-tree/maple.c~maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk
+++ a/tools/testing/radix-tree/maple.c
@@ -173,11 +173,11 @@ static noinline void check_new_node(stru
 
 		if (!MAPLE_32BIT) {
 			if (i >= 35)
-				e = i - 35;
+				e = i - 34;
 			else if (i >= 5)
-				e = i - 5;
+				e = i - 4;
 			else if (i >= 2)
-				e = i - 2;
+				e = i - 1;
 		} else {
 			if (i >= 4)
 				e = i - 4;
@@ -305,17 +305,17 @@ static noinline void check_new_node(stru
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	mn = mas_pop_node(&mas); /* get the next node. */
 	MT_BUG_ON(mt, mn == NULL);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 2);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
 
 	mas_push_node(&mas, mn);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	/* Check the limit of pop/push/pop */
 	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 2); /* Request */
@@ -323,14 +323,14 @@ static noinline void check_new_node(stru
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_alloc_req(&mas));
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS);
 	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

