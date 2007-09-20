From: akpm@linux-foundation.org
Subject: - rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:28 -0700
Message-ID: <200709202115.l8KLFSHI002910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXITVQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-ds1553.c should use resource_size_t for base address
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: rtc-ds1553.c should use resource_size_t for base address
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Currently the rtc driver, rtc-ds1552.c uses an unsigned long to store the
base mmio address of the NVRAM/RTC.  This breaks on 32-bit systems with
larger physical addresses.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-rtc-ds1553c-should-use-resource_size_t-for-base drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-rtc-ds1553c-should-use-resource_size_t-for-base
+++ a/drivers/rtc/rtc-ds1553.c
@@ -61,7 +61,7 @@
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	unsigned long baseaddr;
+	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 	int irq;
 	unsigned int irqen;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-mips.patch
serial_txx9-cleanup-includes.patch
rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
