From: akpm@linux-foundation.org
Subject: + pps-fix-incorrect-verdict-check.patch added to -mm tree
Date: Wed, 19 Aug 2009 13:46:32 -0700
Message-ID: <200908192046.n7JKkWB8002990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbZHSUqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 16:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joonwpark81@gmail.com, giometti@enneenne.com


The patch titled
     pps: fix incorrect verdict check
has been added to the -mm tree.  Its filename is
     pps-fix-incorrect-verdict-check.patch

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
Subject: pps: fix incorrect verdict check
From: Joonwoo Park <joonwpark81@gmail.com>

Fix incorrect verdict check and returns error if device_create failed,
otherwise driver triggers kernel oops.

Signed-off-by: Joonwoo Park<joonwpark81@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/pps.c~pps-fix-incorrect-verdict-check drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-fix-incorrect-verdict-check
+++ a/drivers/pps/pps.c
@@ -244,7 +244,7 @@ int pps_register_cdev(struct pps_device 
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, pps->devno, NULL,
 							"pps%d", pps->id);
-	if (err)
+	if (IS_ERR(pps->dev))
 		goto del_cdev;
 	dev_set_drvdata(pps->dev, pps);
 
_

Patches currently in -mm which might be from joonwpark81@gmail.com are

pps-fix-incorrect-verdict-check.patch

