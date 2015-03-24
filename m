From: akpm@linux-foundation.org
Subject: + clk-bcm-kona-use-div_round_closest_ull.patch added to -mm tree
Date: Tue, 24 Mar 2015 14:01:29 -0700
Message-ID: <5511d0a9.gMABxG8XjSI3nniD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbCXVBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:01:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, elder@linaro.org, mturquette@linaro.org, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: bcm/kona: use DIV_ROUND_CLOSEST_ULL()
has been added to the -mm tree.  Its filename is
     clk-bcm-kona-use-div_round_closest_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clk-bcm-kona-use-div_round_closest_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clk-bcm-kona-use-div_round_closest_ull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javi Merino <javi.merino@arm.com>
Subject: clk: bcm/kona: use DIV_ROUND_CLOSEST_ULL()

Now that the kernel provides DIV_ROUND_CLOSEST_ULL(), drop the internal
implementation and use the kernel one.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alex Elder <elder@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/bcm/clk-kona.c |   28 +++++++---------------------
 drivers/clk/bcm/clk-kona.h |    1 -
 2 files changed, 7 insertions(+), 22 deletions(-)

diff -puN drivers/clk/bcm/clk-kona.c~clk-bcm-kona-use-div_round_closest_ull drivers/clk/bcm/clk-kona.c
--- a/drivers/clk/bcm/clk-kona.c~clk-bcm-kona-use-div_round_closest_ull
+++ a/drivers/clk/bcm/clk-kona.c
@@ -15,6 +15,7 @@
 #include "clk-kona.h"
 
 #include <linux/delay.h>
+#include <linux/kernel.h>
 
 /*
  * "Policies" affect the frequencies of bus clocks provided by a
@@ -51,21 +52,6 @@ static inline u32 bitfield_replace(u32 r
 
 /* Divider and scaling helpers */
 
-/*
- * Implement DIV_ROUND_CLOSEST() for 64-bit dividend and both values
- * unsigned.  Note that unlike do_div(), the remainder is discarded
- * and the return value is the quotient (not the remainder).
- */
-u64 do_div_round_closest(u64 dividend, unsigned long divisor)
-{
-	u64 result;
-
-	result = dividend + ((u64)divisor >> 1);
-	(void)do_div(result, divisor);
-
-	return result;
-}
-
 /* Convert a divider into the scaled divisor value it represents. */
 static inline u64 scaled_div_value(struct bcm_clk_div *div, u32 reg_div)
 {
@@ -87,7 +73,7 @@ u64 scaled_div_build(struct bcm_clk_div
 	combined = (u64)div_value * BILLION + billionths;
 	combined <<= div->u.s.frac_width;
 
-	return do_div_round_closest(combined, BILLION);
+	return DIV_ROUND_CLOSEST_ULL(combined, BILLION);
 }
 
 /* The scaled minimum divisor representable by a divider */
@@ -731,7 +717,7 @@ static unsigned long clk_recalc_rate(str
 		scaled_rate = scale_rate(pre_div, parent_rate);
 		scaled_rate = scale_rate(div, scaled_rate);
 		scaled_div = divider_read_scaled(ccu, pre_div);
-		scaled_parent_rate = do_div_round_closest(scaled_rate,
+		scaled_parent_rate = DIV_ROUND_CLOSEST_ULL(scaled_rate,
 							scaled_div);
 	} else  {
 		scaled_parent_rate = scale_rate(div, parent_rate);
@@ -743,7 +729,7 @@ static unsigned long clk_recalc_rate(str
 	 * rate.
 	 */
 	scaled_div = divider_read_scaled(ccu, div);
-	result = do_div_round_closest(scaled_parent_rate, scaled_div);
+	result = DIV_ROUND_CLOSEST_ULL(scaled_parent_rate, scaled_div);
 
 	return (unsigned long)result;
 }
@@ -790,7 +776,7 @@ static long round_rate(struct ccu_data *
 		scaled_rate = scale_rate(pre_div, parent_rate);
 		scaled_rate = scale_rate(div, scaled_rate);
 		scaled_pre_div = divider_read_scaled(ccu, pre_div);
-		scaled_parent_rate = do_div_round_closest(scaled_rate,
+		scaled_parent_rate = DIV_ROUND_CLOSEST_ULL(scaled_rate,
 							scaled_pre_div);
 	} else {
 		scaled_parent_rate = scale_rate(div, parent_rate);
@@ -802,7 +788,7 @@ static long round_rate(struct ccu_data *
 	 * the best we can do.
 	 */
 	if (!divider_is_fixed(div)) {
-		best_scaled_div = do_div_round_closest(scaled_parent_rate,
+		best_scaled_div = DIV_ROUND_CLOSEST_ULL(scaled_parent_rate,
 							rate);
 		min_scaled_div = scaled_div_min(div);
 		max_scaled_div = scaled_div_max(div);
@@ -815,7 +801,7 @@ static long round_rate(struct ccu_data *
 	}
 
 	/* OK, figure out the resulting rate */
-	result = do_div_round_closest(scaled_parent_rate, best_scaled_div);
+	result = DIV_ROUND_CLOSEST_ULL(scaled_parent_rate, best_scaled_div);
 
 	if (scaled_div)
 		*scaled_div = best_scaled_div;
diff -puN drivers/clk/bcm/clk-kona.h~clk-bcm-kona-use-div_round_closest_ull drivers/clk/bcm/clk-kona.h
--- a/drivers/clk/bcm/clk-kona.h~clk-bcm-kona-use-div_round_closest_ull
+++ a/drivers/clk/bcm/clk-kona.h
@@ -503,7 +503,6 @@ extern struct clk_ops kona_peri_clk_ops;
 
 /* Externally visible functions */
 
-extern u64 do_div_round_closest(u64 dividend, unsigned long divisor);
 extern u64 scaled_div_max(struct bcm_clk_div *div);
 extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
 				u32 billionths);
_

Patches currently in -mm which might be from javi.merino@arm.com are

kernelh-implement-div_round_closest_ull.patch
clk-bcm-kona-use-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
media-cxd2820r-use-div_round_closest_ull.patch
linux-next.patch

