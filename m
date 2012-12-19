From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:11:51 -0800
Message-ID: <20121219001152.A540720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:53260 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2LSALy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:11:54 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so71107eaa.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:11:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liangs@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: fix alarm can't wake up system issue
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leo Song <liangs@marvell.com>
Subject: drivers/rtc/rtc-pxa.c: fix alarm can't wake up system issue

Fix alarm can't wake up system issue

Signed-off-by: Leo Song <liangs@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue
+++ a/drivers/rtc/rtc-pxa.c
@@ -309,8 +309,6 @@ static int pxa_rtc_proc(struct device *d
 }
 
 static const struct rtc_class_ops pxa_rtc_ops = {
-	.open = pxa_rtc_open,
-	.release = pxa_rtc_release,
 	.read_time = pxa_rtc_read_time,
 	.set_time = pxa_rtc_set_time,
 	.read_alarm = pxa_rtc_read_alarm,
@@ -350,7 +348,7 @@ static int __init pxa_rtc_probe(struct p
 		dev_err(dev, "No alarm IRQ resource defined\n");
 		goto err_ress;
 	}
