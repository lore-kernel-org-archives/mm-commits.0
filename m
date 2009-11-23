From: akpm@linux-foundation.org
Subject: + rtc-ds1307-make-it-possible-to-share-an-irq.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:31:55 -0800
Message-ID: <200911232131.nANLVtav003245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098AbZKWVbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, a.zummo@towertech.it


The patch titled
     rtc: ds1307 make it possible to share an irq
has been added to the -mm tree.  Its filename is
     rtc-ds1307-make-it-possible-to-share-an-irq.patch

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

linux-next.patch
rtc-ds1307-make-it-possible-to-share-an-irq.patch

