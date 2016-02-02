From: akpm@linux-foundation.org
Subject: +
 mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:36:36 -0800
Message-ID: <56b12f74.RWRZUNE8EuE5+uq+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbcBBWgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:36:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: separate shadow unpacking and refault calculation
has been added to the -mm tree.  Its filename is
     mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch

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
Subject: mm: workingset: separate shadow unpacking and refault calculation

Per-cgroup thrash detection will need to derive a live memcg from the
eviction cookie, and doing that inside unpack_shadow() will get nasty with
the reference handling spread over two functions.

In preparation, make unpack_shadow() clearly about extracting static data,
and let workingset_refault() do all the higher-level handling.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   56 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/workingset.c~mm-workingset-separate-shadow-unpacking-and-refault-calculation mm/workingset.c
--- a/mm/workingset.c~mm-workingset-separate-shadow-unpacking-and-refault-calculation
+++ a/mm/workingset.c
@@ -165,13 +165,10 @@ static void *pack_shadow(unsigned long e
 	return (void *)(eviction | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
-static void unpack_shadow(void *shadow,
-			  struct zone **zone,
-			  unsigned long *distance)
+static void unpack_shadow(void *shadow, struct zone **zonep,
+			  unsigned long *evictionp)
 {
 	unsigned long entry = (unsigned long)shadow;
-	unsigned long eviction;
-	unsigned long refault;
 	int zid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -179,29 +176,9 @@ static void unpack_shadow(void *shadow,
 	entry >>= ZONES_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
-	eviction = entry;
-
-	*zone = NODE_DATA(nid)->node_zones + zid;
 
-	refault = atomic_long_read(&(*zone)->inactive_age);
-
-	/*
-	 * The unsigned subtraction here gives an accurate distance
-	 * across inactive_age overflows in most cases.
-	 *
-	 * There is a special case: usually, shadow entries have a
-	 * short lifetime and are either refaulted or reclaimed along
-	 * with the inode before they get too old.  But it is not
-	 * impossible for the inactive_age to lap a shadow entry in
-	 * the field, which can then can result in a false small
-	 * refault distance, leading to a false activation should this
-	 * old entry actually refault again.  However, earlier kernels
-	 * used to deactivate unconditionally with *every* reclaim
-	 * invocation for the longest time, so the occasional
-	 * inappropriate activation leading to pressure on the active
-	 * list is not a problem.
-	 */
-	*distance = (refault - eviction) & EVICTION_MASK;
+	*zonep = NODE_DATA(nid)->node_zones + zid;
+	*evictionp = entry;
 }
 
 /**
@@ -233,9 +210,32 @@ void *workingset_eviction(struct address
 bool workingset_refault(void *shadow)
 {
 	unsigned long refault_distance;
+	unsigned long eviction;
+	unsigned long refault;
 	struct zone *zone;
 
-	unpack_shadow(shadow, &zone, &refault_distance);
+	unpack_shadow(shadow, &zone, &eviction);
+
+	refault = atomic_long_read(&zone->inactive_age);
+
+	/*
+	 * The unsigned subtraction here gives an accurate distance
+	 * across inactive_age overflows in most cases.
+	 *
+	 * There is a special case: usually, shadow entries have a
+	 * short lifetime and are either refaulted or reclaimed along
+	 * with the inode before they get too old.  But it is not
+	 * impossible for the inactive_age to lap a shadow entry in
+	 * the field, which can then can result in a false small
+	 * refault distance, leading to a false activation should this
+	 * old entry actually refault again.  However, earlier kernels
+	 * used to deactivate unconditionally with *every* reclaim
+	 * invocation for the longest time, so the occasional
+	 * inappropriate activation leading to pressure on the active
+	 * list is not a problem.
+	 */
+	refault_distance = (refault - eviction) & EVICTION_MASK;
+
 	inc_zone_state(zone, WORKINGSET_REFAULT);
 
 	if (refault_distance <= zone_page_state(zone, NR_ACTIVE_FILE)) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

