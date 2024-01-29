Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495305381A
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 06:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509307; cv=none; b=GZH8/rXaBn/B0QMZkBkYRQiz1XwXrALVN8BqwRue7W0yK6U2mg9w4Y0taKQlPcRs9nV7YhMuyd3DTie6+3OFGEgACCyevAEY6rs82zRbyNzK/tGDn/HqkkDQRqhv6hLSe3sDzuxmvUUTMBmlMONNNN6WrL9tnSwIdGa2G8EJfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509307; c=relaxed/simple;
	bh=qLizUsTgctnvboNzF8SrIUJKp6lawnj9P7STk0TPj4M=;
	h=Date:To:From:Subject:Message-Id; b=l96NkUTlonD4rCGMRnZIna5+TDaRHB4+0ck/OK4aq6m7d9lkA3dgk8A20Z/e3JoapextxmnsQiqCUwTUneS4qSPMyCro4HOarIWfBWPWp13HIExM16FrdFjCpVVry4EoylLwdoqDHUUYTSVmKkmJ26eLc3ilvsE+9h3THb8YUH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ACvd97RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ACvd97RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD46C433C7;
	Mon, 29 Jan 2024 06:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706509306;
	bh=qLizUsTgctnvboNzF8SrIUJKp6lawnj9P7STk0TPj4M=;
	h=Date:To:From:Subject:From;
	b=ACvd97RL0pj83O/XhVXrOStulXOMG0oPxhm4mvAM4EhYAFjlUyS1uF/gG6JUuBUmB
	 H9ZstDmh6WH7JvKOsl9Gd1le/vY0JxT/3zjWaH1xsotMIkGmz2isX5jq9WqLVw8YGW
	 ca12Wj4VVS3HE9Ba01KZF6yGS97NGsmZezbjWtXU=
Date: Sun, 28 Jan 2024 22:21:43 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-remove-list_lru_putback.patch added to mm-unstable branch
Message-Id: <20240129062146.5BD46C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: remove list_lru_putback()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-remove-list_lru_putback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-remove-list_lru_putback.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/list_lru: remove list_lru_putback()
Date: Sun, 28 Jan 2024 13:28:51 +0000

Since the only user zswap_lru_putback() has gone, remove
list_lru_putback() too.

Link: https://lkml.kernel.org/r/20240126-zswap-writeback-race-v2-3-b10479847099@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chriscli@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   16 ----------------
 mm/list_lru.c            |   14 --------------
 mm/zswap.c               |    2 +-
 3 files changed, 1 insertion(+), 31 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-remove-list_lru_putback
+++ a/include/linux/list_lru.h
@@ -168,22 +168,6 @@ static inline unsigned long list_lru_cou
 void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
 void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
 			   struct list_head *head);
-/**
- * list_lru_putback: undo list_lru_isolate
- * @lru: the lru pointer.
- * @item: the item to put back.
- * @nid: the node id of the sublist to put the item back to.
- * @memcg: the cgroup of the sublist to put the item back to.
- *
- * Put back an isolated item into its original LRU. Note that unlike
- * list_lru_add, this does not increment the node LRU count (as
- * list_lru_isolate does not originally decrement this count).
- *
- * Since we might have dropped the LRU lock in between, recompute list_lru_one
- * from the node's id and memcg.
- */
-void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
-		      struct mem_cgroup *memcg);
 
 typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
 		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
--- a/mm/list_lru.c~mm-list_lru-remove-list_lru_putback
+++ a/mm/list_lru.c
@@ -162,20 +162,6 @@ void list_lru_isolate_move(struct list_l
 }
 EXPORT_SYMBOL_GPL(list_lru_isolate_move);
 
-void list_lru_putback(struct list_lru *lru, struct list_head *item, int nid,
-		      struct mem_cgroup *memcg)
-{
-	struct list_lru_one *list =
-		list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-
-	if (list_empty(item)) {
-		list_add_tail(item, &list->list);
-		if (!list->nr_items++)
-			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
-	}
-}
-EXPORT_SYMBOL_GPL(list_lru_putback);
-
 unsigned long list_lru_count_one(struct list_lru *lru,
 				 int nid, struct mem_cgroup *memcg)
 {
--- a/mm/zswap.c~mm-list_lru-remove-list_lru_putback
+++ a/mm/zswap.c
@@ -411,7 +411,7 @@ static void zswap_lru_add(struct list_lr
 	 * 2. list_lru_add() is called after memcg->kmemcg_id is updated. The
 	 *    new entry will be added directly to memcg's parent's list_lru.
 	 *
-	 * Similar reasoning holds for list_lru_del() and list_lru_putback().
+	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch

