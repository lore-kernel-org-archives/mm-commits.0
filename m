From: akpm@linux-foundation.org
Subject: - sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:03 -0700
Message-ID: <200805231859.m4NIx3r2004200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbYEWS7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: use mod_timer() to set expiry and add_timer() together
has been removed from the -mm tree.  Its filename was
     sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: use mod_timer() to set expiry and add_timer() together
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/boards.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/net/sfc/boards.c~sfc-use-mod_timer-to-set-expiry-and-add_timer-together drivers/net/sfc/boards.c
--- a/drivers/net/sfc/boards.c~sfc-use-mod_timer-to-set-expiry-and-add_timer-together
+++ a/drivers/net/sfc/boards.c
@@ -27,10 +27,8 @@ static void blink_led_timer(unsigned lon
 	struct efx_blinker *bl = &efx->board_info.blinker;
 	efx->board_info.set_fault_led(efx, bl->state);
 	bl->state = !bl->state;
-	if (bl->resubmit) {
-		bl->timer.expires = jiffies + BLINK_INTERVAL;
-		add_timer(&bl->timer);
-	}
+	if (bl->resubmit)
+		mod_timer(&bl->timer, jiffies + BLINK_INTERVAL);
 }
 
 static void board_blink(struct efx_nic *efx, int blink)
@@ -44,8 +42,7 @@ static void board_blink(struct efx_nic *
 		blinker->state = 0;
 		setup_timer(&blinker->timer, blink_led_timer,
 			    (unsigned long)efx);
-		blinker->timer.expires = jiffies + BLINK_INTERVAL;
-		add_timer(&blinker->timer);
+		mod_timer(&blinker->timer, jiffies + BLINK_INTERVAL);
 	} else {
 		blinker->resubmit = 0;
 		if (blinker->timer.function)
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

