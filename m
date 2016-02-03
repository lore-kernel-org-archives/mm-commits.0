From: akpm@linux-foundation.org
Subject: [merged] vmpressure-fix-subtree-pressure-detection.patch removed
 from -mm tree
Date: Wed, 03 Feb 2016 13:53:26 -0800
Message-ID: <56b276d6.UNzbUumSAF7y0rFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmpressure.c: fix subtree pressure detection
has been removed from the -mm tree.  Its filename was
     vmpressure-fix-subtree-pressure-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm/vmpressure.c: fix subtree pressure detection

When vmpressure is called for the entire subtree under pressure we
mistakenly use vmpressure->scanned instead of vmpressure->tree_scanned
when checking if vmpressure work is to be scheduled.  This results in
suppressing all vmpressure events in the legacy cgroup hierarchy.  Fix it.

Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket pressure")
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmpressure.c~vmpressure-fix-subtree-pressure-detection mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-fix-subtree-pressure-detection
+++ a/mm/vmpressure.c
@@ -248,9 +248,8 @@ void vmpressure(gfp_t gfp, struct mem_cg
 
 	if (tree) {
 		spin_lock(&vmpr->sr_lock);
-		vmpr->tree_scanned += scanned;
+		scanned = vmpr->tree_scanned += scanned;
 		vmpr->tree_reclaimed += reclaimed;
-		scanned = vmpr->scanned;
 		spin_unlock(&vmpr->sr_lock);
 
 		if (scanned < vmpressure_win)
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch

