From: akpm@linux-foundation.org
Subject: [merged]
 rtc-hym8563-add-optional-clock-output-names-property.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:30:32 -0700
Message-ID: <53960b58.qh0PmE0clqyhF1sx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaFITac (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mturquette@linaro.org, heiko@sntech.de

Subject: [merged] rtc-hym8563-add-optional-clock-output-names-property.patch removed from -mm tree
To: heiko@sntech.de,mturquette@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:32 -0700


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: add optional clock-output-names property
has been removed from the -mm tree.  Its filename was
     rtc-hym8563-add-optional-clock-output-names-property.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: drivers/rtc/rtc-hym8563.c: add optional clock-output-names property

This enables the setting of a custom clock name for the clock provided by
the hym8563 rtc.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt |    3 +++
 drivers/rtc/rtc-hym8563.c                               |    3 +++
 2 files changed, 6 insertions(+)

diff -puN Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt~rtc-hym8563-add-optional-clock-output-names-property Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
--- a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt~rtc-hym8563-add-optional-clock-output-names-property
+++ a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
@@ -9,6 +9,9 @@ Required properties:
 - interrupts: rtc alarm/event interrupt
 - #clock-cells: the value should be 0
 
+Optional properties:
+- clock-output-names: From common clock binding
+
 Example:
 
 hym8563: hym8563@51 {
diff -puN drivers/rtc/rtc-hym8563.c~rtc-hym8563-add-optional-clock-output-names-property drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~rtc-hym8563-add-optional-clock-output-names-property
+++ a/drivers/rtc/rtc-hym8563.c
@@ -418,6 +418,9 @@ static struct clk *hym8563_clkout_regist
 	init.num_parents = 0;
 	hym8563->clkout_hw.init = &init;
 
+	/* optional override of the clockname */
+	of_property_read_string(node, "clock-output-names", &init.name);
+
 	/* register the clock */
 	clk = clk_register(&client->dev, &hym8563->clkout_hw);
 
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
linux-next.patch

