From: akpm@linux-foundation.org
Subject: - kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:24 -0700
Message-ID: <200807252255.m6PMtOiF002974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbYGYW4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/irq/manage.c: replace a printk + WARN_ON() to a WARN()
has been removed from the -mm tree.  Its filename was
     kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/manage.c: replace a printk + WARN_ON() to a WARN()
From: Arjan van de Ven <arjan@linux.intel.com>

Replace a printk+WARN_ON() by a WARN(); this increases the chance of the
string making it into the bugreport (ie: it goes inside the
---[ cut here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/irq/manage.c~kernel-irq-managec-replace-a-printk-warn_on-to-a-warn kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-irq-managec-replace-a-printk-warn_on-to-a-warn
+++ a/kernel/irq/manage.c
@@ -260,9 +260,7 @@ int set_irq_wake(unsigned int irq, unsig
 		}
 	} else {
 		if (desc->wake_depth == 0) {
-			printk(KERN_WARNING "Unbalanced IRQ %d "
-					"wake disable\n", irq);
-			WARN_ON(1);
+			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0) {
 			ret = set_irq_wake_real(irq, on);
 			if (ret)
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-irq-managec.patch
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

