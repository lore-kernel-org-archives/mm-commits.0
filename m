From: akpm@linux-foundation.org
Subject: - cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:03:17 -0700
Message-ID: <200807070303.m6733HRg004637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYGGDED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix regression that no device nodes are created if no logical drives are configured.
has been removed from the -mm tree.  Its filename was
     cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix regression that no device nodes are created if no logical drives are configured.
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Fix regression in cciss driver that if no logical drives are configured,
no device nodes at all get created.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/block/cciss.c~cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured
+++ a/drivers/block/cciss.c
@@ -3546,6 +3546,10 @@ static int __devinit cciss_init_one(stru
 	for (j = 0; j <= hba[i]->highest_lun; j++)
 		add_disk(hba[i]->gendisk[j]);
 
+	/* we must register the controller even if no disks exist */
+	if (hba[i]->highest_lun == -1)
+		add_disk(hba[i]->gendisk[0]);
+
 	return 1;
 
       clean4:
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are


