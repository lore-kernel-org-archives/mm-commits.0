From: akpm@linux-foundation.org
Subject: - bf54x-framebuffer-driver-drop-request_irq-cast.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:44 -0700
Message-ID: <200804282159.m3SLxitU018613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934933AbYD1V7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     BF54x Framebuffer Driver: drop request_irq cast
has been removed from the -mm tree.  Its filename was
     bf54x-framebuffer-driver-drop-request_irq-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BF54x Framebuffer Driver: drop request_irq cast
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bf54x-lq043fb.c~bf54x-framebuffer-driver-drop-request_irq-cast drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~bf54x-framebuffer-driver-drop-request_irq-cast
+++ a/drivers/video/bf54x-lq043fb.c
@@ -652,7 +652,7 @@ static int __init bfin_bf54x_probe(struc
 		goto out7;
 	}
 
-	if (request_irq(info->irq, (void *)bfin_bf54x_irq_error, IRQF_DISABLED,
+	if (request_irq(info->irq, bfin_bf54x_irq_error, IRQF_DISABLED,
 			"PPI ERROR", info) < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
procfs-task-exe-symlink-fix-2.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch

