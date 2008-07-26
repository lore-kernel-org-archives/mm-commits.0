From: akpm@linux-foundation.org
Subject: - use-warn-in-kernel-irq-managec.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:14 -0700
Message-ID: <200807262116.m6QLGELL019812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757701AbYGZVQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Use WARN() in kernel/irq/manage.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-kernel-irq-managec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in kernel/irq/manage.c
From: Arjan van de Ven <arjan@linux.intel.com>

Replace a printk+WARN_ON() by a WARN(); this increases the chance of the
string making it into the bugreport (ie: it goes inside the
---[ cut here ]--- section)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/irq/manage.c~use-warn-in-kernel-irq-managec kernel/irq/manage.c
--- a/kernel/irq/manage.c~use-warn-in-kernel-irq-managec
+++ a/kernel/irq/manage.c
@@ -177,8 +177,7 @@ static void __enable_irq(struct irq_desc
 {
 	switch (desc->depth) {
 	case 0:
-		printk(KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
-		WARN_ON(1);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
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

