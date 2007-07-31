From: akpm@linux-foundation.org
Subject: - rtc-m48t59-driver-no_irq-mode-fixup.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:59:16 -0700
Message-ID: <200707312359.l6VNxGir029636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756868AbXHAAQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rongkai.zhan@windriver.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-m48t59 driver NO_IRQ mode fixup
has been removed from the -mm tree.  Its filename was
     rtc-m48t59-driver-no_irq-mode-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-m48t59 driver NO_IRQ mode fixup
From: Mark Zhan <rongkai.zhan@windriver.com>

Since irq in m48t59_private struct is defined as 'unsigned int', which will
make the following if sentence to be never true:

         if (m48t59->irq < 0)
                  m48t59->irq = NO_IRQ;

And thus it will make the m48t59_rtc_probe() is failed when the driver is
working in a no irq mode:

Signed-off-by: Mark Zhan <rongkai.zhan@windriver.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-driver-no_irq-mode-fixup drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-driver-no_irq-mode-fixup
+++ a/drivers/rtc/rtc-m48t59.c
@@ -35,7 +35,7 @@
 struct m48t59_private {
 	void __iomem *ioaddr;
 	unsigned int size; /* iomem size */
-	unsigned int irq;
+	int irq;
 	struct rtc_device *rtc;
 	spinlock_t lock; /* serialize the NVRAM and RTC access */
 };
_

Patches currently in -mm which might be from rongkai.zhan@windriver.com are

origin.patch
no-need-to-convert-file-private_data-to-rtc-device.patch
