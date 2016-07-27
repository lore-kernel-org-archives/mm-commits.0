From: akpm@linux-foundation.org
Subject: [merged]
 slab-make-gfp_slab_bug_mask-information-more-human-readable.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 11:59:22 -0700
Message-ID: <5799048a.JStdZX4pQewz+gKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbcG0S7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: make GFP_SLAB_BUG_MASK information more human readable
has been removed from the -mm tree.  Its filename was
     slab-make-gfp_slab_bug_mask-information-more-human-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: slab: make GFP_SLAB_BUG_MASK information more human readable

printk offers %pGg for quite some time so let's use it to get a human
readable list of invalid flags.

The original output would be
[  429.191962] gfp: 2

after the change
[  429.191962] Unexpected gfp: 0x2 (__GFP_HIGHMEM)

Link: http://lkml.kernel.org/r/1465548200-11384-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slub.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slab.c
--- a/mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slab.c
@@ -2686,7 +2686,8 @@ static struct page *cache_grow_begin(str
 	 * critical path in kmem_cache_alloc().
 	 */
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
diff -puN mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slub.c
--- a/mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slub.c
@@ -1612,7 +1612,8 @@ out:
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
mm-oom-fortify-task_will_free_mem-fix.patch
freezer-oom-check-tif_memdie-on-the-correct-task.patch
cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

