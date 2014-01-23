From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-hym8563-rtc-driver-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:27:06 -0800
Message-ID: <52e1a54a.6bIbeN4PX/17QYhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaAWX1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, fengguang.wu@intel.com, heiko@sntech.de

Subject: [folded-merged] rtc-add-hym8563-rtc-driver-fix.patch removed from -mm tree
To: heiko@sntech.de,fengguang.wu@intel.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:27:06 -0800


The patch titled
     Subject: rtc: hym8563: include clkout code only if COMMON_CLK active
has been removed from the -mm tree.  Its filename was
     rtc-add-hym8563-rtc-driver-fix.patch

This patch was dropped because it was folded into rtc-add-hym8563-rtc-driver.patch

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: rtc: hym8563: include clkout code only if COMMON_CLK active

The contents of clk-provide.h, struct clk_hw etc, are only available if
CONFIG_COMMON_CLK is selected.  Therefore IS_ENABLED(COMMON_CLK) is not
sufficient and real preprocessor conditions are necessary to keep the code
in question from being compiled on non-COMMON_CLK systems.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-hym8563.c~rtc-add-hym8563-rtc-driver-fix drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~rtc-add-hym8563-rtc-driver-fix
+++ a/drivers/rtc/rtc-hym8563.c
@@ -87,7 +87,9 @@ struct hym8563 {
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
 	bool			valid;
+#ifdef CONFIG_COMMON_CLK
 	struct clk_hw		clkout_hw;
+#endif
 };
 
 /*
@@ -290,6 +292,7 @@ static const struct rtc_class_ops hym856
  * Handling of the clkout
  */
 
+#ifdef CONFIG_COMMON_CLK
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout_hw)
 
 static int clkout_rates[] = {
@@ -423,6 +426,7 @@ static struct clk *hym8563_clkout_regist
 
 	return clk;
 }
+#endif
 
 /*
  * The alarm interrupt is implemented as a level-low interrupt in the
@@ -565,8 +569,9 @@ static int hym8563_probe(struct i2c_clie
 	if (IS_ERR(hym8563->rtc))
 		return PTR_ERR(hym8563->rtc);
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		hym8563_clkout_register_clk(hym8563);
+#ifdef CONFIG_COMMON_CLK
+	hym8563_clkout_register_clk(hym8563);
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
dt-bindings-add-hym8563-binding.patch
rtc-add-hym8563-rtc-driver.patch

