From: akpm@linux-foundation.org
Subject: - sm501-update-debugging-low-information-messages.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:45 -0700
Message-ID: <200808122032.m7CKWj5g011734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYHLUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, krzysztof.h1@wp.pl, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     sm501: update debugging/low information messages
has been removed from the -mm tree.  Its filename was
     sm501-update-debugging-low-information-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: update debugging/low information messages
From: Ben Dooks <ben-linux@fluff.org>

Make the default output of the SM501 driver to be less noisy wrt to
message that have low informational value, or simply should be debug.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Samuel Ortiz <sameo@openedhand.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-update-debugging-low-information-messages drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-update-debugging-low-information-messages
+++ a/drivers/mfd/sm501.c
@@ -623,8 +623,8 @@ unsigned long sm501_set_clock(struct dev
 
 	sm501_sync_regs(sm);
 
-	dev_info(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
-		 gate, clock, mode);
+	dev_dbg(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
+		gate, clock, mode);
 
 	sm501_mdelay(sm, 16);
 	mutex_unlock(&sm->clock_lock);
@@ -742,7 +742,7 @@ static int sm501_register_device(struct 
 	int ret;
 
 	for (ptr = 0; ptr < pdev->num_resources; ptr++) {
-		printk("%s[%d] flags %08lx: %08llx..%08llx\n",
+		printk(KERN_DEBUG "%s[%d] flags %08lx: %08llx..%08llx\n",
 		       pdev->name, ptr,
 		       pdev->resource[ptr].flags,
 		       (unsigned long long)pdev->resource[ptr].start,
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

