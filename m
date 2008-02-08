From: akpm@linux-foundation.org
Subject: - memcgroup-revert-swap_state-mods.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:00 -0800
Message-ID: <200802080803.m1883fx0014140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbYBHJbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 04:31:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@googl


The patch titled
     memcgroup: revert swap_state mods
has been removed from the -mm tree.  Its filename was
     memcgroup-revert-swap_state-mods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: revert swap_state mods
From: Hugh Dickins <hugh@veritas.com>

If we're charging rss and we're charging cache, it seems obvious that we
should be charging swapcache - as has been done.  But in practice that
doesn't work out so well: both swapin readahead and swapoff leave the
majority of pages charged to the wrong cgroup (the cgroup that happened to
read them in, rather than the cgroup to which they belong).

(Which is why unuse_pte's GFP_KERNEL while holding pte lock never showed up
as a problem: no allocation was ever done there, every page read being
already charged to the cgroup which initiated the swapoff.)

It all works rather better if we leave the charging to do_swap_page and
unuse_pte, and do nothing for swapcache itself: revert mm/swap_state.c to
what it was before the memory-controller patches.  This also speeds up
significantly a contained process working at its limit: because it no
longer needs to keep waiting for swap writeback to complete.

Is it unfair that swap pages become uncharged once they're unmapped, even
though they're still clearly private to particular cgroups?  For a short
while, yes; but PageReclaim arranges for those pages to go to the end of
the inactive list and be reclaimed soon if necessary.

shmem/tmpfs pages are a distinct case: their charging also benefits from
this change, but their second life on the lists as swapcache pages may
prove more unfair - that I need to check next.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN mm/swap_state.c~memcgroup-revert-swap_state-mods mm/swap_state.c
--- a/mm/swap_state.c~memcgroup-revert-swap_state-mods
+++ a/mm/swap_state.c
@@ -17,7 +17,6 @@
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
-#include <linux/memcontrol.h>
 
 #include <asm/pgtable.h>
 
@@ -75,11 +74,6 @@ int add_to_swap_cache(struct page *page,
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
-
-	error = mem_cgroup_cache_charge(page, current->mm, gfp_mask);
-	if (error)
-		goto out;
-
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 		write_lock_irq(&swapper_space.tree_lock);
@@ -92,14 +86,10 @@ int add_to_swap_cache(struct page *page,
 			total_swapcache_pages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 			INC_CACHE_INFO(add_total);
-		} else {
-			mem_cgroup_uncharge_page(page);
 		}
 		write_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
-	} else
-		mem_cgroup_uncharge_page(page);
-out:
+	}
 	return error;
 }
 
@@ -114,7 +104,6 @@ void __delete_from_swap_cache(struct pag
 	BUG_ON(PageWriteback(page));
 	BUG_ON(PagePrivate(page));
 
-	mem_cgroup_uncharge_page(page);
 	radix_tree_delete(&swapper_space.page_tree, page_private(page));
 	set_page_private(page, 0);
 	ClearPageSwapCache(page);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
prio_tree-debugging-patch.patch
