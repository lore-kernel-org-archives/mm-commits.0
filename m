From: akpm@linux-foundation.org
Subject: [merged] tmpfs-cleanup-mpol_parse_str.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:45 -0400
Message-ID: <201003261937.o2QJbi7Z016631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab0CZTiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: cleanup mpol_parse_str()
has been removed from the -mm tree.  Its filename was
     tmpfs-cleanup-mpol_parse_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: cleanup mpol_parse_str()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

mpol_parse_str() made lots 'err' variable related bug.  Because it is ugly
and reviewing unfriendly.

This patch simplifies it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/mempolicy.c~tmpfs-cleanup-mpol_parse_str mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-cleanup-mpol_parse_str
+++ a/mm/mempolicy.c
@@ -2195,8 +2195,8 @@ int mpol_parse_str(char *str, struct mem
 			char *rest = nodelist;
 			while (isdigit(*rest))
 				rest++;
-			if (!*rest)
-				err = 0;
+			if (*rest)
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
@@ -2205,7 +2205,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -2214,7 +2213,6 @@ int mpol_parse_str(char *str, struct mem
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
-		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
@@ -2229,7 +2227,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			goto out;
-		err = 0;
 	}
 
 	mode_flags = 0;
@@ -2243,13 +2240,14 @@ int mpol_parse_str(char *str, struct mem
 		else if (!strcmp(flags, "relative"))
 			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
-			err = 1;
+			goto out;
 	}
 
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
-		err = 1;
-	else {
+		goto out;
+
+	{
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -2260,13 +2258,15 @@ int mpol_parse_str(char *str, struct mem
 			ret = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 		if (ret) {
-			err = 1;
 			mpol_put(new);
-		} else if (no_context) {
-			/* save for contextualization */
-			new->w.user_nodemask = nodes;
+			goto out;
 		}
 	}
+	err = 0;
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	}
 
 out:
 	/* Restore string for error message */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

