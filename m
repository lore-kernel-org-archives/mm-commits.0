From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-race-in-region-tracking-update.patch added to
 -mm tree
Date: Mon, 03 Feb 2014 16:15:47 -0800
Message-ID: <52f03133.B6MFfKmRv46SsI6o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDAPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, davidlohr@hp.com, david@gibson.dropbear.id.au, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-fix-race-in-region-tracking-update.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,david@gibson.dropbear.id.au,davidlohr@hp.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:15:47 -0800


The patch titled
     Subject: mm, hugetlb: fix race in region tracking
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-race-in-region-tracking-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-race-in-region-tracking-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-race-in-region-tracking-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: fix race in region tracking

There is a race condition if we map a same file on different processes. 
Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex. 
When we do mmap, we don't grab a hugetlb_instantiation_mutex, but only
the, mmap_sem (exclusively).  This doesn't prevent other tasks from
modifying the region structure, so it can be modified by two processes
concurrently.

To solve this, introduce a spinlock to resv_map and make region manipulation
function grab it before they do actual work.

[davidlohr@hp.com: updated changelog]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-race-in-region-tracking-update mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-race-in-region-tracking-update
+++ a/mm/hugetlb.c
@@ -206,15 +206,17 @@ retry:
 			if (!nrg)
 				return -ENOMEM;
 
-			nrg->from = f;
-			nrg->to   = f;
-			INIT_LIST_HEAD(&nrg->link);
 			goto retry;
 		}
 
+		nrg->from = f;
+		nrg->to   = f;
+		INIT_LIST_HEAD(&nrg->link);
 		list_add(&nrg->link, rg->link.prev);
+		nrg = NULL;
+
 		chg = t - f;
-		goto out_nrg;
+		goto out_locked;
 	}
 
 	/* Round our left edge to the current segment if it encloses us. */
@@ -227,7 +229,7 @@ retry:
 		if (&rg->link == head)
 			break;
 		if (rg->from > t)
-			goto out;
+			goto out_locked;
 
 		/* We overlap with this area, if it extends further than
 		 * us then we must extend ourselves.  Account for its
@@ -239,14 +241,10 @@ retry:
 		chg -= rg->to - rg->from;
 	}
 
-out:
+out_locked:
 	spin_unlock(&resv->lock);
-	/*  We already know we raced and no longer need the new region */
 	kfree(nrg);
 	return chg;
-out_nrg:
-	spin_unlock(&resv->lock);
-	return chg;
 }
 
 static long region_truncate(struct resv_map *resv, long end)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-fix-race-in-region-tracking-update.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-use-vma_resv_map-map-types-update.patch
mm-hugetlb-use-vma_resv_map-map-types-update-fix.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-improve-page-fault-scalability-update.patch

