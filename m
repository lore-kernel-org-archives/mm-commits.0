From: akpm@linux-foundation.org
Subject: [merged] memstick-r592-fix-build-warnings-for-pm_sleep.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:38 -0700
Message-ID: <543d69b2.uuZTtHW1FDa3XCpP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaJNSVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, maximlevitsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: r592: fix build warnings for !PM_SLEEP
has been removed from the -mm tree.  Its filename was
     memstick-r592-fix-build-warnings-for-pm_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: memstick: r592: fix build warnings for !PM_SLEEP

When PM_SLEEP is not enabled, the r592_clear_interrupts() function is
never used.  If so, don't build it to prevent a compiler warning.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/memstick/host/r592.c~memstick-r592-fix-build-warnings-for-pm_sleep drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-r592-fix-build-warnings-for-pm_sleep
+++ a/drivers/memstick/host/r592.c
@@ -188,6 +188,7 @@ static void r592_host_reset(struct r592_
 	r592_set_mode(dev, dev->parallel_mode);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* Disable all hardware interrupts */
 static void r592_clear_interrupts(struct r592_device *dev)
 {
@@ -195,6 +196,7 @@ static void r592_clear_interrupts(struct
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_ACK_MASK);
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_EN_MASK);
 }
+#endif
 
 /* Tests if there is an CRC error */
 static int r592_test_io_error(struct r592_device *dev)
_

Patches currently in -mm which might be from treding@nvidia.com are

origin.patch
linux-next.patch

