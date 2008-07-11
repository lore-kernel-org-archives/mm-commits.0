From: akpm@linux-foundation.org
Subject: + use-warn-in-kernel-irq-chipc.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:22 -0700
Message-ID: <200807111851.m6BIp3Ta031296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281AbYGKSvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu


The patch titled
     use WARN() in kernel/irq/chip.c
has been added to the -mm tree.  Its filename is
     use-warn-in-kernel-irq-chipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

