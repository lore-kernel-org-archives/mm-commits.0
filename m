From: akpm@linux-foundation.org
Subject: [merged] shrinker-add-node-awareness.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:16:07 -0700
Message-ID: <52338097.NG3Brc8fvrc6BqUc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] shrinker-add-node-awareness.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:07 -0700


The patch titled
     Subject: shrinker: add node awareness
has been removed from the -mm tree.  Its filename was
     shrinker-add-node-awareness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: add node awareness

Pass the node of the current zone being reclaimed to shrink_slab(),
allowing the shrinker control nodemask to be set appropriately for node
aware shrinkers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/ashmem.c |    3 +++
 fs/drop_caches.c                 |    1 +
 include/linux/shrinker.h         |    3 +++
 mm/memory-failure.c              |    2 ++
 mm/vmscan.c                      |   11 ++++++++---
 5 files changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/staging/android/ashmem.c~shrinker-add-node-awareness drivers/staging/android/ashmem.c
--- a/drivers/staging/android/ashmem.c~shrinker-add-node-awareness
+++ a/drivers/staging/android/ashmem.c
@@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *fi
 				.gfp_mask = GFP_KERNEL,
 				.nr_to_scan = 0,
 			};
+
+			nodes_setall(sc.nodes_to_scan);
+
 			ret = ashmem_shrink(&ashmem_shrinker, &sc);
 			sc.nr_to_scan = ret;
 			ashmem_shrink(&ashmem_shrinker, &sc);
diff -puN fs/drop_caches.c~shrinker-add-node-awareness fs/drop_caches.c
--- a/fs/drop_caches.c~shrinker-add-node-awareness
+++ a/fs/drop_caches.c
@@ -44,6 +44,7 @@ static void drop_slab(void)
 		.gfp_mask = GFP_KERNEL,
 	};
 
+	nodes_setall(shrink.nodes_to_scan);
 	do {
 		nr_objects = shrink_slab(&shrink, 1000, 1000);
 	} while (nr_objects > 10);
diff -puN include/linux/shrinker.h~shrinker-add-node-awareness include/linux/shrinker.h
--- a/include/linux/shrinker.h~shrinker-add-node-awareness
+++ a/include/linux/shrinker.h
@@ -16,6 +16,9 @@ struct shrink_control {
 
 	/* How many slab objects shrinker() should scan and try to reclaim */
 	unsigned long nr_to_scan;
+
+	/* shrink from these nodes */
+	nodemask_t nodes_to_scan;
 };
 
 #define SHRINK_STOP (~0UL)
diff -puN mm/memory-failure.c~shrinker-add-node-awareness mm/memory-failure.c
--- a/mm/memory-failure.c~shrinker-add-node-awareness
+++ a/mm/memory-failure.c
@@ -248,10 +248,12 @@ void shake_page(struct page *p, int acce
 	 */
 	if (access) {
 		int nr;
+		int nid = page_to_nid(p);
 		do {
 			struct shrink_control shrink = {
 				.gfp_mask = GFP_KERNEL,
 			};
+			node_set(nid, shrink.nodes_to_scan);
 
 			nr = shrink_slab(&shrink, 1000, 1000);
 			if (page_count(p) == 1)
diff -puN mm/vmscan.c~shrinker-add-node-awareness mm/vmscan.c
--- a/mm/vmscan.c~shrinker-add-node-awareness
+++ a/mm/vmscan.c
@@ -2420,12 +2420,16 @@ static unsigned long do_try_to_free_page
 		 */
 		if (global_reclaim(sc)) {
 			unsigned long lru_pages = 0;
+
+			nodes_clear(shrink->nodes_to_scan);
 			for_each_zone_zonelist(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask)) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
 				lru_pages += zone_reclaimable_pages(zone);
+				node_set(zone_to_nid(zone),
+					 shrink->nodes_to_scan);
 			}
 
 			shrink_slab(shrink, sc->nr_scanned, lru_pages);
@@ -2881,6 +2885,8 @@ static bool kswapd_shrink_zone(struct zo
 		return true;
 
 	shrink_zone(zone, sc);
+	nodes_clear(shrink.nodes_to_scan);
+	node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 
 	reclaim_state->reclaimed_slab = 0;
 	shrink_slab(&shrink, sc->nr_scanned, lru_pages);
@@ -3561,10 +3567,9 @@ static int __zone_reclaim(struct zone *z
 		 * number of slab pages and shake the slab until it is reduced
 		 * by the same nr_pages that we used for reclaiming unmapped
 		 * pages.
-		 *
-		 * Note that shrink_slab will free memory on all zones and may
-		 * take a long time.
 		 */
+		nodes_clear(shrink.nodes_to_scan);
+		node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 		for (;;) {
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

