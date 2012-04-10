From: akpm@linux-foundation.org
Subject: + revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch added to -mm tree
Date: Mon, 09 Apr 2012 17:06:15 -0700
Message-ID: <20120410000615.ED498A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53747 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2DJAGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Apr 2012 20:06:18 -0400
Received: by eaaq10 with SMTP id q10so216660eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Apr 2012 17:06:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, dhillf@gmail.com, hughd@google.com, riel@redhat.com


The patch titled
     Subject: Revert "mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()"
has been added to the -mm tree.  Its filename is
     revert-mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
