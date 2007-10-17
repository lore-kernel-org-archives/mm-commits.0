From: akpm@linux-foundation.org
Subject: + misc-phantom-improved-data-passing-fix.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:53:53 -0700
Message-ID: <200710172253.l9HMrs8u012426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759082AbXJQWy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     misc-phantom-improved-data-passing-fix
has been added to the -mm tree.  Its filename is
     misc-phantom-improved-data-passing-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: misc-phantom-improved-data-passing-fix
From: Jiri Slaby <jirislaby@gmail.com>

Andrew Morton wrote:
> On Mon, 15 Oct 2007 09:33:49 -0700
> Jiri Slaby <jirislaby@gmail.com> wrote:
>
> > phantom, improved data passing
> >
> > this new version guarantees amb_bit switch in small enough intervals, so
> > that the device won't stop working in the middle of a movement anymore.
> > However it preserves old (openhaptics) functionality.
> >
> > ...
> >
> > +
> > +		/* preserve amp bit (don't allow to change it when in NOT_OH) */
> > +		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
> > +			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
> > +				(dev->ctl_reg & PHN_CTL_AMP);
>
> hm, is that coded as clearly and as simply as possible?  Don't think so :(

Changed below.

> >  static irqreturn_t phantom_isr(int irq, void *data)
> >  {
> >  	struct phantom_device *dev = data;
> > +	unsigned int i;
> > +	u32 ctl;
> >
> > -	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
> > +	spin_lock(&dev->regs_lock);
> > +	ctl = ioread32(dev->iaddr + PHN_CONTROL);
> > +	if (!(ctl & PHN_CTL_IRQ)) {
> > +		spin_unlock(&dev->regs_lock);
> >  		return IRQ_NONE;
> > +	}
> >
> >  	iowrite32(0, dev->iaddr);
> >  	iowrite32(0xc0, dev->iaddr);
> > +
> > +	if (dev->status & PHB_NOT_OH)
> > +		for (i = 0; i < min(dev->oregs.count, 8U); i++)
>
> But this is the interrupt handler, and there's a pointer chase as well as
> the min() each time around the loop (I assume).  I doubt if the world will
> end, but it seems a bit lazy?

Hmm, the compiler isn't as smart as I though. The fix follows, thanks.

--

misc-phantom-improved-data-passing-fix

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d1d9a974c008af6e7ad0347df7f9ca372da1bb4c
tree 9c9cda79e150a752f052831ea18f35f31c8f9a5f
parent 228d539e706cd42c2950aa26ac01590e413d8f51
author Jiri Slaby <jirislaby@gmail.com> Tue, 16 Oct 2007 16:46:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 16 Oct 2007 16:46:28 +0200

index 4a610cc..cd221fd 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-improved-data-passing-fix drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-improved-data-passing-fix
+++ a/drivers/misc/phantom.c
@@ -113,9 +113,11 @@ static long phantom_ioctl(struct file *f
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
 
 		/* preserve amp bit (don't allow to change it when in NOT_OH) */
-		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH))
-			dev->ctl_reg = r.value = (r.value & ~PHN_CTL_AMP) |
-				(dev->ctl_reg & PHN_CTL_AMP);
+		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH)) {
+			r.value &= ~PHN_CTL_AMP;
+			r.value |= dev->ctl_reg & PHN_CTL_AMP;
+			dev->ctl_reg = r.value;
+		}
 
 		iowrite32(r.value, dev->iaddr + r.reg);
 		ioread32(dev->iaddr); /* PCI posting */
@@ -133,7 +135,8 @@ static long phantom_ioctl(struct file *f
 		if (dev->status & PHB_NOT_OH)
 			memcpy(&dev->oregs, &rs, sizeof(rs));
 		else {
-			for (i = 0; i < min(rs.count, 8U); i++)
+			u32 m = min(rs.count, 8U);
+			for (i = 0; i < m; i++)
 				if (rs.mask & BIT(i))
 					iowrite32(rs.values[i], dev->oaddr + i);
 			ioread32(dev->iaddr); /* PCI posting */
@@ -152,13 +155,17 @@ static long phantom_ioctl(struct file *f
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
 		break;
-	case PHN_GET_REGS:
+	case PHN_GET_REGS: {
+		u32 m;
+
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
+		m = min(rs.count, 8U);
+
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
 		spin_lock_irqsave(&dev->regs_lock, flags);
-		for (i = 0; i < min(rs.count, 8U); i++)
+		for (i = 0; i < m; i++)
 			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
@@ -166,7 +173,7 @@ static long phantom_ioctl(struct file *f
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
 		break;
-	case PHN_NOT_OH:
+	} case PHN_NOT_OH:
 		spin_lock_irqsave(&dev->regs_lock, flags);
 		if (dev->status & PHB_RUNNING) {
 			printk(KERN_ERR "phantom: you need to set NOT_OH "
@@ -265,13 +272,17 @@ static irqreturn_t phantom_isr(int irq, 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
 
-	if (dev->status & PHB_NOT_OH)
-		for (i = 0; i < min(dev->oregs.count, 8U); i++)
-			if (dev->oregs.mask & BIT(i))
-				iowrite32(dev->oregs.values[i], dev->oaddr + i);
+	if (dev->status & PHB_NOT_OH) {
+		struct phm_regs *r = &dev->oregs;
+		u32 m = min(r->count, 8U);
+
+		for (i = 0; i < m; i++)
+			if (r->mask & BIT(i))
+				iowrite32(r->values[i], dev->oaddr + i);
 
-	dev->ctl_reg ^= PHN_CTL_AMP;
-	iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+		dev->ctl_reg ^= PHN_CTL_AMP;
+		iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+	}
 	spin_unlock(&dev->regs_lock);
 
 	ioread32(dev->iaddr); /* PCI posting */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
epcac-reformat-comments-and-coding-style-improvements.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
char-rocket-switch-sleep_on-to-completion.patch
char-rocket-fix-dynamic_dev-tty.patch
char-rocket-dont-re-set-statics-to-0.patch
char-rocket-remove-pci_read_config_dwordclass_revision.patch
char-rocket-remove-potential-leak-in-module_init.patch
char-rocket-fix-signed-unsigned-warning.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
misc-phantom-improved-data-passing-fix.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
