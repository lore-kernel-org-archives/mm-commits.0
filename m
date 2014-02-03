From: akpm@linux-foundation.org
Subject: + mm-vmscan-shrink_slab-rename-max_pass-freeable.patch added to
 -mm tree
Date: Mon, 03 Feb 2014 14:32:15 -0800
Message-ID: <52f018ef.npQS3DOrgcmtEzNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaBCWcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:32:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, vdavydov@parallels.com

Subject: + mm-vmscan-shrink_slab-rename-max_pass-freeable.patch added to -mm tree
To: vdavydov@parallels.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:32:15 -0800


The patch titled
     Subject: mm: vmscan: shrink_slab: rename max_pass -> freeable
has been added to the -mm tree.  Its filename is
     mm-vmscan-shrink_slab-rename-max_pass-freeable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-shrink_slab-rename-max_pass-freeable.patch

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

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
linux-next.patch

