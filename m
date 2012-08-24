From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:38 -0700
Message-ID: <20120824184139.19C3D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40164 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab2HXSll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:41 -0400
Received: by bkcjc3 with SMTP id jc3so106165bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shchepetkov@ispras.ru, a.zummo@towertech.it, chripell@fsfe.org, chrisv@cyberswitching.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: initialize dynamic sysfs attributes
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
Subject: drivers/rtc/rtc-pcf2123.c: initialize dynamic sysfs attributes

Dynamically allocated sysfs attributes must be initialized using
sysfs_attr_init(), otherwise lockdep complains: BUG: key <address> not in
.data!

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
Cc: Chris Verges <chrisv@cyberswitching.com>
Cc: Christian Pellegrin <chripell@fsfe.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -43,6 +43,7 @@
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
 
 #define DRV_VERSION "0.6"
 
@@ -292,6 +293,7 @@ static int __devinit pcf2123_probe(struc
 	pdata->rtc = rtc;
 
 	for (i = 0; i < 16; i++) {
+		sysfs_attr_init(&pdata->regs[i].attr.attr);
 		sprintf(pdata->regs[i].name, "%1x", i);
 		pdata->regs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
 		pdata->regs[i].attr.attr.name = pdata->regs[i].name;
_

Patches currently in -mm which might be from shchepetkov@ispras.ru are

origin.patch

