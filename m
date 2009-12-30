From: akpm@linux-foundation.org
Subject: + drivers-cpuidle-governors-menuc-fix-undefined-reference-to-__udivdi3.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:37:25 -0800
Message-ID: <200912302137.nBULbP5B003670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbZL3Vik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:38:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, arjan@linux.intel.com, len.brown@intel.com, shemminger@vyatta.com, stable@kernel.org, venkatesh.pallipadi@intel.com


The patch titled
     drivers/cpuidle/governors/menu.c: fix undefined reference to `__udivdi3'
has been added to the -mm tree.  Its filename is
     drivers-cpuidle-governors-menuc-fix-undefined-reference-to-__udivdi3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/cpuidle/governors/menu.c: fix undefined reference to `__udivdi3'
From: Stephen Hemminger <shemminger@linux-foundation.org>

menu: use proper 64 bit math

The new menu governor is incorrectly doing a 64 bit divide.  Compile
tested only

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/cpuidle/governors/menu.c~drivers-cpuidle-governors-menuc-fix-undefined-reference-to-__udivdi3 drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~drivers-cpuidle-governors-menuc-fix-undefined-reference-to-__udivdi3
+++ a/drivers/cpuidle/governors/menu.c
@@ -18,6 +18,7 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 #include <linux/sched.h>
+#include <linux/math64.h>
 
 #define BUCKETS 12
 #define RESOLUTION 1024
@@ -169,6 +170,12 @@ static DEFINE_PER_CPU(struct menu_device
 
 static void menu_update(struct cpuidle_device *dev);
 
+/* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
+static u64 div_round64(u64 dividend, u32 divisor)
+{
+	return div_u64(dividend + (divisor / 2), divisor);
+}
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -209,9 +216,8 @@ static int menu_select(struct cpuidle_de
 		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
 	/* Make sure to round up for half microseconds */
-	data->predicted_us = DIV_ROUND_CLOSEST(
-		data->expected_us * data->correction_factor[data->bucket],
-		RESOLUTION * DECAY);
+	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
+					 RESOLUTION * DECAY);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

drivers-cpuidle-governors-menuc-fix-undefined-reference-to-__udivdi3.patch

