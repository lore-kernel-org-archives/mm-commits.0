From: akpm@linux-foundation.org
Subject: - fix-oom-killing-processes-wrongly-thought-mpol_bind.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:25 -0700
Message-ID: <200704252038.l3PKcPHj012220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993137AbXDYUj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, bill.irwin@oracle.com, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix OOM killing processes wrongly thought MPOL_BIND
has been removed from the -mm tree.  Its filename was
     fix-oom-killing-processes-wrongly-thought-mpol_bind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix OOM killing processes wrongly thought MPOL_BIND
From: Hugh Dickins <hugh@veritas.com>

I only have CONFIG_NUMA=y for build testing: surprised when trying a memhog
to see lots of other processes killed with "No available memory
(MPOL_BIND)".  memhog is killed correctly once we initialize nodemask in
constrained_alloc().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~fix-oom-killing-processes-wrongly-thought-mpol_bind mm/oom_kill.c
--- a/mm/oom_kill.c~fix-oom-killing-processes-wrongly-thought-mpol_bind
+++ a/mm/oom_kill.c
@@ -176,6 +176,8 @@ static inline int constrained_alloc(stru
 	struct zone **z;
 	nodemask_t nodes;
 	int node;
+
+	nodes_clear(nodes);
 	/* node has memory ? */
 	for_each_online_node(node)
 		if (NODE_DATA(node)->node_present_pages)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-drm.patch
scsi-fix-config_scsi_wait_scan=m.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
i386-make-compat_vdso-runtime-selectable-fix.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-use-ptep_test_and_clear_young.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
