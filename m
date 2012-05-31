From: akpm@linux-foundation.org
Subject: [merged] leds-change-ledtrig-timer-to-use-activated-flag.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:41 -0700
Message-ID: <20120531191941.5DE6AA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51829 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721Ab2EaTTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:19:43 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75811lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkhan@gmail.com, bryan.wu@canonical.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: change ledtrig-timer to use activated flag
has been removed from the -mm tree.  Its filename was
     leds-change-ledtrig-timer-to-use-activated-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: change ledtrig-timer to use activated flag

Change existing timer trigger to use the new ->activated flag to set
activate successful status in activate routine and check it in deactivate
routine to do cleanup.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-timer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/ledtrig-timer.c~leds-change-ledtrig-timer-to-use-activated-flag drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-change-ledtrig-timer-to-use-activated-flag
+++ a/drivers/leds/ledtrig-timer.c
@@ -87,8 +87,7 @@ static void timer_trig_activate(struct l
 
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
