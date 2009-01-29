From: akpm@linux-foundation.org
Subject: + atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found.patch added to -mm tree
Date: Thu, 29 Jan 2009 15:51:03 -0800
Message-ID: <200901292351.n0TNp3aR011626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759514AbZA2Xvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 18:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, dbrownell@users.sourceforge.net, haavard.skinnemoen@atmel.com, kay.sievers@vrfy.org, weiyi.huang@gmail.com


The patch titled
     atmel-ssc: fix misuse of dev_dbg when requested ssc instance is not found
has been added to the -mm tree.  Its filename is
     atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found.patch

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
Subject: atmel-ssc: fix misuse of dev_dbg when requested ssc instance is not found
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

The ssc pointer is not valid when the id is not found in the list. 
Convert the message from a debug one into an error message and avoid
dereferencing the bad pointer.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Huang Weiyi <weiyi.huang@gmail.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel-ssc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/atmel-ssc.c~atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found drivers/misc/atmel-ssc.c
--- a/drivers/misc/atmel-ssc.c~atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found
+++ a/drivers/misc/atmel-ssc.c
@@ -35,7 +35,7 @@ struct ssc_device *ssc_request(unsigned 
 
 	if (!ssc_valid) {
 		spin_unlock(&user_lock);
-		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
+		pr_err("ssc: ssc%d platform device is missing\n", ssc_num);
 		return ERR_PTR(-ENODEV);
 	}
 
_

Patches currently in -mm which might be from hans-christian.egtvedt@atmel.com are

atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found.patch

