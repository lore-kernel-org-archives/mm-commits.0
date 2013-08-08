From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch added to
 -mm tree
Date: Thu, 08 Aug 2013 15:01:49 -0700
Message-ID: <5204154d.V0TrqvtCFt63pVVt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3HHWBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, balbi@ti.com, ldewangan@nvidia.com

Subject: + drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch added to -mm tree
To: ldewangan@nvidia.com,balbi@ti.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:01:49 -0700


The patch titled
     Subject: drivers/rtc/rtc-palmas.c: support for backup battery charging
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch

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
Subject: drivers/rtc/rtc-palmas.c: support for backup battery charging

Palmas series device like TPS65913, TPS80036 supports the backup battery
for powering the RTC when no other energy source is available.

The backup battery is optional, connected to the VBACKUP pin, and can be
nonrechargeable or rechargeable.  The rechargeable battery can be charged
from the system supply using the backup battery charger.

Add support for enabling charging of this backup battery.  Also add the DT
binding document and the new properties to have this support.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-palmas.txt |   29 ++++++++
 drivers/rtc/rtc-palmas.c                             |   35 ++++++++++
 2 files changed, 64 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/rtc-palmas.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
@@ -0,0 +1,29 @@
+Palmas RTC controller bindings
+
+Required properties:
+- compatible:
+  - "ti,palmas-rtc" for palma series of the RTC controller
+- interrupt-parent: Parent interrupt device, must be handle of palmas node.
+- interrupts: Interrupt number of RTC submodule on device.
+
+Optional properties:
+- ti,back-battery-charge-enable: The palmas series device like TPS65913 or
+	TPS80036 supports the battery backup for powering the RTC when main
+	battery is removed or in very low power state. This flag will enable
+	the backup battery charging.
+- ti,back-battery-charge-low-current: Configure lower charging current. Device
+	supports the charging current as < 100mA or >100mA. Low current will
+	set as <100mA.
+
+Example:
+	palmas: tps65913@58 {
+		...
+		palmas_rtc: rtc {
+			compatible = "ti,palmas-rtc";
+			interrupt-parent = <&palmas>;
+			interrupts = <8 0>;
+			ti,back-battery-charge-enable;
+			ti,back-battery-charge-low-current;
+		};
+		...
+	};
diff -puN drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging drivers/rtc/rtc-palmas.c
--- a/drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-support-for-backup-battery-charging
+++ a/drivers/rtc/rtc-palmas.c
@@ -238,6 +238,15 @@ static int palmas_rtc_probe(struct platf
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_rtc *palmas_rtc = NULL;
 	int ret;
+	bool enable_bb_charging = false;
+	bool low_bb_charging;
+
+	if (pdev->dev.of_node) {
+		enable_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,back-battery-charge-enable");
+		low_bb_charging = of_property_read_bool(pdev->dev.of_node,
+					"ti,back-battery-charge-low-current");
+	}
 
 	palmas_rtc = devm_kzalloc(&pdev->dev, sizeof(struct palmas_rtc),
 			GFP_KERNEL);
@@ -254,6 +263,32 @@ static int palmas_rtc_probe(struct platf
 	palmas_rtc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, palmas_rtc);
 
+	if (enable_bb_charging) {
+		unsigned reg = 0;
+
+		if (low_bb_charging)
+			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
+
+		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+			PALMAS_BACKUP_BATTERY_CTRL,
+			PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG, reg);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
+			return ret;
+		}
+
+		ret = palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
+			PALMAS_BACKUP_BATTERY_CTRL,
+			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN,
+			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
+			return ret;
+		}
+	}
+
 	/* Start RTC */
 	ret = palmas_update_bits(palmas, PALMAS_RTC_BASE, PALMAS_RTC_CTRL_REG,
 			PALMAS_RTC_CTRL_REG_STOP_RTC,
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

drivers-rtc-rtc-palmasc-support-for-backup-battery-charging.patch
linux-next.patch

