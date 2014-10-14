From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-remove-unneded-info-log.patch removed from
 -mm tree
Date: Tue, 14 Oct 2014 11:20:44 -0700
Message-ID: <543d697c.PUkv+qL5O3Nsk6io%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, a.zummo@towertech.it, dianders@chromium.org, k.kozlowski@samsung.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: remove unneeded info log
has been removed from the -mm tree.  Its filename was
     rtc-max77686-remove-unneded-info-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: rtc: max77686: remove unneeded info log

If devm_rtc_device_register() fails a dev_err() is already reported so
there is no need to do an additional dev_info().

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-remove-unneded-info-log drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-remove-unneded-info-log
+++ a/drivers/rtc/rtc-max77686.c
@@ -457,8 +457,6 @@ static int max77686_rtc_probe(struct pla
 					&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
-		dev_info(&pdev->dev, "%s: fail\n", __func__);
