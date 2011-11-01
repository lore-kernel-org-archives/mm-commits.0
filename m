From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:15 -0700
Message-ID: <201111012112.pA1LCFHh030982@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not drain pagevecs for mlockall(MCL_FUTURE)
has been removed from the -mm tree.  Its filename was
     mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: mm: do not drain pagevecs for mlockall(MCL_FUTURE)

MCL_FUTURE does not move pages between lru list and draining the LRU per
cpu pagevecs is a nasty activity.  Avoid doing it unecessarily.

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-do-not-drain-pagevecs-for-mlockallmcl_future mm/mlock.c
--- a/mm/mlock.c~mm-do-not-drain-pagevecs-for-mlockallmcl_future
+++ a/mm/mlock.c
@@ -549,7 +549,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		goto out;
 
-	lru_add_drain_all();	/* flush pagevec */
+	if (flags & MCL_CURRENT)
+		lru_add_drain_all();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 
_

Patches currently in -mm which might be from cl@gentwo.org are

origin.patch
linux-next.patch

