From: akpm@linux-foundation.org
Subject: [merged] isdn-hisax-fix-lock-imbalance.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:07 -0800
Message-ID: <200911091955.nA9Jt7dp023178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbZKITzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Karsten-Keil@t-online.de, mm-commits@vger.kernel.org


The patch titled
     isdn: hisax, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     isdn-hisax-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: hisax, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Add omittted unlocks to 2 functions.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Karsten Keil <Karsten-Keil@t-online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/amd7930_fn.c |    1 +
 drivers/isdn/hisax/icc.c        |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/isdn/hisax/amd7930_fn.c~isdn-hisax-fix-lock-imbalance drivers/isdn/hisax/amd7930_fn.c
--- a/drivers/isdn/hisax/amd7930_fn.c~isdn-hisax-fix-lock-imbalance
+++ a/drivers/isdn/hisax/amd7930_fn.c
@@ -594,6 +594,7 @@ Amd7930_l1hw(struct PStack *st, int pr, 
 				if (cs->debug & L1_DEB_WARN)
 					debugl1(cs, "Amd7930: l1hw: l2l1 tx_skb exist this shouldn't happen");
 				skb_queue_tail(&cs->sq, skb);
+				spin_unlock_irqrestore(&cs->lock, flags);
 				break;
 			}
 			if (cs->debug & DEB_DLOG_HEX)
diff -puN drivers/isdn/hisax/icc.c~isdn-hisax-fix-lock-imbalance drivers/isdn/hisax/icc.c
--- a/drivers/isdn/hisax/icc.c~isdn-hisax-fix-lock-imbalance
+++ a/drivers/isdn/hisax/icc.c
@@ -468,6 +468,7 @@ ICC_l1hw(struct PStack *st, int pr, void
 				if (cs->debug & L1_DEB_WARN)
 					debugl1(cs, " l2l1 tx_skb exist this shouldn't happen");
 				skb_queue_tail(&cs->sq, skb);
+				spin_unlock_irqrestore(&cs->lock, flags);
 				break;
 			}
 			if (cs->debug & DEB_DLOG_HEX)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
isicomc-use-pr_fmt-and-pr_level.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

