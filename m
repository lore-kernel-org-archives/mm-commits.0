From: akpm@linux-foundation.org
Subject: + mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch
 added to -mm tree
Date: Thu, 29 Jun 2017 15:48:50 -0700
Message-ID: <595583d2.XU067SbAxxLKiPo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdF2WtG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stummala@codeaurora.org, apolyakov@beget.ru, jack@suse.cz, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: fix list_lru_count_node() to be race free
has been added to the -mm tree.  Its filename is
     mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Jan Kara <jack@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Polakov <apolyakov@beget.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

Patches currently in -mm which might be from stummala@codeaurora.org are

mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch
mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch
fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch

