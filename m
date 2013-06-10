From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-fix-rtc_reg_map-initialization.patch added to -mm tree
Date: Mon, 10 Jun 2013 14:49:24 -0700
Message-ID: <51b649e4.kz7yi/eXi696UO/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3FJVtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 17:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, grygorii.strashko@ti.com, chf.fritz@googlemail.com, peter.ujfalusi@ti.com

Subject: + drivers-rtc-rtc-twlc-fix-rtc_reg_map-initialization.patch added to -mm tree
To: peter.ujfalusi@ti.com,chf.fritz@googlemail.com,grygorii.strashko@ti.com,khilman@linaro.org
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 14:49:24 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix rtc_reg_map initialization
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-fix-rtc_reg_map-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: drivers/rtc/rtc-twl.c: fix rtc_reg_map initialization

Initialize the rtc_reg_map in platform_driver's probe function instead at
module_init time.  This way we can make sure that the twl-core has been
already probed and initialized (twl_priv->twl_id is valid) since the
platform device for the RTC driver will be created by the twl-core after
it finished its init.

Reported-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-rtc_reg_map-initialization drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-rtc_reg_map-initialization
+++ a/drivers/rtc/rtc-twl.c
@@ -481,6 +481,12 @@ static int twl_rtc_probe(struct platform
 	if (irq <= 0)
 		goto out1;
 
+	/* Initialize the register map */
+	if (twl_class_is_4030())
+		rtc_reg_map = (u8 *)twl4030_rtc_reg_map;
+	else
+		rtc_reg_map = (u8 *)twl6030_rtc_reg_map;
+
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
 		goto out1;
@@ -622,11 +628,6 @@ static struct platform_driver twl4030rtc
 
 static int __init twl_rtc_init(void)
 {
-	if (twl_class_is_4030())
-		rtc_reg_map = (u8 *) twl4030_rtc_reg_map;
-	else
-		rtc_reg_map = (u8 *) twl6030_rtc_reg_map;
