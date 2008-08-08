From: akpm@linux-foundation.org
Subject: + matroxfb-i2c-structure-templates-clean-up.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:05:18 -0700
Message-ID: <200808082105.m78L5Ije028496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbYHHVGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, VANDROVE@vc.cvut.cz, krzysztof.h1@wp.pl


The patch titled
     matroxfb: i2c structure templates clean-up
has been added to the -mm tree.  Its filename is
     matroxfb-i2c-structure-templates-clean-up.patch

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
Subject: matroxfb: i2c structure templates clean-up
From: Jean Delvare <khali@linux-fr.org>

Clean up the use of structure templates in i2c-matroxfb. In this case
it's more efficient to initialize the few fields we need individually.
This makes i2c-matroxfb.ko 16% smaller on my system.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/i2c-matroxfb.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/video/matrox/i2c-matroxfb.c~matroxfb-i2c-structure-templates-clean-up drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~matroxfb-i2c-structure-templates-clean-up
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -87,13 +87,7 @@ static int matroxfb_gpio_getscl(void* da
 	return (matroxfb_read_gpio(b->minfo) & b->mask.clock) ? 1 : 0;
 }
 
-static struct i2c_adapter matrox_i2c_adapter_template =
-{
-	.owner =	THIS_MODULE,
-	.id =		I2C_HW_B_G400,
-};
-
-static struct i2c_algo_bit_data matrox_i2c_algo_template =
+static const struct i2c_algo_bit_data matrox_i2c_algo_template =
 {
 	.setsda		= matroxfb_gpio_setsda,
 	.setscl		= matroxfb_gpio_setscl,
@@ -112,7 +106,8 @@ static int i2c_bus_reg(struct i2c_bit_ad
 	b->minfo = minfo;
 	b->mask.data = data;
 	b->mask.clock = clock;
-	b->adapter = matrox_i2c_adapter_template;
+	b->adapter.owner = THIS_MODULE;
+	b->adapter.id = I2C_HW_B_G400;
 	snprintf(b->adapter.name, sizeof(b->adapter.name), name,
 		minfo->fbcon.node);
 	i2c_set_adapdata(&b->adapter, b);
_

Patches currently in -mm which might be from khali@linux-fr.org are

matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-renesas-highlander-fpga-smbus-support-update.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
applesmc-support-for-intel-imac.patch
applesmc-add-support-for-macbook-v3.patch
hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
i5k_amb-provide-labels-for-temperature-sensors.patch
abituguru3-update-maintainers.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

