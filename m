From: akpm@linux-foundation.org
Subject: - change-__init-to-__devinit-in-2-rtc-drivers.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:18 -0800
Message-ID: <200702122244.l1CMiIpN013576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030264AbXBLWof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     change __init to __devinit in 2 rtc drivers
has been removed from the -mm tree.  Its filename was
     change-__init-to-__devinit-in-2-rtc-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change __init to __devinit in 2 rtc drivers
From: Prarit Bhargava <prarit@redhat.com>

Change __init to __devinit in rtc drivers' probe functions.

Resolves MODPOST warnings:

WARNING: drivers/rtc/rtc-ds1553.o - Section mismatch: reference to
.init.text:ds1553_rtc_probe from .data.rel between 'ds1553_rtc_driver' (at
offset 0x0) and 'ds1553_nvram_attr'
WARNING: drivers/rtc/rtc-ds1742.o - Section mismatch: reference to
.init.text:ds1742_rtc_probe from .data.rel between 'ds1742_rtc_driver' (at
offset 0x0) and 'ds1742_nvram_attr'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    2 +-
 drivers/rtc/rtc-ds1742.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~change-__init-to-__devinit-in-2-rtc-drivers drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~change-__init-to-__devinit-in-2-rtc-drivers
+++ a/drivers/rtc/rtc-ds1553.c
@@ -297,7 +297,7 @@ static struct bin_attribute ds1553_nvram
 	.write = ds1553_nvram_write,
 };
 
-static int __init ds1553_rtc_probe(struct platform_device *pdev)
+static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
diff -puN drivers/rtc/rtc-ds1742.c~change-__init-to-__devinit-in-2-rtc-drivers drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~change-__init-to-__devinit-in-2-rtc-drivers
+++ a/drivers/rtc/rtc-ds1742.c
@@ -165,7 +165,7 @@ static struct bin_attribute ds1742_nvram
 	.write = ds1742_nvram_write,
 };
 
-static int __init ds1742_rtc_probe(struct platform_device *pdev)
+static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
change-__init-to-__devinit-for-isp116x_probe.patch
