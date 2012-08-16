From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:51:20 -0700
Message-ID: <20120816185120.AFD9C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:60881 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2HPSvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:51:22 -0400
Received: by obbwc20 with SMTP id wc20so2153974obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:51:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shchepetkov@ispras.ru, a.zummo@towertech.it, chripell@fsfe.org, chrisv@cyberswitching.com


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: initialize dynamic sysfs attributes
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-rtc-pcf2123c-initialize-dynamic-sysfs-attributes.patch

