From: akpm@linux-foundation.org
Subject: + rtc-spear-add-device-tree-probing-capability.patch added to -mm tree
Date: Mon, 26 Mar 2012 15:05:31 -0700
Message-ID: <20120326220532.5CB2DA0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42186 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZWFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 18:05:33 -0400
Received: by qabg24 with SMTP id g24so355230qab.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 15:05:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, a.zummo@towertech.it, arnd@arndb.de, rajeev-dlh.kumar@st.com, robherring2@gmail.com, sr@denx.de


The patch titled
     Subject: rtc/spear: add Device Tree probing capability
has been added to the -mm tree.  Its filename is
     rtc-spear-add-device-tree-probing-capability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc/spear: add Device Tree probing capability

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch
rtc-spear-add-device-tree-probing-capability.patch

