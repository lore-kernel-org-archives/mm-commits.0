From: akpm@linux-foundation.org
Subject: - misc-phantom-synchronize_irq-on-suspend.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:20 -0700
Message-ID: <200710192252.l9JMqKoD024260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763865AbXJSXFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, synchronize_irq() on suspend
has been removed from the -mm tree.  Its filename was
     misc-phantom-synchronize_irq-on-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Misc: phantom, synchronize_irq() on suspend
From: Jiri Slaby <jirislaby@gmail.com>

Wait after disabling device's interrupt until the handler finishes its work if
still in progress.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/phantom.c~misc-phantom-synchronize_irq-on-suspend drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-synchronize_irq-on-suspend
+++ a/drivers/misc/phantom.c
@@ -378,6 +378,8 @@ static int phantom_suspend(struct pci_de
 	iowrite32(0, dev->caddr + PHN_IRQCTL);
 	ioread32(dev->caddr + PHN_IRQCTL); /* PCI posting */
 
+	synchronize_irq(pdev->irq);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
