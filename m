From: akpm@linux-foundation.org
Subject: + rtc-do-not-mark-pl031-irq-as-shared.patch added to -mm tree
Date: Tue, 07 Sep 2010 15:57:16 -0700
Message-ID: <201009072257.o87MvGRh011494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab0IGW5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 18:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@stericsson.com, a.zummo@towertech.it, jonas.aberg@stericsson.com, mian.yousaf.kaukab@stericsson.com


The patch titled
     drivers/rtc/rtc-pl031.c: do not mark PL031 IRQ as shared
has been added to the -mm tree.  Its filename is
     rtc-do-not-mark-pl031-irq-as-shared.patch

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
Subject: drivers/rtc/rtc-pl031.c: do not mark PL031 IRQ as shared
From: Linus Walleij <linus.walleij@stericsson.com>

It was a mistake to mark the PL031 IRQ as shared (for the U8500),
we misread the datasheet. Get rid of this.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Jonas Aberg <jonas.aberg@stericsson.com>
Cc: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pl031.c~rtc-do-not-mark-pl031-irq-as-shared drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-do-not-mark-pl031-irq-as-shared
+++ a/drivers/rtc/rtc-pl031.c
@@ -403,7 +403,7 @@ static int pl031_probe(struct amba_devic
 	}
 
 	if (request_irq(adev->irq[0], pl031_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "rtc-pl031", ldata)) {
+			IRQF_DISABLED, "rtc-pl031", ldata)) {
 		ret = -EIO;
 		goto out_no_irq;
 	}
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

linux-next.patch
rtc-do-not-mark-pl031-irq-as-shared.patch
mmc-mmc-44-ddr-support.patch
checkpatch-check-for-incorrect-permissions.patch

