From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:34:59 -0700
Message-ID: <200709150234.l8F2Yxxj003362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759987AbXIOCfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: rtc-ds1553.c should use resource_size_t for base address
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-ds1742c-should-use-resource_size_t-for-base-address.patch
rtc-rtc-ds1553c-should-use-resource_size_t-for-base.patch
git-mips.patch
serial_txx9-cleanup-includes.patch
rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
