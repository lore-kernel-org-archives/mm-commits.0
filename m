From: akpm@linux-foundation.org
Subject: + fix-config_debug_shirq-trigger-on-free_irq.patch added to -mm tree
Date: Wed, 25 Jul 2007 15:38:27 -0700
Message-ID: <200707252238.l6PMcRGv028255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbXGYWio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 18:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, andy@greyhouse.net, fernando@oss.ntt.co.jp


The patch titled
     Fix CONFIG_DEBUG_SHIRQ trigger on free_irq()
has been added to the -mm tree.  Its filename is
     fix-config_debug_shirq-trigger-on-free_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix CONFIG_DEBUG_SHIRQ trigger on free_irq()
From: David Woodhouse <dwmw2@infradead.org>

Andy Gospodarek pointed out that because we return in the middle of the
free_irq() function, we never actually do call the IRQ handler that just
got deregistered. This should fix it, although I expect Andrew will want
to convert those 'return's to 'break'. That's a separate change though.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Fernando Luis Vzquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff -puN kernel/irq/manage.c~fix-config_debug_shirq-trigger-on-free_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~fix-config_debug_shirq-trigger-on-free_irq
+++ a/kernel/irq/manage.c
@@ -405,7 +405,6 @@ void free_irq(unsigned int irq, void *de
 	struct irq_desc *desc;
 	struct irqaction **p;
 	unsigned long flags;
-	irqreturn_t (*handler)(int, void *) = NULL;
 
 	WARN_ON(in_interrupt());
 	if (irq >= NR_IRQS)
@@ -445,8 +444,18 @@ void free_irq(unsigned int irq, void *de
 
 			/* Make sure it's not being used on another CPU */
 			synchronize_irq(irq);
+#ifdef CONFIG_DEBUG_SHIRQ
+			/*
+			 * It's a shared IRQ -- the driver ought to be
+			 * prepared for it to happen even now it's
+			 * being freed, so let's make sure....  We do
+			 * this after actually deregistering it, to
+			 * make sure that a 'real' IRQ doesn't run in
+			 * parallel with our fake
+			 */
 			if (action->flags & IRQF_SHARED)
-				handler = action->handler;
+				action->handler(irq, dev_id);
+#endif
 			kfree(action);
 			return;
 		}
@@ -454,17 +463,6 @@ void free_irq(unsigned int irq, void *de
 		spin_unlock_irqrestore(&desc->lock, flags);
 		return;
 	}
-#ifdef CONFIG_DEBUG_SHIRQ
-	if (handler) {
-		/*
-		 * It's a shared IRQ -- the driver ought to be prepared for it
-		 * to happen even now it's being freed, so let's make sure....
-		 * We do this after actually deregistering it, to make sure that
-		 * a 'real' IRQ doesn't run in parallel with our fake
-		 */
-		handler(irq, dev_id);
-	}
-#endif
 }
 EXPORT_SYMBOL(free_irq);
 
_

Patches currently in -mm which might be from dwmw2@infradead.org are

git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
mtd-add-module-license-to-mtdbdi.patch
git-battery.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
jffs2-convert-to-new-aops.patch
include-serial_regh-with-userspace-headers.patch
sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
fix-config_debug_shirq-trigger-on-free_irq.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-system-auditing.patch
