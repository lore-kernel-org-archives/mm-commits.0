From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:18:40 -0800
Message-ID: <20200131231840.6OEkP5sLH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cl@linux.com, dwagner@suse.de, mm-commits@vger.kernel.org, tobin@kernel.org


The patch titled
     Subject: mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-unused-reclaim_off-reclaim_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: remove unused RECLAIM_OFF/RECLAIM_ZONE

commit 1b2ffb7896ad ("[PATCH] Zone reclaim: Allow modification of zone
reclaim behavior")' defined RECLAIM_OFF/RECLAIM_ZONE, but never use them,
so better to remove them.

[dwagner@suse.de: fix sanity checks enabling]
  Link: http://lkml.kernel.org/r/20200116131642.642-1-dwagner@suse.de
[akpm@linux-foundation.org: renumber the bits for neatness]
Link: http://lkml.kernel.org/r/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-unused-reclaim_off-reclaim_zone
+++ a/mm/vmscan.c
@@ -4110,10 +4110,8 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-#define RECLAIM_OFF 0
-#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
-#define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
+#define RECLAIM_WRITE (1<<0)	/* Writeout pages during reclaim */
+#define RECLAIM_UNMAP (1<<1)	/* Unmap pages during reclaim */
 
 /*
  * Priority for NODE_RECLAIM. This determines the fraction of pages
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are
