From: akpm@linux-foundation.org
Subject: + b2c2-flexcop-pci-spinlock-lock-problem-fix.patch added to -mm tree
Date: Mon, 09 Apr 2007 16:38:48 -0700
Message-ID: <200704092338.l39NcmXj026493@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbXDIXi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 19:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borgi2008@yahoo.de, mchehab@infradead.org


The patch titled
     b2c2-flexcop-pci spinlock lock problem fix
has been added to the -mm tree.  Its filename is
     b2c2-flexcop-pci-spinlock-lock-problem-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: b2c2-flexcop-pci spinlock lock problem fix
From: Borgi2008 <borgi2008@yahoo.de>

I've created a small patch for the current kernel version which fixes a bug
in the DVB driver for b2c2-flexcop based pci devices.  During
initialization of the pci device spin_lock_irq is called before
spin_lock_init.  I've also created a bugreport in bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=8301

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/b2c2/flexcop-pci.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/b2c2/flexcop-pci.c~b2c2-flexcop-pci-spinlock-lock-problem-fix drivers/media/dvb/b2c2/flexcop-pci.c
--- a/drivers/media/dvb/b2c2/flexcop-pci.c~b2c2-flexcop-pci-spinlock-lock-problem-fix
+++ a/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -127,10 +127,11 @@ static irqreturn_t flexcop_pci_isr(int i
 {
 	struct flexcop_pci *fc_pci = dev_id;
 	struct flexcop_device *fc = fc_pci->fc_dev;
+	unsigned long flags;
 	flexcop_ibi_value v;
 	irqreturn_t ret = IRQ_HANDLED;
 
-	spin_lock_irq(&fc_pci->irq_lock);
+	spin_lock_irqsave(&fc_pci->irq_lock,flags);
 
 	v = fc->read_ibi_reg(fc,irq_20c);
 
@@ -194,7 +195,7 @@ static irqreturn_t flexcop_pci_isr(int i
 		ret = IRQ_NONE;
 	}
 
-	spin_unlock_irq(&fc_pci->irq_lock);
+	spin_unlock_irqrestore(&fc_pci->irq_lock,flags);
 
 	return ret;
 }
@@ -293,12 +294,12 @@ static int flexcop_pci_init(struct flexc
 	}
 
 	pci_set_drvdata(fc_pci->pdev, fc_pci);
-
+	spin_lock_init(&fc_pci->irq_lock);
 	if ((ret = request_irq(fc_pci->pdev->irq, flexcop_pci_isr,
 					IRQF_SHARED, DRIVER_NAME, fc_pci)) != 0)
 		goto err_pci_iounmap;
 
-	spin_lock_init(&fc_pci->irq_lock);
+
 
 	fc_pci->init_state |= FC_PCI_INIT;
 	return ret;
_

Patches currently in -mm which might be from borgi2008@yahoo.de are

b2c2-flexcop-pci-spinlock-lock-problem-fix.patch
