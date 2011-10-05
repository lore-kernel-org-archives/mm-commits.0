From: akpm@google.com
Subject: + leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch added to -mm tree
Date: Wed, 05 Oct 2011 14:47:47 -0700
Message-ID: <201110052147.p95LlmMY011695@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:39056 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 17:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com


The patch titled
     Subject: leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix
has been added to the -mm tree.  Its filename is
     leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch

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
From: Andrew Morton <akpm@google.com>
Subject: leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix

remove unneeded "ret |="

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Andrew Morton <akpm@google.com>
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
