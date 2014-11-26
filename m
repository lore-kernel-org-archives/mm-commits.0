From: akpm@linux-foundation.org
Subject: +
 rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch added
 to -mm tree
Date: Wed, 26 Nov 2014 14:31:44 -0800
Message-ID: <547654d0.I1UoSLb5wvQBXyzv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZWbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 17:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: drop vendor-prefix from power-controller dt property
has been added to the -mm tree.  Its filename is
     rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-omap-fix-clock-source-configuration.patch
rtc-omap-fix-missing-wakealarm-attribute.patch
rtc-omap-fix-interrupt-disable-at-probe.patch
rtc-omap-clean-up-probe-error-handling.patch
rtc-omap-fix-class-device-registration.patch
rtc-omap-remove-unused-register-base-define.patch
rtc-omap-use-dev_info.patch
rtc-omap-make-platform-device-id-table-const.patch
rtc-omap-add-device-abstraction.patch
rtc-omap-remove-driver_name-macro.patch
rtc-omap-add-structured-device-type-info.patch
rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch
rtc-omap-add-helper-to-read-raw-bcd-time.patch
rtc-omap-add-helper-to-read-32-bit-registers.patch
rtc-omap-add-support-for-pmic_power_en.patch
rtc-omap-add-support-for-pmic_power_en-v3.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
rtc-omap-add-support-for-pmic_power_en-v4.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch
linux-next.patch

