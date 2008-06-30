From: akpm@linux-foundation.org
Subject: + cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:27:59 -0700
Message-ID: <200806302127.m5ULRxvE026272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbYF3V2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, mike.miller@hp.com


The patch titled
     cciss: fix regression that no device nodes are created if no logical drives are configured.
has been added to the -mm tree.  Its filename is
     cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cciss-fix-regression-that-no-device-nodes-are-created-if-no-logical-drives-are-configured.patch

