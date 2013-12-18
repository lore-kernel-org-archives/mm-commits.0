From: akpm@linux-foundation.org
Subject: + rtc-add-hym8563-rtc-driver-fix.patch added to -mm tree
Date: Wed, 18 Dec 2013 13:16:13 -0800
Message-ID: <52b2109d.5QkMN/F/dIjX6OGD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3LRVQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Dec 2013 16:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, fengguang.wu@intel.com, heiko@sntech.de

Subject: + rtc-add-hym8563-rtc-driver-fix.patch added to -mm tree
To: heiko@sntech.de,fengguang.wu@intel.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Wed, 18 Dec 2013 13:16:13 -0800


The patch titled
     Subject: rtc: hym8563: include clkout code only if COMMON_CLK active
has been added to the -mm tree.  Its filename is
     rtc-add-hym8563-rtc-driver-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-hym8563-rtc-driver-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-hym8563-rtc-driver-fix.patch

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

dt-bindings-add-hym8563-binding.patch
rtc-add-hym8563-rtc-driver.patch
rtc-add-hym8563-rtc-driver-fix.patch
linux-next.patch

