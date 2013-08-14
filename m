From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch added to -mm tree
Date: Wed, 14 Aug 2013 16:06:26 -0700
Message-ID: <520c0d72.J3vJAdIUt+Ko9i2p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab3HNXG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, galak@codeaurora.org, balbi@ti.com, ldewangan@nvidia.com

Subject: + drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch added to -mm tree
To: ldewangan@nvidia.com,balbi@ti.com,galak@codeaurora.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:06:26 -0700


The patch titled
     Subject: drivers/rtc/rtc-palmas.c: rename charging dt property name
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-palmas.c: rename charging dt property name

Rename the charging property names to be more meaningful:

Rename property "ti,back-battery-charge-enable" to
"ti,backup-battery-chargeable" to tells OS that attahced battery is
chargeable and OS can do charging.

Rename property "ti,back-battery-charge-low-current" to
"ti,backup-battery-charge-high-current" for safe configuration as maximum
charging current of battery depends on battery type and overcurrent
charging can damage the battery.  So enable the high current charging only
if this property is available.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
Acked-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-palmas.txt |   22 +++++-----
 drivers/rtc/rtc-palmas.c                             |   14 +++---
 2 files changed, 20 insertions(+), 16 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/rtc-palmas.txt~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix Documentation/devicetree/bindings/rtc/rtc-palmas.txt
--- a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix
+++ a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
@@ -7,13 +7,17 @@ Required properties:
 - interrupts: Interrupt number of RTC submodule on device.
 
 Optional properties:
-- ti,back-battery-charge-enable: The palmas series device like TPS65913 or
-	TPS80036 supports the battery backup for powering the RTC when main
-	battery is removed or in very low power state. This flag will enable
-	the backup battery charging.
-- ti,back-battery-charge-low-current: Configure lower charging current. Device
-	supports the charging current as < 100mA or >100mA. Low current will
-	set as <100mA.
+
+- ti,backup-battery-chargeable: The Palmas series device like TPS65913 or
+	TPS80036 supports the backup battery for powering the RTC when main
+	battery is removed or in very low power state. The backup battery
+	can be chargeable or non-chargeable. This flag will tells whether
+	battery is chargeable or not. If charging battery then driver can
+	enable the charging.
+- ti,backup-battery-charge-high-current: Enable high current charging in
+	backup battery. Device supports the < 100mA and > 100mA charging.
+	The high current will be > 100mA. Absence of this property will
+	charge battery to lower current i.e. < 100mA.
 
 Example:
 	palmas: tps65913@58 {
@@ -22,8 +26,8 @@ Example:
 			compatible = "ti,palmas-rtc";
 			interrupt-parent = <&palmas>;
 			interrupts = <8 0>;
-			ti,back-battery-charge-enable;
-			ti,back-battery-charge-low-current;
+			ti,backup-battery-chargeable;
+			ti,backup-battery-charge-high-current;
 		};
 		...
 	};
diff -puN drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix drivers/rtc/rtc-palmas.c
--- a/drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix
+++ a/drivers/rtc/rtc-palmas.c
@@ -239,13 +239,13 @@ static int palmas_rtc_probe(struct platf
 	struct palmas_rtc *palmas_rtc = NULL;
 	int ret;
 	bool enable_bb_charging = false;
-	bool low_bb_charging;
+	bool high_bb_charging;
 
 	if (pdev->dev.of_node) {
 		enable_bb_charging = of_property_read_bool(pdev->dev.of_node,
-					"ti,back-battery-charge-enable");
-		low_bb_charging = of_property_read_bool(pdev->dev.of_node,
-					"ti,back-battery-charge-low-current");
+					"ti,backup-battery-chargeable");
+		high_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,backup-battery-charge-high-current");
 	}
 
 	palmas_rtc = devm_kzalloc(&pdev->dev, sizeof(struct palmas_rtc),
@@ -264,10 +264,10 @@ static int palmas_rtc_probe(struct platf
 	platform_set_drvdata(pdev, palmas_rtc);
 
 	if (enable_bb_charging) {
-		unsigned reg = 0;
+		unsigned reg = PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
 
-		if (low_bb_charging)
-			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
+		if (high_bb_charging)
+			reg = 0;
 
 		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
 			PALMAS_BACKUP_BATTERY_CTRL,
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch
drivers-rtc-rtc-palmasc-support-for-backup-battery-charging-fix.patch
linux-next.patch

