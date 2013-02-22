From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:14 -0800
Message-ID: <20130222204314.96FF331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:40681 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3BVUnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:16 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so104416qeb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangs@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: fix alarm can't wake up system issue
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
