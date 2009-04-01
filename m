From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-remove-struct-parisc_rtc.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:55 -0700
Message-ID: <200904011841.n31IftvF009517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763496AbZDATpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: remove struct parisc_rtc
has been removed from the -mm tree.  Its filename was
     rtc-parisc-remove-struct-parisc_rtc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: remove struct parisc_rtc
From: dann frazier <dannf@hp.com>

parisc_rtc now only includes an rtc_device pointer, so let's
just use the rtc_device type directly.

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-remove-struct-parisc_rtc drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-remove-struct-parisc_rtc
+++ a/drivers/rtc/rtc-parisc.c
@@ -11,11 +11,6 @@
 
 #include <asm/rtc.h>
 
-/* as simple as can be, and no simpler. */
-struct parisc_rtc {
-	struct rtc_device *rtc;
-};
-
 static int parisc_get_time(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long ret;
@@ -47,16 +42,16 @@ static const struct rtc_class_ops parisc
 
 static int __devinit parisc_rtc_probe(struct platform_device *dev)
 {
-	struct parisc_rtc *p;
+	struct rtc_device *p;
 
 	p = kzalloc(sizeof (*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 
-	p->rtc = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
-					THIS_MODULE);
-	if (IS_ERR(p->rtc)) {
-		int err = PTR_ERR(p->rtc);
+	p = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
+				THIS_MODULE);
+	if (IS_ERR(p)) {
+		int err = PTR_ERR(p);
 		kfree(p);
 		return err;
 	}
@@ -68,9 +63,9 @@ static int __devinit parisc_rtc_probe(st
 
 static int __devexit parisc_rtc_remove(struct platform_device *dev)
 {
-	struct parisc_rtc *p = platform_get_drvdata(dev);
+	struct rtc_device *p = platform_get_drvdata(dev);
 
-	rtc_device_unregister(p->rtc);
+	rtc_device_unregister(p);
 	kfree(p);
 
 	return 0;
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

