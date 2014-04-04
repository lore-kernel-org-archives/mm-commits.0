From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:12 -0700
Message-ID: <533f0880.2lCZkn1SljbYsfna%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaDDTbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, vdavydov@parallels.com

Subject: [merged] mm-vmscan-shrink_slab-rename-max_pass-freeable.patch removed from -mm tree
To: vdavydov@parallels.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:12 -0700


The patch titled
     Subject: mm: vmscan: shrink_slab: rename max_pass -> freeable
has been removed from the -mm tree.  Its filename was
     mm-vmscan-shrink_slab-rename-max_pass-freeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: shrink_slab: rename max_pass -> freeable

The name `max_pass' is misleading, because this variable actually keeps
the estimate number of freeable objects, not the maximal number of objects
we can scan in this pass, which can be twice that.  Rename it to reflect
its actual meaning.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-shrink_slab-rename-max_pass-freeable mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-shrink_slab-rename-max_pass-freeable
+++ a/mm/vmscan.c
@@ -224,15 +224,15 @@ shrink_slab_node(struct shrink_control *
 	unsigned long freed = 0;
 	unsigned long long delta;
 	long total_scan;
-	long max_pass;
+	long freeable;
 	long nr;
 	long new_nr;
 	int nid = shrinkctl->nid;
 	long batch_size = shrinker->batch ? shrinker->batch
 					  : SHRINK_BATCH;
 
-	max_pass = shrinker->count_objects(shrinker, shrinkctl);
-	if (max_pass == 0)
+	freeable = shrinker->count_objects(shrinker, shrinkctl);
+	if (freeable == 0)
 		return 0;
 
 	/*
@@ -244,14 +244,14 @@ shrink_slab_node(struct shrink_control *
 
 	total_scan = nr;
 	delta = (4 * nr_pages_scanned) / shrinker->seeks;
-	delta *= max_pass;
+	delta *= freeable;
 	do_div(delta, lru_pages + 1);
 	total_scan += delta;
 	if (total_scan < 0) {
 		printk(KERN_ERR
 		"shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
-		total_scan = max_pass;
+		total_scan = freeable;
 	}
 
 	/*
@@ -260,26 +260,26 @@ shrink_slab_node(struct shrink_control *
 	 * shrinkers to return -1 all the time. This results in a large
 	 * nr being built up so when a shrink that can do some work
 	 * comes along it empties the entire cache due to nr >>>
-	 * max_pass.  This is bad for sustaining a working set in
+	 * freeable. This is bad for sustaining a working set in
 	 * memory.
 	 *
 	 * Hence only allow the shrinker to scan the entire cache when
 	 * a large delta change is calculated directly.
 	 */
-	if (delta < max_pass / 4)
-		total_scan = min(total_scan, max_pass / 2);
+	if (delta < freeable / 4)
+		total_scan = min(total_scan, freeable / 2);
 
 	/*
 	 * Avoid risking looping forever due to too large nr value:
 	 * never try to free more than twice the estimate number of
 	 * freeable entries.
 	 */
-	if (total_scan > max_pass * 2)
-		total_scan = max_pass * 2;
+	if (total_scan > freeable * 2)
+		total_scan = freeable * 2;
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 				nr_pages_scanned, lru_pages,
-				max_pass, delta, total_scan);
+				freeable, delta, total_scan);
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -292,12 +292,12 @@ shrink_slab_node(struct shrink_control *
 	 *
 	 * We detect the "tight on memory" situations by looking at the total
 	 * number of objects we want to scan (total_scan). If it is greater
-	 * than the total number of objects on slab (max_pass), we must be
+	 * than the total number of objects on slab (freeable), we must be
 	 * scanning at high prio and therefore should try to reclaim as much as
 	 * possible.
 	 */
 	while (total_scan >= batch_size ||
-	       total_scan >= max_pass) {
+	       total_scan >= freeable) {
 		unsigned long ret;
 		unsigned long nr_to_scan = min(batch_size, total_scan);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
slub-fix-leak-of-name-in-sysfs_slab_add.patch

