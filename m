From: akpm@linux-foundation.org
Subject: - irq-add-__must_check-to-request_irq.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:24 -0700
Message-ID: <200705090245.l492jOuI008736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968787AbXEICp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     IRQ: add __must_check to request_irq
has been removed from the -mm tree.  Its filename was
     irq-add-__must_check-to-request_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
