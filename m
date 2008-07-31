From: akpm@linux-foundation.org
Subject: + radeonfb-give-i2c-buses-nicer-names.patch added to -mm tree
Date: Thu, 31 Jul 2008 01:56:17 -0700
Message-ID: <200807310856.m6V8uHeL013969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbYGaI4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 04:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, benh@kernel.crashing.org


The patch titled
     radeonfb: give i2c buses nicer names
has been added to the -mm tree.  Its filename is
     radeonfb-give-i2c-buses-nicer-names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: give i2c buses nicer names
From: Jean Delvare <khali@linux-fr.org>

The name of the i2c buses shows in the output of "i2cdetect -l", so
it's important to give informative names.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_i2c.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-give-i2c-buses-nicer-names drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-give-i2c-buses-nicer-names
+++ a/drivers/video/aty/radeon_i2c.c
@@ -69,7 +69,8 @@ static int radeon_setup_i2c_bus(struct r
 {
 	int rc;
 
-	strcpy(chan->adapter.name, name);
+	snprintf(chan->adapter.name, sizeof(chan->adapter.name),
+		 "radeonfb %s", name);
 	chan->adapter.owner		= THIS_MODULE;
 	chan->adapter.id		= I2C_HW_B_RADEON;
 	chan->adapter.algo_data		= &chan->algo;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
dev_printk-constify-the-dev-argument.patch
i2c-renesas-highlander-fpga-smbus-support.patch
applesmc-support-for-intel-imac.patch
applesmc-add-support-for-macbook-v3.patch
hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
i5k_amb-provide-labels-for-temperature-sensors.patch
radeonfb-give-i2c-buses-nicer-names.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

