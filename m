From: akpm@linux-foundation.org
Subject: - radeonfb-give-i2c-buses-nicer-names.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:55 -0700
Message-ID: <200808062056.m76KutfN014718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232AbYHFVBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: give i2c buses nicer names
has been removed from the -mm tree.  Its filename was
     radeonfb-give-i2c-buses-nicer-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

