From: akpm@linux-foundation.org
Subject: - dm-raid1-fix-to-commit-pending-clear-region-requests.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:12 -0700
Message-ID: <200705092149.l49LnC9L002679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331AbXEIVtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbrassow@redhat.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm raid1: fix to commit pending clear region requests
has been removed from the -mm tree.  Its filename was
     dm-raid1-fix-to-commit-pending-clear-region-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm raid1: fix to commit pending clear region requests
From: Jonathan Brassow <jbrassow@redhat.com>

With the code as it is, it is possible for oustanding clear region requests
never to get flushed when a mirror is deactivated or suspended.  This means
there will always be some resync work required when a mirror is activated,
even though it may very well be in-sync.

Always requesting the flush doesn't hurt us.  This is because the log tracks
whether any changes occurred and, if not, no flush is performed.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-raid1.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-fix-to-commit-pending-clear-region-requests drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-fix-to-commit-pending-clear-region-requests
+++ a/drivers/md/dm-raid1.c
@@ -405,8 +405,7 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	if (!list_empty(&recovered))
-		rh->log->type->flush(rh->log);
+	rh->log->type->flush(rh->log);
 
 	list_for_each_entry_safe (reg, next, &clean, list)
 		mempool_free(reg, rh->region_pool);
_

Patches currently in -mm which might be from jbrassow@redhat.com are

origin.patch
