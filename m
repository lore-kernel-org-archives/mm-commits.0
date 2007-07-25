From: akpm@linux-foundation.org
Subject: + rtc-m48t59-driver-no_irq-mode-fixup.patch added to -mm tree
Date: Tue, 24 Jul 2007 19:37:15 -0700
Message-ID: <200707250237.l6P2bFks013055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775AbXGYChY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 22:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rongkai.zhan@windriver.com, a.zummo@towertech.it


The patch titled
     rtc-m48t59 driver NO_IRQ mode fixup
has been added to the -mm tree.  Its filename is
     rtc-m48t59-driver-no_irq-mode-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

no-need-to-convert-file-private_data-to-rtc-device.patch
rtc-m48t59-driver-no_irq-mode-fixup.patch
