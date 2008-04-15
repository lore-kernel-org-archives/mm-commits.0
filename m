From: akpm@linux-foundation.org
Subject: - smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:53 -0700
Message-ID: <200804150910.m3F9ArZa020662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762308AbYDOJLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, akpm@linux-foundation.org, cooloney@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     smc91x driver: fix bug: print warning only in interrupt mode
has been removed from the -mm tree.  Its filename was
     smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc91x driver: fix bug: print warning only in interrupt mode
From: Sonic Zhang <sonic.zhang@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3956

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>

On Fri, 28 Mar 2008 21:45:02 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> akpm@linux-foundation.org wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3956
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
> > Cc: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/net/smc91x.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff -puN drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode drivers/net/smc91x.c
> > --- a/drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode
> > +++ a/drivers/net/smc91x.c
> > @@ -1326,9 +1326,11 @@ static irqreturn_t smc_interrupt(int irq
> >  	SMC_SET_INT_MASK(lp, mask);
> >  	spin_unlock(&lp->lock);
> >  
> > +#ifndef CONFIG_NET_POLL_CONTROLLER
> >  	if (timeout == MAX_IRQ_LOOPS)
> >  		PRINTK("%s: spurious interrupt (mask = 0x%02x)\n",
> >  		       dev->name, mask);
> > +#endif
> >  	DBG(3, "%s: Interrupt done (%d loops)\n",
> >  	       dev->name, MAX_IRQ_LOOPS - timeout);
> 
> NAK
> 
> Either this code is OK or it isn't.  This patch simply hides a problem 
> inside a configuration the developer probably doesn't use.
> 
> What's the _real_ problem?  Looking at the tracker, I'd guess that some 
> events need to be masked, but are not?
> 
> If the hardware is asserting events continually, the current code does 
> the right thing -- keep processing interrupt events flagged, until (a) 
> no more events asserted or (b) max loop count reached.
> 
> So the question is to find out why you are hitting the timeout, and what 
> to do about it.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode drivers/net/smc91x.c
--- a/drivers/net/smc91x.c~smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode
+++ a/drivers/net/smc91x.c
@@ -1326,9 +1326,11 @@ static irqreturn_t smc_interrupt(int irq
 	SMC_SET_INT_MASK(lp, mask);
 	spin_unlock(&lp->lock);
 
+#ifndef CONFIG_NET_POLL_CONTROLLER
 	if (timeout == MAX_IRQ_LOOPS)
 		PRINTK("%s: spurious interrupt (mask = 0x%02x)\n",
 		       dev->name, mask);
+#endif
 	DBG(3, "%s: Interrupt done (%d loops)\n",
 	       dev->name, MAX_IRQ_LOOPS - timeout);
 
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch

