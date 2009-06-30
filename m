From: akpm@linux-foundation.org
Subject: + isdn-hisax-fix-lock-imbalance.patch added to -mm tree
Date: Tue, 30 Jun 2009 13:11:19 -0700
Message-ID: <200906302011.n5UKBJtv002479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbZF3ULt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 16:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Karsten-Keil@t-online.de


The patch titled
     isdn: hisax, fix lock imbalance
has been added to the -mm tree.  Its filename is
     isdn-hisax-fix-lock-imbalance.patch

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
@@ -596,6 +596,7 @@ Amd7930_l1hw(struct PStack *st, int pr, 
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
@@ -470,6 +470,7 @@ ICC_l1hw(struct PStack *st, int pr, void
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
floppy-fix-lock-imbalance.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
base-firmware_class-fix-lock-imbalance.patch
wireless-nl80211-fix-lock-imbalance.patch
reiser4.patch

