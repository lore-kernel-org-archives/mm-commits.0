From: akpm@linux-foundation.org
Subject: + list_lru-per-node-list-infrastructure-fix.patch added to -mm
 tree
Date: Wed, 26 Jun 2013 13:47:48 -0700
Message-ID: <51cb5374.lniBOeFxBUrqcwZ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FZUrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 16:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: + list_lru-per-node-list-infrastructure-fix.patch added to -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 13:47:48 -0700


The patch titled
     Subject: list_lru: per-node list infrastructure fix
has been added to the -mm tree.  Its filename is
     list_lru-per-node-list-infrastructure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch
memcg-do-not-account-memory-used-for-cache-creation.patch

