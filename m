From: akpm@linux-foundation.org
Subject: + smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:06:47 -0700
Message-ID: <200804152306.m3FN6lqS020604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbYDOXHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, jacmet@sunsite.dk, jeff@garzik.org


The patch titled
     smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
has been added to the -mm tree.  Its filename is
     smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch

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
Subject: smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
From: Roel Kluin <12o3l@tiscali.nl>

When timeout reaches 0 the postfix decrement still subtracts, so the test
fails.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/smc911x.c~smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt
+++ a/drivers/net/smc911x.c
@@ -244,7 +244,7 @@ static void smc911x_reset(struct net_dev
 		do {
 			udelay(10);
 			reg = SMC_GET_PMT_CTRL() & PMT_CTRL_READY_;
-		} while ( timeout-- && !reg);
+		} while ( --timeout && !reg);
 		if (timeout == 0) {
 			PRINTK("%s: smc911x_reset timeout waiting for PM restore\n", dev->name);
 			return;
@@ -268,7 +268,7 @@ static void smc911x_reset(struct net_dev
 				resets++;
 				break;
 			}
-		} while ( timeout-- && (reg & HW_CFG_SRST_));
+		} while ( --timeout && (reg & HW_CFG_SRST_));
 	}
 	if (timeout == 0) {
 		PRINTK("%s: smc911x_reset timeout waiting for reset\n", dev->name);
@@ -414,7 +414,7 @@ static inline void smc911x_drop_pkt(stru
 		do {
 			udelay(10);
 			reg = SMC_GET_RX_DP_CTRL() & RX_DP_CTRL_FFWD_BUSY_;
-		} while ( timeout-- && reg);
+		} while ( --timeout && reg);
 		if (timeout == 0) {
 			PRINTK("%s: timeout waiting for RX fast forward\n", dev->name);
 		}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

mm-fix-possible-off-by-one-in-walk_pte_range.patch
dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
git-powerpc.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-net.patch
git-scsi-misc.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
git-cryptodev.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch

