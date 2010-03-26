From: akpm@linux-foundation.org
Subject: [merged] tmpfs-handle-mpol_local-mount-option-properly.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:42 -0400
Message-ID: <201003261937.o2QJbfXE016628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab0CZTiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: handle MPOL_LOCAL mount option properly
has been removed from the -mm tree.  Its filename was
     tmpfs-handle-mpol_local-mount-option-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: handle MPOL_LOCAL mount option properly
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) added mpol=local mount option.  but its feature is broken
since it was born.  because such code always return 1 (i.e.  mount
failure).

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mempolicy.c~tmpfs-handle-mpol_local-mount-option-properly mm/mempolicy.c
--- a/mm/mempolicy.c~tmpfs-handle-mpol_local-mount-option-properly
+++ a/mm/mempolicy.c
@@ -2214,6 +2214,7 @@ int mpol_parse_str(char *str, struct mem
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
+		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
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

