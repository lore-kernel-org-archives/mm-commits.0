From: akpm@linux-foundation.org
Subject: - fix-config_debug_shirq-trigger-on-free_irq.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:06 -0700
Message-ID: <200710180654.l9I6s6Fj030498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419AbXJRHnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, andy@greyhouse.net, fernando@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Fix CONFIG_DEBUG_SHIRQ trigger on free_irq()
has been removed from the -mm tree.  Its filename was
     fix-config_debug_shirq-trigger-on-free_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/irq/manage.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

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
@@ -445,8 +444,21 @@ void free_irq(unsigned int irq, void *de
 
 			/* Make sure it's not being used on another CPU */
 			synchronize_irq(irq);
-			if (action->flags & IRQF_SHARED)
-				handler = action->handler;
+#ifdef CONFIG_DEBUG_SHIRQ
+			/*
+			 * It's a shared IRQ -- the driver ought to be
+			 * prepared for it to happen even now it's
+			 * being freed, so let's make sure....  We do
+			 * this after actually deregistering it, to
+			 * make sure that a 'real' IRQ doesn't run in
+			 * parallel with our fake
+			 */
+			if (action->flags & IRQF_SHARED) {
+				local_irq_save(flags);
+				action->handler(irq, dev_id);
+				local_irq_restore(flags);
+			}
+#endif
 			kfree(action);
 			return;
 		}
@@ -454,19 +466,6 @@ void free_irq(unsigned int irq, void *de
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
-		local_irq_save(flags);
-		handler(irq, dev_id);
-		local_irq_restore(flags);
-	}
-#endif
 }
 EXPORT_SYMBOL(free_irq);
 
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
remove-fs-jffs2-ioctlc.patch
console-events-and-accessibility-fix.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-system-auditing.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
