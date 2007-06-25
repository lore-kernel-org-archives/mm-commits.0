From: akpm@linux-foundation.org
Subject: - sm501-fix-sm501_init_reg-mask-set-order.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:39 -0700
Message-ID: <200706250920.l5P9Kdsp031035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbXFYJVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     SM501: Fix sm501_init_reg() mask/set order
has been removed from the -mm tree.  Its filename was
     sm501-fix-sm501_init_reg-mask-set-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SM501: Fix sm501_init_reg() mask/set order
From: Ben Dooks <ben-linux@fluff.org>

The order of the set and mask operation in sm501_init_reg() was setting and
then masking the bits set.  Correct the order so that we do not end up with
288MHz SDRAM clocks on certain systems.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~sm501-fix-sm501_init_reg-mask-set-order drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-fix-sm501_init_reg-mask-set-order
+++ a/drivers/mfd/sm501.c
@@ -813,6 +813,9 @@ static DEVICE_ATTR(dbg_regs, 0666, sm501
 /* sm501_init_reg
  *
  * Helper function for the init code to setup a register
+ *
+ * clear the bits which are set in r->mask, and then set
+ * the bits set in r->set.
 */
 
 static inline void sm501_init_reg(struct sm501_devdata *sm,
@@ -822,8 +825,8 @@ static inline void sm501_init_reg(struct
 	unsigned long tmp;
 
 	tmp = readl(sm->regs + reg);
-	tmp |= r->set;
 	tmp &= ~r->mask;
+	tmp |= r->set;
 	writel(tmp, sm->regs + reg);
 }
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-watchdog.patch
spi-tle620x-power-switch-driver.patch
