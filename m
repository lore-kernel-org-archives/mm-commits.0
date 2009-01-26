From: akpm@linux-foundation.org
Subject: + rtc-parisc-remove-struct-parisc_rtc.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:49:57 -0800
Message-ID: <200901262149.n0QLnvIH003894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbZAZVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     rtc-parisc: remove struct parisc_rtc
has been added to the -mm tree.  Its filename is
     rtc-parisc-remove-struct-parisc_rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-parisc-add-a-missing-include-for-linux-rtch.patch
rtc-parisc-remove-redundant-locking.patch
rtc-parisc-remove-struct-parisc_rtc.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
rtc-parisc-use-platform_driver_probe.patch
rtc-parisc-declare-rtc_parisc_dev-as-static.patch
rtc-parisc-remove-unnecessary-ret-variable.patch
rtc-parisc-remove-a-couple-unnecessary-variables.patch
rtc-parisc-rename-p-pointer-to-rtc.patch

