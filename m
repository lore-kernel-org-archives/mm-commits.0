From: akpm@linux-foundation.org
Subject: + mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch
 added to -mm tree
Date: Tue, 14 Jan 2020 16:22:23 -0800
Message-ID: <20200115002223.cexEp7J5F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgAOAWZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:22:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE
has been added to the -mm tree.  Its filename is
     mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE

commit 1b2ffb7896ad ("[PATCH] Zone reclaim: Allow modification of zone
reclaim behavior")' defined RECLAIM_OFF/RECLAIM_ZONE, but never use them,
so better to remove them.

Link: http://lkml.kernel.org/r/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unused-reclaim_off-reclaim_zone
+++ a/mm/vmscan.c
@@ -4118,8 +4118,6 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_OFF 0
-#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
 #define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-remove-prefetch_prev_lru_page.patch
mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch
