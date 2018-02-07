From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-count-list_lru_one-nr_items-lockless-v2.patch removed from -mm tree
Date: Wed, 07 Feb 2018 14:51:50 -0800
Message-ID: <5a7b8306.OcRTlwO2ToqnwlQf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGWvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, aryabinin@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-count-list_lru_one-nr_items-lockless-v2
has been removed from the -mm tree.  Its filename was
     mm-make-count-list_lru_one-nr_items-lockless-v2.patch

This patch was dropped because it was folded into mm-make-count-list_lru_one-nr_items-lockless.patch

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: mm-make-count-list_lru_one-nr_items-lockless-v2

v2: Rebase on kvmalloc() and kvfree().  Name of kvfree_rcu() was chosen to
help not to skip this place, when someone will implement such the global
interface.

Link: http://lkml.kernel.org/r/151203869520.3915.2587549826865799173.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/list_lru.c~mm-make-count-list_lru_one-nr_items-lockless-v2 mm/list_lru.c
--- a/mm/list_lru.c~mm-make-count-list_lru_one-nr_items-lockless-v2
+++ a/mm/list_lru.c
@@ -336,7 +336,7 @@ static int memcg_init_list_lru_node(stru
 	int size = memcg_nr_cache_ids;
 
 	memcg_lrus = kvmalloc(sizeof(*memcg_lrus) +
-			     size * sizeof(void *), GFP_KERNEL);
+			      size * sizeof(void *), GFP_KERNEL);
 	if (!memcg_lrus)
 		return -ENOMEM;
 
@@ -354,13 +354,21 @@ static void memcg_destroy_list_lru_node(
 	struct list_lru_memcg *memcg_lrus;
 	/*
 	 * This is called when shrinker has already been unregistered,
-	 * and nobody can use it. So, there is no need to use kfree_rcu().
+	 * and nobody can use it. So, there is no need to use kvfree_rcu().
 	 */
 	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus, true);
 	__memcg_destroy_list_lru_node(memcg_lrus, 0, memcg_nr_cache_ids);
 	kvfree(memcg_lrus);
 }
 
+static void kvfree_rcu(struct rcu_head *head)
+{
+	struct list_lru_memcg *mlru;
+
+	mlru = container_of(head, struct list_lru_memcg, rcu);
+	kvfree(mlru);
+}
+
 static int memcg_update_list_lru_node(struct list_lru_node *nlru,
 				      int old_size, int new_size)
 {
@@ -392,7 +400,7 @@ static int memcg_update_list_lru_node(st
 	rcu_assign_pointer(nlru->memcg_lrus, new);
 	spin_unlock_irq(&nlru->lock);
 
-	kfree_rcu(old, rcu);
+	call_rcu(&old->rcu, kvfree_rcu);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are

mm-make-count-list_lru_one-nr_items-lockless.patch

