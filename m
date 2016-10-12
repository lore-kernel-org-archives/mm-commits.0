From: akpm@linux-foundation.org
Subject: + vmscan-set-correct-defer-count-for-shrinker.patch added to -mm
 tree
Date: Wed, 12 Oct 2016 16:29:53 -0700
Message-ID: <57fec771.djZM7e7uEu6V/t8a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40729 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932724AbcJLXai (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 19:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: set correct defer count for shrinker
has been added to the -mm tree.  Its filename is
     vmscan-set-correct-defer-count-for-shrinker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-set-correct-defer-count-for-shrinker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-set-correct-defer-count-for-shrinker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@fb.com>
Subject: mm/vmscan.c: set correct defer count for shrinker

Our system uses significantly more slab memory with memcg enabled with the
latest kernel.  With 3.10 kernel, slab uses 2G memory, while with 4.6
kernel, 6G memory is used.  The shrinker has problem.  Let's see we have
two memcg for one shrinker.  In do_shrink_slab:

1. Check cg1.  nr_deferred = 0, assume total_scan = 700.  batch size
   is 1024, then no memory is freed.  nr_deferred = 700

2. Check cg2.  nr_deferred = 700.  Assume freeable = 20, then
   total_scan = 10 or 40.  Let's assume it's 10.  No memory is freed. 
   nr_deferred = 10.

The deferred share of cg1 is lost in this case.  kswapd will free no
memory even run above steps again and again.

The fix makes sure one memcg's deferred share isn't lost.

Link: http://lkml.kernel.org/r/2414be961b5d25892060315fbb56bb19d81d0c07.1476227351.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~vmscan-set-correct-defer-count-for-shrinker mm/vmscan.c
--- a/mm/vmscan.c~vmscan-set-correct-defer-count-for-shrinker
+++ a/mm/vmscan.c
@@ -291,6 +291,7 @@ static unsigned long do_shrink_slab(stru
 	int nid = shrinkctl->nid;
 	long batch_size = shrinker->batch ? shrinker->batch
 					  : SHRINK_BATCH;
+	long scanned = 0, next_deferred;
 
 	freeable = shrinker->count_objects(shrinker, shrinkctl);
 	if (freeable == 0)
@@ -312,7 +313,9 @@ static unsigned long do_shrink_slab(stru
 		pr_err("shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
 		total_scan = freeable;
-	}
+		next_deferred = nr;
+	} else
+		next_deferred = total_scan;
 
 	/*
 	 * We need to avoid excessive windup on filesystem shrinkers
@@ -369,17 +372,22 @@ static unsigned long do_shrink_slab(stru
 
 		count_vm_events(SLABS_SCANNED, nr_to_scan);
 		total_scan -= nr_to_scan;
+		scanned += nr_to_scan;
 
 		cond_resched();
 	}
 
+	if (next_deferred >= scanned)
+		next_deferred -= scanned;
+	else
+		next_deferred = 0;
 	/*
 	 * move the unused scan count back into the shrinker in a
 	 * manner that handles concurrent updates. If we exhausted the
 	 * scan, there is no need to do an update.
 	 */
-	if (total_scan > 0)
-		new_nr = atomic_long_add_return(total_scan,
+	if (next_deferred > 0)
+		new_nr = atomic_long_add_return(next_deferred,
 						&shrinker->nr_deferred[nid]);
 	else
 		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
_

Patches currently in -mm which might be from shli@fb.com are

vmscan-set-correct-defer-count-for-shrinker.patch

