From: akpm@linux-foundation.org
Subject: [merged] atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:13 -0800
Message-ID: <200902061938.n16JcD5R012073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbZBFTiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hans-christian.egtvedt@atmel.com, dbrownell@users.sourceforge.net, haavard.skinnemoen@atmel.com, kay.sievers@vrfy.org, weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atmel-ssc: fix misuse of dev_dbg when requested ssc instance is not found
has been removed from the -mm tree.  Its filename was
     atmel-ssc-fix-misuse-of-dev_dbg-when-requested-ssc-instance-is-not-found.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
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

origin.patch
linux-next.patch

