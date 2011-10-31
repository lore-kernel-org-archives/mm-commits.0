From: akpm@linux-foundation.org
Subject: [folded] leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:52:25 -0700
Message-ID: <201110312352.p9VNqPgm009536@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@google.com, axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix
has been removed from the -mm tree.  Its filename was
     leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch

This patch was dropped because it was folded into leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@google.com>
Subject: leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix

remove unneeded "ret |="

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix
+++ a/drivers/leds/leds-lp5521.c
@@ -182,9 +182,7 @@ static int lp5521_set_engine_mode(struct
 	engine_state &= ~(engine->engine_mask);
 	mode &= engine->engine_mask;
 	engine_state |= mode;
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
