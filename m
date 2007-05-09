From: akpm@linux-foundation.org
Subject: + dm-log-fix-resume-failed-log-device.patch added to -mm tree
Date: Tue, 08 May 2007 17:55:23 -0700
Message-ID: <200705090055.l490tNNn006454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032475AbXEIAzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm log: fix resume failed log device
has been added to the -mm tree.  Its filename is
     dm-log-fix-resume-failed-log-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm log: fix resume failed log device
From: Jonathan Brassow <jbrassow@redhat.com>

This patch removes the possibility of having uninitialized log state if the
log device has failed.

When a mirror resumes operation, it calls 'resume' on the logging module.  If
disk based logging is being used, the log device is read to fill in the log
state.  If the log device has failed, we cannot simply return, because this
would leave the in-memory log state uninitialized.  Instead, we assume all
regions are out-of-sync and reset the log state.  Failure to do this could
result in the logging code reporting a region as in-sync, even though it
isn't; which could result in a corrupted mirror.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-log.c~dm-log-fix-resume-failed-log-device drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-log-fix-resume-failed-log-device
+++ a/drivers/md/dm-log.c
@@ -478,7 +478,14 @@ static int disk_resume(struct dirty_log 
 		DMWARN("%s: Failed to read header on mirror log device",
 		       lc->log_dev->name);
 		fail_log_device(lc);
-		return r;
+		/*
+		 * If the log device cannot be read, we must assume
+		 * all regions are out-of-sync.  If we simply return
+		 * here, the state will be uninitialized and could
+		 * lead us to return 'in-sync' status for regions
+		 * that are actually 'out-of-sync'.
+		 */
+		lc->header.nr_regions = 0;
 	}
 
 	/* set or clear any new bits -- device has grown */
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
