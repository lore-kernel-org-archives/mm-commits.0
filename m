From: akpm@linux-foundation.org
Subject: [merged]
 rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:45 -0800
Message-ID: <5489eb81.WlpVuMexpRnq47hB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: drop vendor-prefix from power-controller dt property
has been removed from the -mm tree.  Its filename was
     rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: drop vendor-prefix from power-controller dt property

Drop the vendor-prefix from the "ti,system-power-controller" device-tree
property name.

It has been agreed to make "system-power-controller" a standard property
and to drop the vendor-prefix that is currently used by several drivers.

Note that drivers that have used "<vendor>,system-power-controller" in a
released kernel will need to support both versions.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    4 ++--
 arch/arm/boot/dts/am335x-boneblack.dts             |    2 +-
 drivers/rtc/rtc-omap.c                             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/rtc-omap.txt~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property Documentation/devicetree/bindings/rtc/rtc-omap.txt
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property
+++ a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -13,7 +13,7 @@ Required properties:
 - interrupt-parent: phandle for the interrupt controller
 
 Optional properties:
-- ti,system-power-controller: whether the rtc is controlling the system power
+- system-power-controller: whether the rtc is controlling the system power
   through pmic_power_en
 
 Example:
@@ -24,5 +24,5 @@ rtc@1c23000 {
 	interrupts = <19
 		      19>;
 	interrupt-parent = <&intc>;
-	ti,system-power-controller;
+	system-power-controller;
 };
diff -puN arch/arm/boot/dts/am335x-boneblack.dts~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property arch/arm/boot/dts/am335x-boneblack.dts
--- a/arch/arm/boot/dts/am335x-boneblack.dts~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property
+++ a/arch/arm/boot/dts/am335x-boneblack.dts
@@ -82,5 +82,5 @@
 };
 
 &rtc {
-	ti,system-power-controller;
+	system-power-controller;
 };
diff -puN drivers/rtc/rtc-omap.c~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-drop-vendor-prefix-from-power-controller-dt-property
+++ a/drivers/rtc/rtc-omap.c
@@ -502,7 +502,7 @@ static int __init omap_rtc_probe(struct
 		rtc->type = of_id->data;
 		rtc->is_pmic_controller = rtc->type->has_pmic_mode &&
 				of_property_read_bool(pdev->dev.of_node,
-						"ti,system-power-controller");
+						"system-power-controller");
 	} else {
 		id_entry = platform_get_device_id(pdev);
 		rtc->type = (void *)id_entry->driver_data;
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

