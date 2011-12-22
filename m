From: akpm@linux-foundation.org
Subject: + radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch added to -mm tree
Date: Wed, 21 Dec 2011 16:09:36 -0800
Message-ID: <20111222000936.A1F05100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:55689 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1LVAJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 19:09:37 -0500
Received: by ggnv2 with SMTP id v2so1007700ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 16:09:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, david@fromorbit.com, jack@suse.cz, mgorman@suse.de, nai.xia@gmail.com


The patch titled
     Subject: radix_tree: expand comment on optimization
has been added to the -mm tree.  Its filename is
     radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: radix_tree: expand comment on optimization

Patches currently in -mm which might be from hughd@google.com are

origin.patch
vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch
linux-next.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-simplify-find_vma_prev.patch
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
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch
prio_tree-debugging-patch.patch

