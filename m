From: akpm@linux-foundation.org
Subject: [merged] hardware-misdn-misdninfineonc-bail-out-of-loop-on-error.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:51 -0800
Message-ID: <201002051958.o15JwppR017902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933839Ab0BET66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrenrjenkins@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     hardware/mISDN/mISDNinfineon.c: bail out of loop on error
has been removed from the -mm tree.  Its filename was
     hardware-misdn-misdninfineonc-bail-out-of-loop-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hardware/mISDN/mISDNinfineon.c: bail out of loop on error
From: Darren Jenkins <darrenrjenkins@gmail.com>

If setup_instance() fails we kfree() the card, and then use it in the next
loop iteration.  So lets bail out of the loop instead.

Coverity CID: 13357

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/mISDNinfineon.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/hardware/mISDN/mISDNinfineon.c~hardware-misdn-misdninfineonc-bail-out-of-loop-on-error drivers/isdn/hardware/mISDN/mISDNinfineon.c
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c~hardware-misdn-misdninfineonc-bail-out-of-loop-on-error
+++ a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -1133,6 +1133,7 @@ inf_probe(struct pci_dev *pdev, const st
 			if (err) {
 				kfree(sc);
 				release_card(card);
+				break;
 			} else
 				card->sc[i - 1] = sc;
 		}
_

Patches currently in -mm which might be from darrenrjenkins@gmail.com are

linux-next.patch

