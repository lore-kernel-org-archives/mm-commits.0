From: akpm@linux-foundation.org
Subject: [folded] rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:48:24 -0700
Message-ID: <200909222148.n8MLmO9s010418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbZIVVtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ospite@studenti.unina.it, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, drwyrm@gmail.com, gmzhuo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     From: Antonio Ospite <ospite@studenti.unina.it>
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch

This patch was dropped because it was folded into rtc-driver-for-pcap2-pmic.patch

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
pxa2xx_spi-register-earlier.patch
rtc-driver-for-pcap2-pmic.patch
rtc-driver-for-pcap2-pmic-get-pcap-data-from-the-parent-device.patch

