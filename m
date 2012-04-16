From: akpm@linux-foundation.org
Subject: [merged] revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:40 -0700
Message-ID: <20120416201540.7FDA3A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:55904 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2DPUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:42 -0400
Received: by wgbdt11 with SMTP id dt11so290534wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, dhillf@gmail.com, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: Revert "mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()"

This reverts commit c38446cc65e1f2b3eb8630c53943b94c4f65f670.

Before the commit, the code makes senses to me but not after the commit. 
The "nr_reclaimed" is the number of pages reclaimed by scanning through
the memcg's lru lists.  The "nr_to_reclaim" is the target value for the
whole function.  For example, we like to early break the reclaim if
reclaimed 32 pages under direct reclaim (not DEF_PRIORITY).

After the reverted commit, the target "nr_to_reclaim" is decremented each
time by "nr_reclaimed" but we still use it to compare the "nr_reclaimed". 
It just doesn't make sense to me...

Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN mm/vmscan.c~revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone mm/vmscan.c
--- a/mm/vmscan.c~revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone
+++ a/mm/vmscan.c
@@ -2107,12 +2107,7 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim)
-			nr_to_reclaim = 0;
-		else
-			nr_to_reclaim -= nr_reclaimed;
