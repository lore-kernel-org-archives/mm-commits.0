From: akpm@linux-foundation.org
Subject: - atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:05 -0700
Message-ID: <200807242326.m6ONQ5as010943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbYGXX0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hans-christian.egtvedt@atmel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     atmel_pwm: set up only one PWM clock when allocating a clock
has been removed from the -mm tree.  Its filename was
     atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_pwm: set up only one PWM clock when allocating a clock
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

This patch will only setup one clock, if free, and return this clock to the
caller.  The previous solution would setup both clocks with the same prescaler
and divider and return PWM_CPR_CLKB, thus taking both clocks in the same call
without the caller knowing.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel_pwm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/misc/atmel_pwm.c~atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock drivers/misc/atmel_pwm.c
--- a/drivers/misc/atmel_pwm.c~atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock
+++ a/drivers/misc/atmel_pwm.c
@@ -211,8 +211,7 @@ int pwm_clk_alloc(unsigned prescale, uns
 	if ((mr & 0xffff) == 0) {
 		mr |= val;
 		ret = PWM_CPR_CLKA;
-	}
-	if ((mr & (0xffff << 16)) == 0) {
+	} else if ((mr & (0xffff << 16)) == 0) {
 		mr |= val << 16;
 		ret = PWM_CPR_CLKB;
 	}
_

Patches currently in -mm which might be from hans-christian.egtvedt@atmel.com are

origin.patch
linux-next.patch

