From: akpm@linux-foundation.org
Subject: [folded-merged] list_lru-per-node-list-infrastructure-fix.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 15:29:33 -0700
Message-ID: <522f9d4d.zZplg0VVsL6x4ceH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3IJW3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: [folded-merged] list_lru-per-node-list-infrastructure-fix.patch removed from -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:29:33 -0700


The patch titled
     Subject: list_lru: per-node list infrastructure fix
has been removed from the -mm tree.  Its filename was
     list_lru-per-node-list-infrastructure-fix.patch

This patch was dropped because it was folded into list_lru-per-node-list-infrastructure.patch

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: list_lru: per-node list infrastructure fix

After a while investigating, it seems to us that the imbalance we are
seeing are due to a multi-node race already in tree (our guess).  Although
the WARN is useful to show us the race, BUG_ON is too much, since it seems
the kernel should be fine going on after that.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/list_lru.c~list_lru-per-node-list-infrastructure-fix mm/list_lru.c
--- a/mm/list_lru.c~list_lru-per-node-list-infrastructure-fix
+++ a/mm/list_lru.c
@@ -15,7 +15,7 @@ bool list_lru_add(struct list_lru *lru,
 	struct list_lru_node *nlru = &lru->node[nid];
 
 	spin_lock(&nlru->lock);
-	BUG_ON(nlru->nr_items < 0);
+	WARN_ON_ONCE(nlru->nr_items < 0);
 	if (list_empty(item)) {
 		list_add_tail(item, &nlru->list);
 		if (nlru->nr_items++ == 0)
@@ -38,7 +38,7 @@ bool list_lru_del(struct list_lru *lru,
 		list_del_init(item);
 		if (--nlru->nr_items == 0)
 			node_clear(nid, lru->active_nodes);
-		BUG_ON(nlru->nr_items < 0);
+		WARN_ON_ONCE(nlru->nr_items < 0);
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -56,7 +56,7 @@ unsigned long list_lru_count(struct list
 		struct list_lru_node *nlru = &lru->node[nid];
 
 		spin_lock(&nlru->lock);
-		BUG_ON(nlru->nr_items < 0);
+		WARN_ON_ONCE(nlru->nr_items < 0);
 		count += nlru->nr_items;
 		spin_unlock(&nlru->lock);
 	}
@@ -91,7 +91,7 @@ restart:
 		case LRU_REMOVED:
 			if (--nlru->nr_items == 0)
 				node_clear(nid, lru->active_nodes);
-			BUG_ON(nlru->nr_items < 0);
+			WARN_ON_ONCE(nlru->nr_items < 0);
 			isolated++;
 			break;
 		case LRU_ROTATE:
_

Patches currently in -mm which might be from glommer@gmail.com are

origin.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

