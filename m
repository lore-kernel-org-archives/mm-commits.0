From: akpm@linux-foundation.org
Subject: [merged] leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:23 -0700
Message-ID: <201111012115.pA1LFN88008964@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to LP5521_REG_OP_MODE register
has been removed from the -mm tree.  Its filename was
     leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to LP5521_REG_OP_MODE register

If lp5521_read fails, engine_state variable is not initialized.
If lp5521_read fails, we should return error.
This patch fixes below warning.

  CC      drivers/leds/leds-lp5521.o
drivers/leds/leds-lp5521.c: In function 'lp5521_set_engine_mode':
drivers/leds/leds-lp5521.c:168: warning: 'engine_state' may be used uninitialized in this function

[akpm@linux-foundation.org: remove unneeded "ret |="]
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register
+++ a/drivers/leds/leds-lp5521.c
@@ -175,14 +175,14 @@ static int lp5521_set_engine_mode(struct
 		mode = LP5521_CMD_DIRECT;
 
 	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
+	if (ret < 0)
+		return ret;
 
 	/* set mode only for this engine */
 	engine_state &= ~(engine->engine_mask);
 	mode &= engine->engine_mask;
 	engine_state |= mode;
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
