From: akpm@linux-foundation.org
Subject: - pxafb-use-completion-for-lcd-disable-wait-code.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:18 -0700
Message-ID: <200805010925.m419PIel030190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758187AbYEAJpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: use completion for LCD disable wait code
has been removed from the -mm tree.  Its filename was
     pxafb-use-completion-for-lcd-disable-wait-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: use completion for LCD disable wait code
From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   12 ++++--------
 drivers/video/pxafb.h |    2 ++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-use-completion-for-lcd-disable-wait-code drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-use-completion-for-lcd-disable-wait-code
+++ a/drivers/video/pxafb.c
@@ -39,6 +39,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/completion.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -810,11 +811,6 @@ static void pxafb_disable_controller(str
 {
 	uint32_t lccr0;
 
-	DECLARE_WAITQUEUE(wait, current);
-
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&fbi->ctrlr_wait, &wait);
-
 	/* Clear LCD Status Register */
 	lcd_writel(fbi, LCSR, 0xffffffff);
 
@@ -822,8 +818,7 @@ static void pxafb_disable_controller(str
 	lcd_writel(fbi, LCCR0, lccr0);
 	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);
 
-	schedule_timeout(200 * HZ / 1000);
-	remove_wait_queue(&fbi->ctrlr_wait, &wait);
+	wait_for_completion_timeout(&fbi->disable_done, 200 * HZ / 1000);
 
 	/* disable LCD controller clock */
 	clk_disable(fbi->clk);
@@ -840,7 +835,7 @@ static irqreturn_t pxafb_handle_irq(int 
 	if (lcsr & LCSR_LDD) {
 		lccr0 = lcd_readl(fbi, LCCR0);
 		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
-		wake_up(&fbi->ctrlr_wait);
+		complete(&fbi->disable_done);
 	}
 
 	lcd_writel(fbi, LCSR, lcsr);
@@ -1190,6 +1185,7 @@ static struct pxafb_info * __init pxafb_
 	init_waitqueue_head(&fbi->ctrlr_wait);
 	INIT_WORK(&fbi->task, pxafb_task);
 	init_MUTEX(&fbi->ctrlr_sem);
+	init_completion(&fbi->disable_done);
 
 	return fbi;
 }
diff -puN drivers/video/pxafb.h~pxafb-use-completion-for-lcd-disable-wait-code drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-use-completion-for-lcd-disable-wait-code
+++ a/drivers/video/pxafb.h
@@ -114,6 +114,8 @@ struct pxafb_info {
 	wait_queue_head_t	ctrlr_wait;
 	struct work_struct	task;
 
+	struct completion	disable_done;
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 	struct notifier_block	freq_policy;
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

