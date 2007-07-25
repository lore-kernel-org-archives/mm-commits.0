From: akpm@linux-foundation.org
Subject: + fix-config_debug_shirq-trigger-on-free_irq.patch added to -mm tree
Date: Wed, 25 Jul 2007 13:33:01 -0700
Message-ID: <200707252033.l6PKX1Ga020561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754254AbXGYUdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 16:33:17 -0400
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

 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/manage.c~fix-config_debug_shirq-trigger-on-free_irq kernel/irq/manage.c
--- a/kernel/irq/manage.c~fix-config_debug_shirq-trigger-on-free_irq
+++ a/kernel/irq/manage.c
@@ -446,7 +446,7 @@ void free_irq(unsigned int irq, void *de
 			if (action->flags & IRQF_SHARED)
 				handler = action->handler;
 			kfree(action);
-			return;
+			break;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
 		spin_unlock_irqrestore(&desc->lock, flags);
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
