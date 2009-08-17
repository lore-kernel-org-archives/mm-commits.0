From: akpm@linux-foundation.org
Subject: + rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:32:23 -0700
Message-ID: <200908172332.n7HNWNKJ022871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758187AbZHQXc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ospite@studenti.unina.it, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, drwyrm@gmail.com, gmzhuo@gmail.com


The patch titled
     From: Antonio Ospite <ospite@studenti.unina.it>
has been added to the -mm tree.  Its filename is
     rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch

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
Subject: From: Antonio Ospite <ospite@studenti.unina.it>


Right now the pcap core driver passes a reference to its pcap data abusing the
subdrivers platform drvdata, this is not good.

Get the reference directly from the parent device.

This change was suggested by Mark Brown in
http://www.spinics.net/lists/linux-input/msg04285.html

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Cc: guiming zhuo <gmzhuo@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcap.c~rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device
+++ a/drivers/rtc/rtc-pcap.c
@@ -154,7 +154,7 @@ static int __devinit pcap_rtc_probe(stru
 	if (!pcap_rtc)
 		return err;
 
-	pcap_rtc->pcap = platform_get_drvdata(pdev);
+	pcap_rtc->pcap = dev_get_drvdata(pdev->dev.parent);
 
 	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
 				  &pcap_rtc_ops, THIS_MODULE);
_

Patches currently in -mm which might be from ospite@studenti.unina.it are

origin.patch
linux-next.patch
pxa2xx_spi-register-earlier.patch
rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch

