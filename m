From: akpm@linux-foundation.org
Subject: [folded-merged]
 list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 15:29:35 -0700
Message-ID: <522f9d4f.qQimbfTtgo1k7KOv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3IJW3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:29:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@gmail.com, dchinner@redhat.com

Subject: [folded-merged] list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch removed from -mm tree
To: dchinner@redhat.com,glommer@gmail.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:29:35 -0700


The patch titled
     Subject: list_lru: fix broken LRU_RETRY behaviour
has been removed from the -mm tree.  Its filename was
     list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch

This patch was dropped because it was folded into list_lru-per-node-list-infrastructure.patch

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: list_lru: fix broken LRU_RETRY behaviour

The LRU_RETRY code assumes that the list traversal status after we have
dropped and regained the list lock.  Unfortunately, this is not a valid
assumption, and that can lead to racing traversals isolating objects that
the other traversal expects to be the next item on the list.

This is causing problems with the inode cache shrinker isolation, with
races resulting in an inode on a dispose list being "isolated" because a
racing traversal still thinks it is on the LRU.  The inode is then never
reclaimed and that causes hangs if a subsequent lookup on that inode
occurs.

Fix it by always restarting the list walk on a LRU_RETRY return from the
isolate callback.  Avoid the possibility of livelocks the current code was
trying to aavoid by always decrementing the nr_to_walk counter on retries
so that even if we keep hitting the same item on the list we'll eventually
stop trying to walk and exit out of the situation causing the problem.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN mm/list_lru.c~list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour mm/list_lru.c
--- a/mm/list_lru.c~list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour
+++ a/mm/list_lru.c
@@ -73,19 +73,19 @@ list_lru_walk_node(struct list_lru *lru,
 	struct list_lru_node	*nlru = &lru->node[nid];
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
-	/*
-	 * If we don't keep state of at which pass we are, we can loop at
-	 * LRU_RETRY, since we have no guarantees that the caller will be able
-	 * to do something other than retry on the next pass. We handle this by
-	 * allowing at most one retry per object. This should not be altered
-	 * by any condition other than LRU_RETRY.
-	 */
-	bool first_pass = true;
 
 	spin_lock(&nlru->lock);
 restart:
 	list_for_each_safe(item, n, &nlru->list) {
 		enum lru_status ret;
+
+		/*
+		 * decrement nr_to_walk first so that we don't livelock if we
+		 * get stuck on large numbesr of LRU_RETRY items
+		 */
+		if (--(*nr_to_walk) == 0)
+			break;
+
 		ret = isolate(item, &nlru->lock, cb_arg);
 		switch (ret) {
 		case LRU_REMOVED:
@@ -100,19 +100,14 @@ restart:
 		case LRU_SKIP:
 			break;
 		case LRU_RETRY:
-			if (!first_pass) {
-				first_pass = true;
-				break;
-			}
-			first_pass = false;
+			/*
+			 * The lru lock has been dropped, our list traversal is
+			 * now invalid and so we have to restart from scratch.
+			 */
 			goto restart;
 		default:
 			BUG();
 		}
-
-		if ((*nr_to_walk)-- == 0)
-			break;
-
 	}
 
 	spin_unlock(&nlru->lock);
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

