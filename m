From: akpm@linux-foundation.org
Subject: [patch 055/115] mm/list_lru.c: fix list_lru_count_node()
 to be race free
Date: Mon, 10 Jul 2017 15:49:57 -0700
Message-ID: <20170710224957.NMXq4ciNO%akpm__14861.2340250567$1499727009$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932151AbdGJWt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, apolyakov@beget.ru, jack@suse.cz, mm-commits@vger.kernel.org, stable@vger.kernel.org, stummala@codeaurora.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk

From: Sahitya Tummala <stummala@codeaurora.org>
Subject: mm/list_lru.c: fix list_lru_count_node() to be race free

list_lru_count_node() iterates over all memcgs to get the total number of
entries on the node but it can race with memcg_drain_all_list_lrus(),
which migrates the entries from a dead cgroup to another.  This can return
incorrect number of entries from list_lru_count_node().

Fix this by keeping track of entries per node and simply return it in
list_lru_count_node().

Link: http://lkml.kernel.org/r/1498707555-30525-1-git-send-email-stummala@codeaurora.org
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Polakov <apolyakov@beget.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    1 +
 mm/list_lru.c            |   14 ++++++--------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN include/linux/list_lru.h~mm-list_lruc-fix-list_lru_count_node-to-be-race-free include/linux/list_lru.h
--- a/include/linux/list_lru.h~mm-list_lruc-fix-list_lru_count_node-to-be-race-free
+++ a/include/linux/list_lru.h
@@ -44,6 +44,7 @@ struct list_lru_node {
 	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
 	struct list_lru_memcg	*memcg_lrus;
 #endif
+	long nr_items;
 } ____cacheline_aligned_in_smp;
 
 struct list_lru {
diff -puN mm/list_lru.c~mm-list_lruc-fix-list_lru_count_node-to-be-race-free mm/list_lru.c
--- a/mm/list_lru.c~mm-list_lruc-fix-list_lru_count_node-to-be-race-free
+++ a/mm/list_lru.c
@@ -117,6 +117,7 @@ bool list_lru_add(struct list_lru *lru,
 		l = list_lru_from_kmem(nlru, item);
 		list_add_tail(item, &l->list);
 		l->nr_items++;
+		nlru->nr_items++;
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -136,6 +137,7 @@ bool list_lru_del(struct list_lru *lru,
 		l = list_lru_from_kmem(nlru, item);
 		list_del_init(item);
 		l->nr_items--;
+		nlru->nr_items--;
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -183,15 +185,10 @@ EXPORT_SYMBOL_GPL(list_lru_count_one);
 
 unsigned long list_lru_count_node(struct list_lru *lru, int nid)
 {
-	long count = 0;
-	int memcg_idx;
+	struct list_lru_node *nlru;
 
-	count += __list_lru_count_one(lru, nid, -1);
-	if (list_lru_memcg_aware(lru)) {
-		for_each_memcg_cache_index(memcg_idx)
-			count += __list_lru_count_one(lru, nid, memcg_idx);
-	}
-	return count;
+	nlru = &lru->node[nid];
+	return nlru->nr_items;
 }
 EXPORT_SYMBOL_GPL(list_lru_count_node);
 
@@ -226,6 +223,7 @@ restart:
 			assert_spin_locked(&nlru->lock);
 		case LRU_REMOVED:
 			isolated++;
+			nlru->nr_items--;
 			/*
 			 * If the lru lock has been dropped, our list
 			 * traversal is now invalid and so we have to
_
