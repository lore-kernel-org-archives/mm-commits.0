From: akpm@linux-foundation.org
Subject: + lib8390-comment-on-locking-by-alan-cox.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:22:14 -0700
Message-ID: <200707270522.l6R5MEca007155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033AbXG0FW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, p_gortmaker@yahoo.com


The patch titled
     lib8390: comment on locking by Alan Cox
has been added to the -mm tree.  Its filename is
     lib8390-comment-on-locking-by-alan-cox.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib8390: comment on locking by Alan Cox
From: Jarek Poplawski <jarkao2@o2.pl>

Additional explanation of problems with locking by Alan Cox.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lib8390.c |   46 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN drivers/net/lib8390.c~lib8390-comment-on-locking-by-alan-cox drivers/net/lib8390.c
--- a/drivers/net/lib8390.c~lib8390-comment-on-locking-by-alan-cox
+++ a/drivers/net/lib8390.c
@@ -143,6 +143,52 @@ static void __NS8390_init(struct net_dev
  *	annoying the transmit function is called bh atomic. That places
  *	restrictions on the user context callers as disable_irq won't save
  *	them.
+ *
+ *	Additional explanation of problems with locking by Alan Cox:
+ *
+ *	"The author (me) didn't use spin_lock_irqsave because the slowness of the
+ *	card means that approach caused horrible problems like losing serial data
+ *	at 38400 baud on some chips. Rememeber many 8390 nics on PCI were ISA
+ *	chips with FPGA front ends.
+ *
+ *	Ok the logic behind the 8390 is very simple:
+ *
+ *	Things to know
+ *		- IRQ delivery is asynchronous to the PCI bus
+ *		- Blocking the local CPU IRQ via spin locks was too slow
+ *		- The chip has register windows needing locking work
+ *
+ *	So the path was once (I say once as people appear to have changed it
+ *	in the mean time and it now looks rather bogus if the changes to use
+ *	disable_irq_nosync_irqsave are disabling the local IRQ)
+ *
+ *
+ *		Take the page lock
+ *		Mask the IRQ on chip
+ *		Disable the IRQ (but not mask locally- someone seems to have
+ *			broken this with the lock validator stuff)
+ *			[This must be _nosync as the page lock may otherwise
+ *				deadlock us]
+ *		Drop the page lock and turn IRQs back on
+ *
+ *		At this point an existing IRQ may still be running but we can't
+ *		get a new one
+ *
+ *		Take the lock (so we know the IRQ has terminated) but don't mask
+ *	the IRQs on the processor
+ *		Set irqlock [for debug]
+ *
+ *		Transmit (slow as ****)
+ *
+ *		re-enable the IRQ
+ *
+ *
+ *	We have to use disable_irq because otherwise you will get delayed
+ *	interrupts on the APIC bus deadlocking the transmit path.
+ *
+ *	Quite hairy but the chip simply wasn't designed for SMP and you can't
+ *	even ACK an interrupt without risking corrupting other parallel
+ *	activities on the chip." [lkml, 25 Jul 2007]
  */
 
 
_

Patches currently in -mm which might be from jarkao2@o2.pl are

lib8390-comment-on-locking-by-alan-cox.patch
