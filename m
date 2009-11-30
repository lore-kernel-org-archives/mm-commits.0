From: akpm@linux-foundation.org
Subject: [merged] twl4030-fix-warning.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:09 -0800
Message-ID: <200911302033.nAUKX9U6020337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZK3UdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:33:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     twl4030: fix warning
has been removed from the -mm tree.  Its filename was
     twl4030-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: twl4030: fix warning
From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl4030-irq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/twl4030-irq.c~twl4030-fix-warning drivers/mfd/twl4030-irq.c
--- a/drivers/mfd/twl4030-irq.c~twl4030-fix-warning
+++ a/drivers/mfd/twl4030-irq.c
@@ -728,7 +728,8 @@ int twl_init_irq(int irq_num, unsigned i
 		goto fail_rqirq;
 	}
 
-	task = kthread_run(twl4030_irq_thread, (void *)irq_num, "twl4030-irq");
+	task = kthread_run(twl4030_irq_thread, (void *)(long)irq_num,
+								"twl4030-irq");
 	if (IS_ERR(task)) {
 		pr_err("twl4030: could not create irq %d thread!\n", irq_num);
 		status = PTR_ERR(task);
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
8250-add-serial-transmitter-fully-empty-test.patch
imx-bit-confusion.patch
i810fb-fix-stack-exploding.patch
char-cyclades-fix-compiler-warning.patch
parport_pcc-use-correct-length-in-strncmp.patch

