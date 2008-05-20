From: akpm@linux-foundation.org
Subject: + sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:26 -0700
Message-ID: <200805200327.m4K3RQYU002686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757061AbYETD1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: use mod_timer() to set expiry and add_timer() together
has been added to the -mm tree.  Its filename is
     sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch
sfc-remove-casts-to-void.patch
sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch
sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch
sfc-add-and-remove-braces-to-comply-with-kernel-style.patch
sfc-replace-various-macros-with-inline-functions.patch
sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch
sfc-use-resource_size_t-for-pci-bus-address.patch
sfc-correct-and-expand-some-comments.patch
sfc-do-not-define-inline-macro.patch
sfc-remove-redundant-casts-to-and-from-void.patch
sfc-add-checks-for-heap-allocation-failure.patch
sfc-remove-sub-minor-component-from-driver-version.patch

