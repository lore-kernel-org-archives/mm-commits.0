From: akpm@linux-foundation.org
Subject: + dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch added to -mm tree
Date: Tue, 08 May 2007 17:55:21 -0700
Message-ID: <200705090055.l490tLTR006449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032487AbXEIAzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm raid1: switch rh_in_sync to blocking in do_reads
has been added to the -mm tree.  Its filename is
     dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm raid1: switch rh_in_sync to blocking in do_reads
From: Jonathan Brassow <jbrassow@redhat.com>

The call to rh_in_sync() in do_reads() should be allowed to block.  It is in
the mirror worker thread which already permits blocking operations.  This will
be needed to support clustered mirroring which will perform network
operations.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads
+++ a/drivers/md/dm-raid1.c
@@ -741,7 +741,7 @@ static void do_reads(struct mirror_set *
 		/*
 		 * We can only read balance if the region is in sync.
 		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (rh_in_sync(&ms->rh, region, 1))
 			m = choose_mirror(ms, bio->bi_sector);
 		else
 			m = ms->default_mirror;
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
