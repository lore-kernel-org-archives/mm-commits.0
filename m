From: akpm@linux-foundation.org
Subject: + cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:37:42 -0800
Message-ID: <200812172237.mBHMbgFB016087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbYLQWiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     cciss: fix problem that deleting multiple logical drives could cause a panic
has been added to the -mm tree.  Its filename is
     cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/block/cciss.c~cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic
+++ a/drivers/block/cciss.c
@@ -1680,6 +1680,11 @@ static int rebuild_lun_table(ctlr_info_t
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

cciss-fix-problem-that-deleting-multiple-logical-drives-could-cause-a-panic.patch
cciss-simplify-parameters-to-deregister_disk-function.patch

