From: akpm@google.com
Subject: + leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch added to -mm tree
Date: Wed, 05 Oct 2011 14:47:42 -0700
Message-ID: <201110052147.p95LlhY7005997@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:39013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 17:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com


The patch titled
     Subject: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to LP5521_REG_OP_MODE register
has been added to the -mm tree.  Its filename is
     leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to LP5521_REG_OP_MODE register

If lp5521_read fails, engine_state variable is not initialized.
If lp5521_read fails, we should return error.
This patch fixes below warning.

  CC      drivers/leds/leds-lp5521.o
drivers/leds/leds-lp5521.c: In function 'lp5521_set_engine_mode':
drivers/leds/leds-lp5521.c:168: warning: 'engine_state' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/leds/leds-lp5521.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register
+++ a/drivers/leds/leds-lp5521.c
@@ -175,6 +175,8 @@ static int lp5521_set_engine_mode(struct
 		mode = LP5521_CMD_DIRECT;
 
 	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
+	if (ret < 0)
+		return ret;
 
 	/* set mode only for this engine */
 	engine_state &= ~(engine->engine_mask);
_
Subject: Subject: drivers/leds/leds-lp5521.c: avoid writing uninitialized value to LP5521_REG_OP_MODE register

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
backlight-rename-corgibl_limit_intensity-to-genericbl_limit_intensity.patch
leds-renesas-tpu-led-driver-v2-fix.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch

