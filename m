From: akpm@linux-foundation.org
Subject: + potential-compiler-error-irqfunc-caller-sites-update.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:55:33 -0700
Message-ID: <200707052155.l65LtXwD021557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759822AbXGEVzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: padator@wanadoo.fr, akpm@linux-foundation.org, davem@davemloft.net, greg@kroah.com, jeff@garzik.org


The patch titled
     potential compiler error, irqfunc caller sites update
has been added to the -mm tree.  Its filename is
     potential-compiler-error-irqfunc-caller-sites-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: potential compiler error, irqfunc caller sites update
From: Yoann Padioleau <padator@wanadoo.fr>

In 7d12e780e003f93433d49ce78cfedf4b4c52adc5 David Howells performed
this evolution:
 "IRQ: Maintain regs pointer globally rather than passing to IRQ handlers"

He correctly updated many of the function definitions that were using this
extra regs pointer parameter but forgot to update some caller sites of
those functions.  The reason the modifications was not properly done on all
drivers is that some drivers were rarely compiled because they are for
AMIGA, or that some code sites were inside #ifdefs where the option is not
set or inside #if 0.

Here is the semantic patch that found the occurences
and fixed the problem.

@ rule1 @
identifier fn;
identifier irq, dev_id;
typedef irqreturn_t;
@@

static irqreturn_t fn(int irq, void *dev_id)
{
   ...
}

@@
identifier rule1.fn;
expression E1, E2, E3;
@@

 fn(E1, E2
-   ,E3
   )

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/firestream.c     |    2 +-
 drivers/net/arm/am79c961a.c  |    2 +-
 drivers/net/ixp2000/ixpdev.c |    2 +-
 drivers/net/sb1250-mac.c     |    2 +-
 drivers/usb/misc/uss720.c    |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/atm/firestream.c~potential-compiler-error-irqfunc-caller-sites-update drivers/atm/firestream.c
--- a/drivers/atm/firestream.c~potential-compiler-error-irqfunc-caller-sites-update
+++ a/drivers/atm/firestream.c
@@ -1654,7 +1654,7 @@ static void fs_poll (unsigned long data)
 {
 	struct fs_dev *dev = (struct fs_dev *) data;
   
-	fs_irq (0, dev, NULL);
+	fs_irq (0, dev);
 	dev->timer.expires = jiffies + FS_POLL_FREQ;
 	add_timer (&dev->timer);
 }
diff -puN drivers/net/arm/am79c961a.c~potential-compiler-error-irqfunc-caller-sites-update drivers/net/arm/am79c961a.c
--- a/drivers/net/arm/am79c961a.c~potential-compiler-error-irqfunc-caller-sites-update
+++ a/drivers/net/arm/am79c961a.c
@@ -634,7 +634,7 @@ static void am79c961_poll_controller(str
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	am79c961_interrupt(dev->irq, dev, NULL);
+	am79c961_interrupt(dev->irq, dev);
 	local_irq_restore(flags);
 }
 #endif
diff -puN drivers/net/ixp2000/ixpdev.c~potential-compiler-error-irqfunc-caller-sites-update drivers/net/ixp2000/ixpdev.c
--- a/drivers/net/ixp2000/ixpdev.c~potential-compiler-error-irqfunc-caller-sites-update
+++ a/drivers/net/ixp2000/ixpdev.c
@@ -222,7 +222,7 @@ static irqreturn_t ixpdev_interrupt(int 
 static void ixpdev_poll_controller(struct net_device *dev)
 {
 	disable_irq(IRQ_IXP2000_THDA0);
-	ixpdev_interrupt(IRQ_IXP2000_THDA0, dev, NULL);
+	ixpdev_interrupt(IRQ_IXP2000_THDA0, dev);
 	enable_irq(IRQ_IXP2000_THDA0);
 }
 #endif
diff -puN drivers/net/sb1250-mac.c~potential-compiler-error-irqfunc-caller-sites-update drivers/net/sb1250-mac.c
--- a/drivers/net/sb1250-mac.c~potential-compiler-error-irqfunc-caller-sites-update
+++ a/drivers/net/sb1250-mac.c
@@ -1159,7 +1159,7 @@ static void sbmac_netpoll(struct net_dev
 
 	__raw_writeq(0, sc->sbm_imr);
 
-	sbmac_intr(irq, netdev, NULL);
+	sbmac_intr(irq, netdev);
 
 #ifdef CONFIG_SBMAC_COALESCE
 	__raw_writeq(((M_MAC_INT_EOP_COUNT | M_MAC_INT_EOP_TIMER) << S_MAC_TX_CH0) |
diff -puN drivers/usb/misc/uss720.c~potential-compiler-error-irqfunc-caller-sites-update drivers/usb/misc/uss720.c
--- a/drivers/usb/misc/uss720.c~potential-compiler-error-irqfunc-caller-sites-update
+++ a/drivers/usb/misc/uss720.c
@@ -336,7 +336,7 @@ static int uss720_irq(int usbstatus, voi
 	memcpy(priv->reg, buffer, 4);
 	/* if nAck interrupts are enabled and we have an interrupt, call the interrupt procedure */
 	if (priv->reg[2] & priv->reg[1] & 0x10)
-		parport_generic_irq(0, pp, NULL);
+		parport_generic_irq(0, pp);
 	return 1;
 }
 #endif
_

Patches currently in -mm which might be from padator@wanadoo.fr are

potential-compiler-error-irqfunc-caller-sites-update.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch
