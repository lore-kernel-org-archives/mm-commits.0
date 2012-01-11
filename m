From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-mpol_equal-use-bool.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:17 -0800
Message-ID: <20120111212817.986BA1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41779 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKV2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:18 -0500
Received: by yenm1 with SMTP id m1so7466yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: mpol_equal(): use bool
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-mpol_equal-use-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm/mempolicy.c: mpol_equal(): use bool

mpol_equal() logically returns a boolean.  Use a bool type to slightly
improve readability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   10 +++++-----
 mm/mempolicy.c            |   14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicyc-mpol_equal-use-bool include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicyc-mpol_equal-use-bool
+++ a/include/linux/mempolicy.h
@@ -164,11 +164,11 @@ static inline void mpol_get(struct mempo
 		atomic_inc(&pol->refcnt);
 }
 
-extern int __mpol_equal(struct mempolicy *a, struct mempolicy *b);
-static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
+extern bool __mpol_equal(struct mempolicy *a, struct mempolicy *b);
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	if (a == b)
-		return 1;
+		return true;
 	return __mpol_equal(a, b);
 }
 
@@ -257,9 +257,9 @@ static inline int vma_migratable(struct 
 
 struct mempolicy {};
 
-static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
-	return 1;
+	return true;
 }
 
 static inline void mpol_put(struct mempolicy *p)
diff -puN mm/mempolicy.c~mm-mempolicyc-mpol_equal-use-bool mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-mpol_equal-use-bool
+++ a/mm/mempolicy.c
@@ -1983,28 +1983,28 @@ struct mempolicy *__mpol_cond_copy(struc
 }
 
 /* Slow path of a mempolicy comparison */
-int __mpol_equal(struct mempolicy *a, struct mempolicy *b)
+bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	if (!a || !b)
-		return 0;
+		return false;
 	if (a->mode != b->mode)
-		return 0;
+		return false;
 	if (a->flags != b->flags)
-		return 0;
+		return false;
 	if (mpol_store_user_nodemask(a))
 		if (!nodes_equal(a->w.user_nodemask, b->w.user_nodemask))
-			return 0;
+			return false;
 
 	switch (a->mode) {
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		return nodes_equal(a->v.nodes, b->v.nodes);
+		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
 		return a->v.preferred_node == b->v.preferred_node;
 	default:
 		BUG();
-		return 0;
+		return false;
 	}
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

