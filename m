From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-mpol_equal-use-bool.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:41:34 -0800
Message-ID: <20111220234135.001C85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46968 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1LTXlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:41:36 -0500
Received: by eekc1 with SMTP id c1so222093eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:41:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, wilsons@start.ca


The patch titled
     Subject: mm/mempolicy.c: mpol_equal(): use bool
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-mpol_equal-use-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm/mempolicy.c: mpol_equal(): use bool

mpol_equal() logically returns a boolean.  Use a bool type to slightly
improve readability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>
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
Subject: Subject: mm/mempolicy.c: mpol_equal(): use bool

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mempolicy-refix-mbind_range-vma-issue.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-simplify-find_vma_prev.patch
mm-simplify-find_vma_prev-fix.patch
mm-simplify-find_vma_prev-fix-2.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch
mm-mempolicyc-mpol_equal-use-bool.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
kexec-remove-kmsg_dump_kexec.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

