From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-make-it-possible-to-share-an-irq.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:02 -0800
Message-ID: <200912162035.nBGKZ2fD013063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935248AbZLPUfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: ds1307 make it possible to share an irq
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-make-it-possible-to-share-an-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: ds1307 make it possible to share an irq
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

It's possible to have RTC irq shared with other device (e.g. 
mpc8349e-mitx board shares ds1339 irq with phy one).  Handle this in
driver.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-make-it-possible-to-share-an-irq drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-make-it-possible-to-share-an-irq
+++ a/drivers/rtc/rtc-ds1307.c
@@ -874,7 +874,7 @@ read_rtc:
 	}
 
 	if (want_irq) {
-		err = request_irq(client->irq, ds1307_irq, 0,
+		err = request_irq(client->irq, ds1307_irq, IRQF_SHARED,
 			  ds1307->rtc->name, client);
 		if (err) {
 			dev_err(&client->dev,
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
linux-next.patch

