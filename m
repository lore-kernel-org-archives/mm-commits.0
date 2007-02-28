From: akpm@linux-foundation.org
Subject: + irq-add-__must_check-to-request_irq.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:31:15 -0800
Message-ID: <200702280631.l1S6VJDB008878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbXB1GbV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org


The patch titled
     IRQ: add __must_check to request_irq
has been added to the -mm tree.  Its filename is
     irq-add-__must_check-to-request_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IRQ: add __must_check to request_irq
From: Monakhov Dmitriy <dmonakhov@openvz.org>

This could help to find buggy drivers where request_irq return value wasn't
checked.  There's just no reason to ignore errors which can and do occur. 
Anyone who got warning during compilation have to realise what it is't
realy safe code.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/interrupt.h~irq-add-__must_check-to-request_irq include/linux/interrupt.h
--- a/include/linux/interrupt.h~irq-add-__must_check-to-request_irq
+++ a/include/linux/interrupt.h
@@ -83,11 +83,11 @@ struct irqaction {
 };
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
-extern int request_irq(unsigned int, irq_handler_t handler,
+extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
-extern int devm_request_irq(struct device *dev, unsigned int irq,
+extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

ecryptfs-set-o_largefile-when-opening-lower-file.patch
ecryptfs-remove-unnecessary-flush_dcache_page.patch
ecryptfs-no-path_release-after-path_lookup-error.patch
libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
sk98lin-handle-pci_enable_device-return-value-in-skge_resume.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ecryptfs-handles-aop_truncated_page-better.patch
