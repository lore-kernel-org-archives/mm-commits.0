From: akpm@linux-foundation.org
Subject: + rtc-m48t59-kfreenull-is-ok.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:13:29 -0700
Message-ID: <201006042313.o54NDTFs023886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757289Ab0FDXNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, a.zummo@towertech.it, p_gortmaker@yahoo.com


The patch titled
     rtc/m48t59: kfree(NULL) is OK
has been added to the -mm tree.  Its filename is
     rtc-m48t59-kfreenull-is-ok.patch

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
Subject: rtc/m48t59: kfree(NULL) is OK
From: Wan ZongShun <mcuos.com@gmail.com>

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-kfreenull-is-ok drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-kfreenull-is-ok
+++ a/drivers/rtc/rtc-m48t59.c
@@ -506,7 +506,6 @@ out:
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
 		iounmap(m48t59->ioaddr);
-	if (m48t59)
 		kfree(m48t59);
 	return ret;
 }
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch

