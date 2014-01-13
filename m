From: akpm@linux-foundation.org
Subject: + mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
 added to -mm tree
Date: Mon, 13 Jan 2014 15:15:26 -0800
Message-ID: <52d4738e.s01jE2Dy+ge4yZJd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaAMXP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 18:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: + mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch added to -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 15:15:26 -0800


The patch titled
     Subject: mm: vmscan: shrink all slab objects if tight on memory
has been added to the -mm tree.  Its filename is
     mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: shrink all slab objects if tight on memory

When reclaiming kmem, we currently don't scan slabs that have less than
batch_size objects (see shrink_slab_node()):

        while (total_scan >= batch_size) {
                shrinkctl->nr_to_scan = batch_size;
                shrinker->scan_objects(shrinker, shrinkctl);
                total_scan -= batch_size;
        }

If there are only a few shrinkers available, such a behavior won't cause
any problems, because the batch_size is usually small, but if we have a
lot of slab shrinkers, which is perfectly possible since FS shrinkers
are now per-superblock, we can end up with hundreds of megabytes of
practically unreclaimable kmem objects. For instance, mounting a
thousand of ext2 FS images with a hundred of files in each and iterating
over all the files using du(1) will result in about 200 Mb of FS caches
that cannot be dropped even with the aid of the vm.drop_caches sysctl!

This problem was initially pointed out by Glauber Costa [*]. Glauber
proposed to fix it by making the shrink_slab() always take at least one
pass, to put it simply, turning the scan loop above to a do{}while()
loop. However, this proposal was rejected, because it could result in
more aggressive and frequent slab shrinking even under low memory
pressure when total_scan is naturally very small.

This patch is a slightly modified version of Glauber's approach.
Similarly to Glauber's patch, it makes shrink_slab() scan less than
batch_size objects, but only if the total number of objects we want to
scan (total_scan) is greater than the total number of objects available
(max_pass). Since total_scan is biased as half max_pass if the current
delta change is small:

        if (delta < max_pass / 4)
                total_scan = min(total_scan, max_pass / 2);

this is only possible if we are scanning at high prio. That said, this
patch shouldn't change the vmscan behaviour if the memory pressure is
low, but if we are tight on memory, we will do our best by trying to
reclaim all available objects, which sounds reasonable.

[*] http://www.spinics.net/lists/cgroups/msg06913.html

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-shrink-all-slab-objects-if-tight-on-memory mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-shrink-all-slab-objects-if-tight-on-memory
+++ a/mm/vmscan.c
@@ -281,17 +281,34 @@ shrink_slab_node(struct shrink_control *
 				nr_pages_scanned, lru_pages,
 				max_pass, delta, total_scan);
 
-	while (total_scan >= batch_size) {
+	/*
+	 * Normally, we should not scan less than batch_size objects in one
+	 * pass to avoid too frequent shrinker calls, but if the slab has less
+	 * than batch_size objects in total and we are really tight on memory,
+	 * we will try to reclaim all available objects, otherwise we can end
+	 * up failing allocations although there are plenty of reclaimable
+	 * objects spread over several slabs with usage less than the
+	 * batch_size.
+	 *
+	 * We detect the "tight on memory" situations by looking at the total
+	 * number of objects we want to scan (total_scan). If it is greater
+	 * than the total number of objects on slab (max_pass), we must be
+	 * scanning at high prio and therefore should try to reclaim as much as
+	 * possible.
+	 */
+	while (total_scan >= batch_size ||
+	       total_scan >= max_pass) {
 		unsigned long ret;
+		unsigned long nr_to_scan = min(batch_size, total_scan);
 
-		shrinkctl->nr_to_scan = batch_size;
+		shrinkctl->nr_to_scan = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 		if (ret == SHRINK_STOP)
 			break;
 		freed += ret;
 
-		count_vm_events(SLABS_SCANNED, batch_size);
-		total_scan -= batch_size;
+		count_vm_events(SLABS_SCANNED, nr_to_scan);
+		total_scan -= nr_to_scan;
 
 		cond_resched();
 	}
_

Patches currently in -mm which might be from vdavydov@parallels.com are

fs-superc-fix-warn-on-alloc_super-fail-path.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
linux-next.patch

