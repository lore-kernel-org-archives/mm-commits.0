From: akpm@linux-foundation.org
Subject: - memcg-when-do_swaps-do_wp_page-fails.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:14 -0800
Message-ID: <200803050745.m257jECh021578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765052AbYCEHpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: when do_swap's do_wp_page fails
has been removed from the -mm tree.  Its filename was
     memcg-when-do_swaps-do_wp_page-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: when do_swap's do_wp_page fails
From: Hugh Dickins <hugh@veritas.com>

Don't uncharge when do_swap_page's call to do_wp_page fails: the page which
was charged for is there in the pagetable, and will be correctly uncharged
when that area is unmapped - it was only its COWing which failed.

And while we're here, remove earlier XXX comment: yes, OR in do_wp_page's
return value (maybe VM_FAULT_WRITE) with do_swap_page's there; but if it
fails, mask out success bits, which might confuse some arches e.g.  sparc.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~memcg-when-do_swaps-do_wp_page-fails mm/memory.c
--- a/mm/memory.c~memcg-when-do_swaps-do_wp_page-fails
+++ a/mm/memory.c
@@ -2093,12 +2093,9 @@ static int do_swap_page(struct mm_struct
 	unlock_page(page);
 
 	if (write_access) {
-		/* XXX: We could OR the do_wp_page code with this one? */
-		if (do_wp_page(mm, vma, address,
-				page_table, pmd, ptl, pte) & VM_FAULT_OOM) {
-			mem_cgroup_uncharge_page(page);
-			ret = VM_FAULT_OOM;
-		}
+		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
+		if (ret & VM_FAULT_ERROR)
+			ret &= VM_FAULT_ERROR;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

