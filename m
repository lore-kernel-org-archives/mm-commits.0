From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch added to -mm tree
Date: Fri, 20 Nov 2009 14:48:50 -0800
Message-ID: <200911202248.nAKMmojf002768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129AbZKTWsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 17:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, p_gortmaker@yahoo.com


The patch titled
     drivers/rtc/rtc-pcf50633.c: fix use after free in pcf50633_rtc_probe()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch

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
Subject: drivers/rtc/rtc-pcf50633.c: fix use after free in pcf50633_rtc_probe()
From: Dan Carpenter <error27@gmail.com>

"rtc" is freed and then dereferenced on the next line.  This patch fixes
that.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf50633.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -289,8 +289,9 @@ static int __devinit pcf50633_rtc_probe(
 				&pcf50633_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc->rtc_dev)) {
+		int ret =  PTR_ERR(rtc->rtc_dev);
 		kfree(rtc);
-		return PTR_ERR(rtc->rtc_dev);
+		return ret;
 	}
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
_

Patches currently in -mm which might be from error27@gmail.com are

drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch
linux-next.patch

