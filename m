Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC32CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 20:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjJRUJl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjJRUJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 16:09:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3628A4
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 13:09:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8B4C433C9;
        Wed, 18 Oct 2023 20:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697659778;
        bh=rbP/uzFqrJs7XcKmmozNSpbGKZGJRKWZK2KOZw0ZUOk=;
        h=Date:To:From:Subject:From;
        b=GR5VM/oGsyzRSSm9qOmIoxk45Lo8qo946S1aDGv+0LiAhz7MGgPtntJvDxH62ZQpt
         XnQwzs9gwuayp/AnKLfUjdlYqZg2aK7tzi5UX7qKk0/SCox8tR9fxdLlOvDd4R2GYh
         yKiUIaqFFM5e/vWjDtqqqKojjL1dCMT3c2N7Ps+Q=
Date:   Wed, 18 Oct 2023 13:09:37 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, shuah@kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch added to mm-unstable branch
Message-Id: <20231018200938.4B8B4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: allow external numa node and cgroup tracking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm: list_lru: allow external numa node and cgroup tracking
Date: Tue, 17 Oct 2023 16:21:48 -0700

Patch series "workload-specific and memory pressure-driven zswap
writeback", v3.

This patch series solves these issues by separating the global zswap LRU
into per-memcg and per-NUMA LRUs, and performs workload-specific (i.e
memcg- and NUMA-aware) zswap writeback under memory pressure.  The new
shrinker does not have any parameter that must be tuned by the user, and
can be opted in or out on a per-memcg basis.

As a proof of concept, we ran the following synthetic benchmark: build the
linux kernel in a memory-limited cgroup, and allocate some cold data in
tmpfs to see if the shrinker could write them out and improved the overall
performance.  Depending on the amount of cold data generated, we observe
from 14% to 35% reduction in kernel CPU time used in the kernel builds.


This patch (of 5):

The interface of list_lru is based on the assumption that objects are
allocated on the correct node/memcg, with this change it is introduced the
possibility to explicitly specify numa node and memcgroup when adding and
removing objects.  This is so that users of list_lru can track node/memcg
of the items outside of the list_lru, like in zswap, where the allocations
can be made by kswapd for data that's charged to a different cgroup.

Link: https://lkml.kernel.org/r/20231017232152.2605440-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20231017232152.2605440-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   38 ++++++++++++++++++++++++++++++++
 mm/list_lru.c            |   43 ++++++++++++++++++++++++++++++++-----
 2 files changed, 76 insertions(+), 5 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-allow-external-numa-node-and-cgroup-tracking
+++ a/include/linux/list_lru.h
@@ -90,6 +90,24 @@ void memcg_reparent_list_lrus(struct mem
 bool list_lru_add(struct list_lru *lru, struct list_head *item);
 
 /**
+ * __list_lru_add: add an element to a specific sublist.
+ * @list_lru: the lru pointer
+ * @item: the item to be added.
+ * @memcg: the cgroup of the sublist to add the item to.
+ * @nid: the node id of the sublist to add the item to.
+ *
+ * This function is similar to list_lru_add(), but it allows the caller to
+ * specify the sublist to which the item should be added. This can be useful
+ * when the list_head node is not necessarily in the same cgroup and NUMA node
+ * as the data it represents, such as zswap, where the list_head node could be
+ * from kswapd and the data from a different cgroup altogether.
+ *
+ * Return value: true if the list was updated, false otherwise
+ */
+bool __list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
+		    struct mem_cgroup *memcg);
+
+/**
  * list_lru_del: delete an element to the lru list
  * @list_lru: the lru pointer
  * @item: the item to be deleted.
@@ -103,6 +121,18 @@ bool list_lru_add(struct list_lru *lru,
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
 /**
+ * __list_lru_del: delete an element from a specific sublist.
+ * @list_lru: the lru pointer
+ * @item: the item to be deleted.
+ * @memcg: the cgroup of the sublist to delete the item from.
+ * @nid: the node id of the sublist to delete the item from.
+ *
+ * Return value: true if the list was updated, false otherwise.
+ */
+bool __list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
+		    struct mem_cgroup *memcg);
+
+/**
  * list_lru_count_one: return the number of objects currently held by @lru
  * @lru: the lru pointer.
  * @nid: the node id to count from.
@@ -136,6 +166,14 @@ static inline unsigned long list_lru_cou
 void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
 void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
 			   struct list_head *head);
+/*
+ * list_lru_putback: undo list_lru_isolate.
+ *
+ * Since we might have dropped the LRU lock in between, recompute list_lru_one
+ * from the node's id and memcg.
+ */
+void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg);
 
 typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
 		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
--- a/mm/list_lru.c~mm-list_lru-allow-external-numa-node-and-cgroup-tracking
+++ a/mm/list_lru.c
@@ -119,13 +119,22 @@ list_lru_from_kmem(struct list_lru *lru,
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
 	int nid = page_to_nid(virt_to_page(item));
+	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
+		mem_cgroup_from_slab_obj(item) : NULL;
+
+	return __list_lru_add(lru, item, nid, memcg);
+}
+EXPORT_SYMBOL_GPL(list_lru_add);
+
+bool __list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
+		    struct mem_cgroup *memcg)
+{
 	struct list_lru_node *nlru = &lru->node[nid];
-	struct mem_cgroup *memcg;
 	struct list_lru_one *l;
 
 	spin_lock(&nlru->lock);
 	if (list_empty(item)) {
-		l = list_lru_from_kmem(lru, nid, item, &memcg);
+		l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
 		if (!l->nr_items++)
@@ -138,17 +147,27 @@ bool list_lru_add(struct list_lru *lru,
 	spin_unlock(&nlru->lock);
 	return false;
 }
-EXPORT_SYMBOL_GPL(list_lru_add);
+EXPORT_SYMBOL_GPL(__list_lru_add);
 
 bool list_lru_del(struct list_lru *lru, struct list_head *item)
 {
 	int nid = page_to_nid(virt_to_page(item));
+	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
+		mem_cgroup_from_slab_obj(item) : NULL;
+
+	return __list_lru_del(lru, item, nid, memcg);
+}
+EXPORT_SYMBOL_GPL(list_lru_del);
+
+bool __list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
+		    struct mem_cgroup *memcg)
+{
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
-		l = list_lru_from_kmem(lru, nid, item, NULL);
+		l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
 		list_del_init(item);
 		l->nr_items--;
 		nlru->nr_items--;
@@ -158,7 +177,7 @@ bool list_lru_del(struct list_lru *lru,
 	spin_unlock(&nlru->lock);
 	return false;
 }
-EXPORT_SYMBOL_GPL(list_lru_del);
+EXPORT_SYMBOL_GPL(__list_lru_del);
 
 void list_lru_isolate(struct list_lru_one *list, struct list_head *item)
 {
@@ -175,6 +194,20 @@ void list_lru_isolate_move(struct list_l
 }
 EXPORT_SYMBOL_GPL(list_lru_isolate_move);
 
+void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg)
+{
+	struct list_lru_one *list =
+		list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+
+	if (list_empty(item)) {
+		list_add_tail(item, &list->list);
+		if (!list->nr_items++)
+			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
+	}
+}
+EXPORT_SYMBOL_GPL(list_lru_putback);
+
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-list_lru-allow-external-numa-node-and-cgroup-tracking.patch
zswap-shrinks-zswap-pool-based-on-memory-pressure.patch
memcontrol-add-helpers-for-hugetlb-memcg-accounting.patch
memcontrol-only-transfer-the-memcg-data-for-migration.patch
hugetlb-memcg-account-hugetlb-backed-memory-in-memory-controller.patch
selftests-add-a-selftest-to-verify-hugetlb-usage-in-memcg.patch

