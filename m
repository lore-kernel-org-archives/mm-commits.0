From: akpm@linux-foundation.org
Subject: + trivial-in-string-typos-of-error.patch added to -mm tree
Date: Wed, 18 Jul 2007 18:12:17 -0700
Message-ID: <200707190112.l6J1CHCu006582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbXGSBMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 21:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eddy@klopper.net, rolandd@cisco.com, zippel@linux-m68k.org


The patch titled
     in-string typos of "error"
has been added to the -mm tree.  Its filename is
     trivial-in-string-typos-of-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: in-string typos of "error"
From: "Eddy L O Jansson" <eddy@klopper.net>

One patch for two trivial typos of 'error' with three R's, appearing in message strings.

There's a bunch more of the same in comments, not dealt with here.

Signed-off-by: Eddy L O Jansson <eddy@klopper.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
 drivers/net/via-velocity.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_irq.c~trivial-in-string-typos-of-error drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c~trivial-in-string-typos-of-error
+++ a/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -116,7 +116,7 @@ static void print_error_data(struct ehca
 	}
 	default:
 		ehca_err(&shca->ib_device,
-			 "Unknown errror type: %lx on %s.",
+			 "Unknown error type: %lx on %s.",
 			 type, shca->ib_device.name);
 		break;
 	}
diff -puN drivers/net/via-velocity.c~trivial-in-string-typos-of-error drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~trivial-in-string-typos-of-error
+++ a/drivers/net/via-velocity.c
@@ -1613,7 +1613,7 @@ static void velocity_error(struct veloci
 	if (status & ISR_TXSTLI) {
 		struct mac_regs __iomem * regs = vptr->mac_regs;
 
-		printk(KERN_ERR "TD structure errror TDindex=%hx\n", readw(&regs->TDIdx[0]));
+		printk(KERN_ERR "TD structure error TDindex=%hx\n", readw(&regs->TDIdx[0]));
 		BYTE_REG_BITS_ON(TXESR_TDSTR, &regs->TXESR);
 		writew(TRDCSR_RUN, &regs->TDCSRClr);
 		netif_stop_queue(vptr->dev);
_

Patches currently in -mm which might be from eddy@klopper.net are

trivial-in-string-typos-of-error.patch
