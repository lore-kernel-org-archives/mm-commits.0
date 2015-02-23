From: akpm@linux-foundation.org
Subject: + rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch
 added to -mm tree
Date: Mon, 23 Feb 2015 14:58:51 -0800
Message-ID: <54ebb0ab.tNnQ5KoOgVDCT5m2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbBWW6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bos@je-eigen-domein.nl, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: hctosys: do not treat lack of RTC device as error
has been added to the -mm tree.  Its filename is
     rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-hctosys-do-not-treat-lack-of-rtc-device-as-error.patch

