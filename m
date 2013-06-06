From: akpm@linux-foundation.org
Subject: [to-be-updated]
 vmscan-take-at-least-one-pass-with-shrinkers.patch removed from -mm tree
Date: Thu, 06 Jun 2013 12:35:21 -0700
Message-ID: <51b0e479.MEvnXPjNWp5qFIi4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3FFTfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] vmscan-take-at-least-one-pass-with-shrinkers.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:21 -0700


The patch titled
     Subject: vmscan: take at least one pass with shrinkers
has been removed from the -mm tree.  Its filename was
     vmscan-take-at-least-one-pass-with-shrinkers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: vmscan: take at least one pass with shrinkers

In very low free kernel memory situations, it may be the case that we have
less objects to free than our initial batch size.  If this is the case, it
is better to shrink those, and open space for the new workload then to
keep them and fail the new allocations.

In particular, we are concerned with the direct reclaim case for memcg. 
Although this same technique can be applied to other situations just as
well, we will start conservative and apply it for that case, which is the
one that matters the most.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~vmscan-take-at-least-one-pass-with-shrinkers mm/vmscan.c
--- a/mm/vmscan.c~vmscan-take-at-least-one-pass-with-shrinkers
+++ a/mm/vmscan.c
@@ -297,21 +297,34 @@ shrink_slab_node(struct shrink_control *
 				nr_pages_scanned, lru_pages,
 				max_pass, delta, total_scan);
 
-	while (total_scan >= batch_size) {
+	do {
 		long ret;
+		unsigned long nr_to_scan = min(batch_size, total_scan);
+		struct mem_cgroup *memcg = shrinkctl->target_mem_cgroup;
 
-		shrinkctl->nr_to_scan = batch_size;
+		/*
+		 * Differentiate between "few objects" and "no objects"
+		 * as returned by the count step.
+		 */
+		if (!total_scan)
+			break;
+
+		if ((total_scan < batch_size) &&
+		   !(memcg && memcg_kmem_is_active(memcg)))
+			break;
+
+		shrinkctl->nr_to_scan = nr_to_scan;
 		ret = shrinker->scan_objects(shrinker, shrinkctl);
 
 		if (ret == -1)
 			break;
 		freed += ret;
 
-		count_vm_events(SLABS_SCANNED, batch_size);
-		total_scan -= batch_size;
+		count_vm_events(SLABS_SCANNED, nr_to_scan);
+		total_scan -= nr_to_scan;
 
 		cond_resched();
-	}
+	} while (total_scan >= batch_size);
 
 	/*
 	 * move the unused scan count back into the shrinker in a
_

Patches currently in -mm which might be from glommer@openvz.org are

super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

