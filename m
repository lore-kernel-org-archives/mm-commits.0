From: akpm@linux-foundation.org
Subject: [merged]
 rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:39 -0700
Message-ID: <553550d3.9BxUZChBwX0GcpIz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbDTTLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bos@je-eigen-domein.nl, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: hctosys: do not treat lack of RTC device as error
has been removed from the -mm tree.  Its filename was
     rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Floris Bos <bos@je-eigen-domein.nl>
Subject: rtc: hctosys: do not treat lack of RTC device as error

When using device trees on the ARM platform, it is not certain at compile
time whether or not the system will have a RTC.

If one enables CONFIG_HCTOSYS just in case the system booted has a RTC,
and it turns out not to be, this will result in a big fat "unable to open
rtc device" error being printed to console, even when "quiet" is set in
the kernel cmdline.

Fix this by outputting the message with loglevel info instead.

Signed-off-by: Floris Bos <bos@je-eigen-domein.nl>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/hctosys.c~rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error
+++ a/drivers/rtc/hctosys.c
@@ -32,7 +32,7 @@ static int __init rtc_hctosys(void)
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
-		pr_err("%s: unable to open rtc device (%s)\n",
+		pr_info("%s: unable to open rtc device (%s)\n",
 			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
 		goto err_open;
 	}
_

Patches currently in -mm which might be from bos@je-eigen-domein.nl are

origin.patch

