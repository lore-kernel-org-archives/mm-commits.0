From: akpm@linux-foundation.org
Subject: + hardware-misdn-misdninfineonc-bail-out-of-loop-on-error.patch added to -mm tree
Date: Thu, 21 Jan 2010 16:05:24 -0800
Message-ID: <201001220005.o0M05OjB005298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263Ab0AVAF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 19:05:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrenrjenkins@gmail.com, isdn@linux-pingi.de


The patch titled
     hardware/mISDN/mISDNinfineon.c: bail out of loop on error
has been added to the -mm tree.  Its filename is
     hardware-misdn-misdninfineonc-bail-out-of-loop-on-error.patch

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

origin.patch
hardware-misdn-misdninfineonc-bail-out-of-loop-on-error.patch

