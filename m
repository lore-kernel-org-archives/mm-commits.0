From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch added
 to -mm tree
Date: Wed, 27 Jan 2016 11:01:07 -0800
Message-ID: <56a913f3.Rhngmq5Ms5Dpulyj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703AbcA0TBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:01:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not clear SHRINKER_NUMA_AWARE if nr_node_ids == 1
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-%3D%3D-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-%3D%3D-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: do not clear SHRINKER_NUMA_AWARE if nr_node_ids == 1

Currently, on shrinker registration we clear SHRINKER_NUMA_AWARE if
there's the only NUMA node present.  The comment states that this will
allow us to save some small loop time later.  It used to be true when this
code was added (see commit 1d3d4437eae1b ("vmscan: per-node deferred
work")), but since commit 6b4f7799c6a57 ("mm: vmscan: invoke slab
shrinkers from shrink_zone()") it doesn't make any difference.  Anyway,
running on non-NUMA machine shouldn't make a shrinker NUMA unaware, so zap
this hunk.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1
+++ a/mm/vmscan.c
@@ -228,14 +228,6 @@ int register_shrinker(struct shrinker *s
 {
 	size_t size = sizeof(*shrinker->nr_deferred);
 
-	/*
-	 * If we only have one possible node in the system anyway, save
-	 * ourselves the trouble and disable NUMA aware behavior. This way we
-	 * will save memory and some small loop time later.
-	 */
-	if (nr_node_ids == 1)
-		shrinker->flags &= ~SHRINKER_NUMA_AWARE;
