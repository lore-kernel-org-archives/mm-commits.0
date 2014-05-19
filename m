From: akpm@linux-foundation.org
Subject: + rtc-hym8563-add-optional-clock-output-names-property.patch
 added to -mm tree
Date: Mon, 19 May 2014 15:20:30 -0700
Message-ID: <537a83ae.atWCngL3nkLu40Ip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaESWUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, heiko@sntech.de

Subject: + rtc-hym8563-add-optional-clock-output-names-property.patch added to -mm tree
To: heiko@sntech.de
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:20:30 -0700


The patch titled
     /rtc/rtc-hym8563.c: add optional clock-output-names property
has been added to the -mm tree.  Its filename is
     rtc-hym8563-add-optional-clock-output-names-property.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-hym8563-add-optional-clock-output-names-property.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-hym8563-add-optional-clock-output-names-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
/rtc/rtc-hym8563.c: add optional clock-output-names property

This enables the setting of a custom clock name for the clock provided by
the hym8563 rtc.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
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
rtc-rtc-hym8563-make-of_device_id-array-const.patch
rtc-hym8563-add-optional-clock-output-names-property.patch
linux-next.patch

