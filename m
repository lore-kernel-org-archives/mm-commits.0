From: akpm@linux-foundation.org
Subject: [merged] rtc-spear-add-device-tree-probing-capability.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:17 -0700
Message-ID: <20120531192017.898D9A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41454 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2EaTUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:18 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so154855qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, a.zummo@towertech.it, arnd@arndb.de, rajeev-dlh.kumar@st.com, robherring2@gmail.com, sr@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/spear: add Device Tree probing capability
has been removed from the -mm tree.  Its filename was
     rtc-spear-add-device-tree-probing-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: rtc/spear: add Device Tree probing capability

SPEAr platforms now support DT and so must convert all drivers support DT.
 This patch adds DT probing support for rtc and updates its documentation
too.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Stefan Roese <sr@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Cc: Rob Herring <robherring2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/spear-rtc.txt |   18 ++++++++++
 drivers/rtc/rtc-spear.c                             |   10 +++++
 2 files changed, 28 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/spear-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/spear-rtc.txt
@@ -0,0 +1,18 @@
+* SPEAr RTC
+
+Required properties:
+- compatible : "st,spear600-rtc"
+- reg : Address range of the rtc registers
+- interrupt-parent: Should be the phandle for the interrupt controller
+  that services interrupts for this device
+- interrupt: Should contain the rtc interrupt number
+
+Example:
+
+	rtc@fc000000 {
+		compatible = "st,spear600-rtc";
+		reg = <0xfc000000 0x1000>;
+		interrupt-parent = <&vic1>;
+		interrupts = <12>;
+	};
+
diff -puN drivers/rtc/rtc-spear.c~rtc-spear-add-device-tree-probing-capability drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-spear-add-device-tree-probing-capability
+++ a/drivers/rtc/rtc-spear.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
@@ -519,6 +520,14 @@ static void spear_rtc_shutdown(struct pl
 	clk_disable(config->clk);
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id spear_rtc_id_table[] = {
+	{ .compatible = "st,spear600-rtc" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, spear_rtc_id_table);
+#endif
+
 static struct platform_driver spear_rtc_driver = {
 	.probe = spear_rtc_probe,
 	.remove = __devexit_p(spear_rtc_remove),
@@ -527,6 +536,7 @@ static struct platform_driver spear_rtc_
 	.shutdown = spear_rtc_shutdown,
 	.driver = {
 		.name = "rtc-spear",
+		.of_match_table = of_match_ptr(spear_rtc_id_table),
 	},
 };
 
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch

