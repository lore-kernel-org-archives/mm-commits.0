From: akpm@linux-foundation.org
Subject: + mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch added
 to -mm tree
Date: Tue, 25 Feb 2014 12:57:47 -0800
Message-ID: <530d03cb.Ch8Y3360jUb1t3NR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYU5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, jstancek@redhat.com, hannes@cmpxchg.org

Subject: + mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch added to -mm tree
To: hannes@cmpxchg.org,jstancek@redhat.com,riel@redhat.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:57:47 -0800


The patch titled
     Subject: mm: page_alloc: reset aging cycle with GFP_THISNODE
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: reset aging cycle with GFP_THISNODE

Jan Stancek reports manual page migration encountering allocation failures
after some pages when there is still plenty of memory free, and bisected
the problem down to 81c0a2bb515f ("mm: page_alloc: fair zone allocator
policy").

The problem is that page migration uses GFP_THISNODE and this makes the
page allocator bail out before entering the slowpath entirely, without
resetting the zone round-robin batches.  A string of such allocations will
fail long before the node's free memory is exhausted.

GFP_THISNODE is a special flag for callsites that implement their own
clever node fallback and so no direct reclaim should be invoked.  But if
the allocations fail, the fair allocation batches should still be reset,
and if the node is full, it should be aged in the background.

Make GFP_THISNODE wake up kswapd and reset the zone batches, but bail out
before entering direct reclaim to not stall the allocating task.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Jan Stancek <jstancek@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode
+++ a/mm/page_alloc.c
@@ -2495,18 +2495,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		return NULL;
 	}
 
-	/*
-	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
-	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
-	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
-	 * using a larger set of nodes after it has established that the
-	 * allowed per node queues are empty and that nodes are
-	 * over allocated.
-	 */
-	if (IS_ENABLED(CONFIG_NUMA) &&
-			(gfp_mask & GFP_THISNODE) == GFP_THISNODE)
-		goto nopage;
-
 restart:
 	prepare_slowpath(gfp_mask, order, zonelist,
 			 high_zoneidx, preferred_zone);
@@ -2551,6 +2539,18 @@ rebalance:
 		}
 	}
 
+	/*
+	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
+	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
+	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
+	 * using a larger set of nodes after it has established that the
+	 * allowed per node queues are empty and that nodes are
+	 * over allocated.
+	 */
+	if (IS_ENABLED(CONFIG_NUMA) &&
+			(gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+		goto nopage;
+
 	/* Atomic allocations - we can't balance anything */
 	if (!wait) {
 		/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
memcg-reparent-charges-of-children-before-processing-parent.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-page_alloc-reset-aging-cycle-with-gfp_thisnode.patch
mm-fix-gfp_thisnode-callers-and-clarify.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

