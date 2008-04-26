From: akpm@linux-foundation.org
Subject: - smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:50 -0700
Message-ID: <200804261641.m3QGfo7W031152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757888AbYDZQmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, jacmet@sunsite.dk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
has been removed from the -mm tree.  Its filename was
     smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
From: Roel Kluin <12o3l@tiscali.nl>

When timeout reaches 0 the postfix decrement still subtracts, so the test
fails.

[akpm@linux-foundation.org: coding-style fixes]
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
+		} while (--timeout && !reg);
 		if (timeout == 0) {
 			PRINTK("%s: smc911x_reset timeout waiting for PM restore\n", dev->name);
 			return;
@@ -268,7 +268,7 @@ static void smc911x_reset(struct net_dev
 				resets++;
 				break;
 			}
-		} while ( timeout-- && (reg & HW_CFG_SRST_));
+		} while (--timeout && (reg & HW_CFG_SRST_));
 	}
 	if (timeout == 0) {
 		PRINTK("%s: smc911x_reset timeout waiting for reset\n", dev->name);
@@ -414,7 +414,7 @@ static inline void smc911x_drop_pkt(stru
 		do {
 			udelay(10);
 			reg = SMC_GET_RX_DP_CTRL() & RX_DP_CTRL_FFWD_BUSY_;
-		} while ( timeout-- && reg);
+		} while (--timeout && reg);
 		if (timeout == 0) {
 			PRINTK("%s: timeout waiting for RX fast forward\n", dev->name);
 		}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
mm-fix-possible-off-by-one-in-walk_pte_range.patch
dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

