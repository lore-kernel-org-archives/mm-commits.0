From: akpm@linux-foundation.org
Subject: + rtc-parisc-remove-a-couple-unnecessary-variables.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:50:07 -0800
Message-ID: <200901262150.n0QLo70A004130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbZAZVvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     rtc-parisc: remove a couple unnecessary variables
has been added to the -mm tree.  Its filename is
     rtc-parisc-remove-a-couple-unnecessary-variables.patch

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
Subject: rtc-parisc: remove a couple unnecessary variables
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-remove-a-couple-unnecessary-variables drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-remove-a-couple-unnecessary-variables
+++ a/drivers/rtc/rtc-parisc.c
@@ -25,11 +25,7 @@ static int parisc_get_time(struct device
 
 static int parisc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	int ret;
-
-	ret = set_rtc_time(tm);
-
-	if (ret < 0)
+	if (set_rtc_time(tm) < 0)
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -46,10 +42,8 @@ static int __init parisc_rtc_probe(struc
 
 	p = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
 				THIS_MODULE);
-	if (IS_ERR(p)) {
-		int err = PTR_ERR(p);
-		return err;
-	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
 	platform_set_drvdata(dev, p);
 
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

