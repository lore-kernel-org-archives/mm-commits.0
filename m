From: akpm@linux-foundation.org
Subject: + mm-srcu-ify-shrinkers.patch added to -mm tree
Date: Thu, 23 Jul 2015 12:45:23 -0700
Message-ID: <55b14453.qLIfk8TMKZNHDqHo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbbGWTpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 15:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, david@fromorbit.com, dbueso@suse.de, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     From: Davidlohr Bueso <dave@stgolabs.net>
has been added to the -mm tree.  Its filename is
     mm-srcu-ify-shrinkers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-srcu-ify-shrinkers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-srcu-ify-shrinkers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm: srcu-ify shrinkers

The shrinker_rwsem is a global lock that protects the shrinker_list,
serializing a shrinking call with register/unregistering the shrinker
itself. As such, this lock is taken mostly for reading. In the unlikely
case that the the list is being modified, we simply return indicating
we want to iterate again. However, the only caller of shrink_slab()
that acknowledges this return is drop_slab_node(), so in practice, the
rest of the callers never try again.

This patch proposes replacing the rwsem with an srcu aware list of
shrinkers, where (un)registering tasks use a spinlock. Upon shrinker
calls, the srcu read lock will guarantee the existence of the structure,
thus safely optimizing the common (read locked) case. These guarantees
also allow us to cleanup and simplify the code, getting rid of the
ugly trylock mechanism to retry the shrinker operation when the list
is concurrently being modified. As Michal pointed this is only worth
mentioning for unregister purposes.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c  |    8 ++++----
 mm/vmscan.c |   39 ++++++++++++++++++---------------------
 2 files changed, 22 insertions(+), 25 deletions(-)

diff -puN fs/super.c~mm-srcu-ify-shrinkers fs/super.c
--- a/fs/super.c~mm-srcu-ify-shrinkers
+++ a/fs/super.c
@@ -49,8 +49,8 @@ static char *sb_writers_name[SB_FREEZE_L
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
- * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
- * take a passive reference to the superblock to avoid this from occurring.
+ * shrinker path. Hence we take a passive reference to the superblock to avoid
+ * this from occurring.
  */
 static unsigned long super_cache_scan(struct shrinker *shrink,
 				      struct shrink_control *sc)
@@ -121,8 +121,8 @@ static unsigned long super_cache_count(s
 	 * Don't call trylock_super as it is a potential
 	 * scalability bottleneck. The counts could get updated
 	 * between super_cache_count and super_cache_scan anyway.
-	 * Call to super_cache_count with shrinker_rwsem held
-	 * ensures the safety of call to list_lru_shrink_count() and
+	 * SRCU guarantees object validity across this call -- thus
+	 * it is safe to call list_lru_shrink_count() and
 	 * s_op->nr_cached_objects().
 	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
diff -puN mm/vmscan.c~mm-srcu-ify-shrinkers mm/vmscan.c
--- a/mm/vmscan.c~mm-srcu-ify-shrinkers
+++ a/mm/vmscan.c
@@ -36,7 +36,7 @@
 #include <linux/cpuset.h>
 #include <linux/compaction.h>
 #include <linux/notifier.h>
-#include <linux/rwsem.h>
+#include <linux/srcu.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -146,8 +146,9 @@ int vm_swappiness = 60;
  */
 unsigned long vm_total_pages;
 
+DEFINE_STATIC_SRCU(shrinker_srcu);
 static LIST_HEAD(shrinker_list);
-static DECLARE_RWSEM(shrinker_rwsem);
+static DEFINE_SPINLOCK(shrinker_list_lock);
 
 #ifdef CONFIG_MEMCG
 static bool global_reclaim(struct scan_control *sc)
@@ -242,9 +243,9 @@ int register_shrinker(struct shrinker *s
 	if (!shrinker->nr_deferred)
 		return -ENOMEM;
 
-	down_write(&shrinker_rwsem);
-	list_add_tail(&shrinker->list, &shrinker_list);
-	up_write(&shrinker_rwsem);
+	spin_lock(&shrinker_list_lock);
+	list_add_tail_rcu(&shrinker->list, &shrinker_list);
+	spin_unlock(&shrinker_list_lock);
 	return 0;
 }
 EXPORT_SYMBOL(register_shrinker);
@@ -254,9 +255,14 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
-	down_write(&shrinker_rwsem);
-	list_del(&shrinker->list);
-	up_write(&shrinker_rwsem);
+	spin_lock(&shrinker_list_lock);
+	list_del_rcu(&shrinker->list);
+	spin_unlock(&shrinker_list_lock);
+	/*
+	 * Before freeing nr_deferred, ensure all srcu
+	 * readers are done with their critical region.
+	 */
+	synchronize_srcu(&shrinker_srcu);
 	kfree(shrinker->nr_deferred);
 }
 EXPORT_SYMBOL(unregister_shrinker);
@@ -408,6 +414,7 @@ static unsigned long shrink_slab(gfp_t g
 				 unsigned long nr_scanned,
 				 unsigned long nr_eligible)
 {
+	int idx;
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
 
@@ -417,18 +424,9 @@ static unsigned long shrink_slab(gfp_t g
 	if (nr_scanned == 0)
 		nr_scanned = SWAP_CLUSTER_MAX;
 
-	if (!down_read_trylock(&shrinker_rwsem)) {
-		/*
-		 * If we would return 0, our callers would understand that we
-		 * have nothing else to shrink and give up trying. By returning
-		 * 1 we keep it going and assume we'll be able to shrink next
-		 * time.
-		 */
-		freed = 1;
-		goto out;
-	}
+	idx = srcu_read_lock(&shrinker_srcu);
 
-	list_for_each_entry(shrinker, &shrinker_list, list) {
+	list_for_each_entry_rcu(shrinker, &shrinker_list, list) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -444,8 +442,7 @@ static unsigned long shrink_slab(gfp_t g
 		freed += do_shrink_slab(&sc, shrinker, nr_scanned, nr_eligible);
 	}
 
-	up_read(&shrinker_rwsem);
-out:
+	srcu_read_unlock(&shrinker_srcu, idx);
 	cond_resched();
 	return freed;
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-use-private-shmem-or-hugetlbfs-inodes-for-shm-segments.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch
mm-srcu-ify-shrinkers.patch
ipc-convert-invalid-scenarios-to-use-warn_on.patch
linux-next.patch

