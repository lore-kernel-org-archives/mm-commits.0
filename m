From: akpm@linux-foundation.org
Subject: - use-warn-in-kernel-irq-chipc.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:18 -0700
Message-ID: <200807262116.m6QLGI6N019818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757701AbYGZVQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use WARN() in kernel/irq/chip.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-kernel-irq-chipc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use WARN() in kernel/irq/chip.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/irq/chip.c~use-warn-in-kernel-irq-chipc kernel/irq/chip.c
--- a/kernel/irq/chip.c~use-warn-in-kernel-irq-chipc
+++ a/kernel/irq/chip.c
@@ -28,8 +28,7 @@ void dynamic_irq_init(unsigned int irq)
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
 
@@ -62,8 +61,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
 
@@ -71,9 +69,8 @@ void dynamic_irq_cleanup(unsigned int ir
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
-		printk(KERN_ERR "Destroying IRQ%d without calling free_irq\n",
+		WARN(1, KERN_ERR "Destroying IRQ%d without calling free_irq\n",
 			irq);
-		WARN_ON(1);
 		return;
 	}
 	desc->msi_desc = NULL;
@@ -96,8 +93,7 @@ int set_irq_chip(unsigned int irq, struc
 	unsigned long flags;
 
 	if (irq >= NR_IRQS) {
-		printk(KERN_ERR "Trying to install chip for IRQ%d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch

