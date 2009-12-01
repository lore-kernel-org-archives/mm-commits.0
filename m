From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-fix-multi-chip-suspend-problem.patch removed from -mm tree
Date: Tue, 01 Dec 2009 12:17:54 -0800
Message-ID: <200912012017.nB1KHsSZ019682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZLAUR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:17:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leoli@freescale.com, b24347@freescale.com, dedekind1@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/nand: fix multi-chip suspend problem
has been removed from the -mm tree.  Its filename was
     mtd-nand-fix-multi-chip-suspend-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/nand: fix multi-chip suspend problem
From: Li Yang <leoli@freescale.com>

Symptom:
device_suspend(): mtd_cls_suspend+0x0/0x58 returns -11
PM: Device mtd14 failed to suspend: error -11
PM: Some devices failed to suspend

This patch enables other chips to be suspended if the active chip of
the controller has been suspended.

Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~mtd-nand-fix-multi-chip-suspend-problem drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand-fix-multi-chip-suspend-problem
+++ a/drivers/mtd/nand/nand_base.c
@@ -697,10 +697,16 @@ nand_get_device(struct nand_chip *chip, 
 		spin_unlock(lock);
 		return 0;
 	}
-	if (new_state == FL_PM_SUSPENDED) {
-		spin_unlock(lock);
-		return (chip->state == FL_PM_SUSPENDED) ? 0 : -EAGAIN;
-	}
+	if (new_state == FL_PM_SUSPENDED)
+		if (chip->controller->active->state == FL_PM_SUSPENDED) {
+			chip->state = FL_PM_SUSPENDED;
+			spin_unlock(lock);
+			return 0;
+		} else {
+			spin_unlock(lock);
+			return -EAGAIN;
+		}
+
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(wq, &wait);
 	spin_unlock(lock);
_

Patches currently in -mm which might be from leoli@freescale.com are

linux-next.patch

