From: akpm@linux-foundation.org
Subject: - cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch removed from -mm tree
Date: Fri, 19 Dec 2008 12:35:36 -0800
Message-ID: <200812192035.mBJKZacS031426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYLSUgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Dec 2008 15:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: fix problem that deleting multiple logical drives could cause a panic
has been removed from the -mm tree.  Its filename was
     cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix problem that deleting multiple logical drives could cause a panic
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Fix problem that deleting multiple logical drives could cause a panic.

It fixes a panic which can be easily reproduced in the following way: Just
create several "arrays," each with multiple logical drives via hpacucli,
then delete the first array, and it will blow up in deregister_disk(), in
the call to get_host() when it tries to dig the hba pointer out of a NULL
queue pointer.

The problem has been present since my code to make rebuild_lun_table
behave better went in.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/cciss.c~cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic
+++ a/drivers/block/cciss.c
@@ -1679,6 +1679,11 @@ static int rebuild_lun_table(ctlr_info_t
 	for (i = 0; i <= h->highest_lun; i++) {
 		int j;
 		drv_found = 0;
+
+		/* skip holes in the array from already deleted drives */
+		if (h->drv[i].raid_level == -1)
+			continue;
+
 		for (j = 0; j < num_luns; j++) {
 			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
 			lunid = le32_to_cpu(lunid);
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

origin.patch
linux-next.patch

