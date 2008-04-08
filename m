From: akpm@linux-foundation.org
Subject: + pxafb-use-completion-for-lcd-disable-wait-code.patch added to -mm tree
Date: Tue, 08 Apr 2008 01:27:51 -0700
Message-ID: <200804080827.m388Rpim016305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYDHI2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 04:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk


The patch titled
     pxafb: use completion for LCD disable wait code
has been added to the -mm tree.  Its filename is
     pxafb-use-completion-for-lcd-disable-wait-code.patch

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
@@ -801,11 +802,6 @@ static void pxafb_disable_controller(str
 {
 	uint32_t lccr0;
 
-	DECLARE_WAITQUEUE(wait, current);
-
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&fbi->ctrlr_wait, &wait);
-
 	/* Clear LCD Status Register */
 	lcd_writel(fbi, LCSR, 0xffffffff);
 
@@ -813,8 +809,7 @@ static void pxafb_disable_controller(str
 	lcd_writel(fbi, LCCR0, lccr0);
 	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);
 
-	schedule_timeout(200 * HZ / 1000);
-	remove_wait_queue(&fbi->ctrlr_wait, &wait);
+	wait_for_completion_timeout(&fbi->disable_done, 200 * HZ / 1000);
 
 	/* disable LCD controller clock */
 	clk_disable(fbi->clk);
@@ -831,7 +826,7 @@ static irqreturn_t pxafb_handle_irq(int 
 	if (lcsr & LCSR_LDD) {
 		lccr0 = lcd_readl(fbi, LCCR0);
 		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
-		wake_up(&fbi->ctrlr_wait);
+		complete(&fbi->disable_done);
 	}
 
 	lcd_writel(fbi, LCSR, lcsr);
@@ -1181,6 +1176,7 @@ static struct pxafb_info * __init pxafb_
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

git-arm.patch
pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
pxafb-fix-various-coding-style-issues-for-pxafb.patch
pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch
pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch
pxafb-use-completion-for-lcd-disable-wait-code.patch
pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch
pxafb-preliminary-smart-panel-interface-support.patch

