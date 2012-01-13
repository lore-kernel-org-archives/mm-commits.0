From: akpm@linux-foundation.org
Subject: [folded] radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:59:29 -0800
Message-ID: <20120113005930.153D1100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57904 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab2AMA7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:59:31 -0500
Received: by yhjj52 with SMTP id j52so8571yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:59:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, david@fromorbit.com, jack@suse.cz, mgorman@suse.de, nai.xia@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: expand comment on optimization
has been removed from the -mm tree.  Its filename was
     radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

This patch was dropped because it was folded into radix_tree-take-radix_tree_path-off-stack.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: radix_tree: expand comment on optimization

Expand comment on optimization in radix_tree_range_tag_if_tagged(),
along the lines proposed by Dave Chinner.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nai Xia <nai.xia@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization lib/radix-tree.c
--- a/lib/radix-tree.c~radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization
+++ a/lib/radix-tree.c
@@ -703,7 +703,13 @@ unsigned long radix_tree_range_tag_if_ta
 			node = node->parent;
 		}
 
-		/* optimization: no need to walk up from this node again */
+		/*
+		 * Small optimization: now clear that node pointer.
+		 * Since all of this slot's ancestors now have the tag set
+		 * from setting it above, we have no further need to walk
+		 * back up the tree setting tags, until we update slot to
+		 * point to another radix_tree_node.
+		 */
 		node = NULL;
 
 next:
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
mm-rearrange-putback_inactive_pages.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch

