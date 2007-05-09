From: akpm@linux-foundation.org
Subject: + dm-raid1-fix-to-commit-pending-clear-region-requests.patch added to -mm tree
Date: Tue, 08 May 2007 17:55:18 -0700
Message-ID: <200705090055.l490tImU006444@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032466AbXEIAz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm raid1: fix to commit pending clear region requests
has been added to the -mm tree.  Its filename is
     dm-raid1-fix-to-commit-pending-clear-region-requests.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 2 deletions(-)

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

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
