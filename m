From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-add-section-annotation-to-remove.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:51 -0700
Message-ID: <20120820195652.17D685C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54712 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2HTT4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:54 -0400
Received: by bkcjc3 with SMTP id jc3so311913bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: add section annotation to remove
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-add-section-annotation-to-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: add section annotation to remove

Trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-add-section-annotation-to-remove drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-add-section-annotation-to-remove
+++ a/drivers/w1/masters/omap_hdq.c
@@ -73,11 +73,11 @@ struct hdq_data {
 };
 
 static int __devinit omap_hdq_probe(struct platform_device *pdev);
-static int omap_hdq_remove(struct platform_device *pdev);
+static int __devexit omap_hdq_remove(struct platform_device *pdev);
 
 static struct platform_driver omap_hdq_driver = {
 	.probe =	omap_hdq_probe,
-	.remove =	omap_hdq_remove,
+	.remove =	__devexit_p(omap_hdq_remove),
 	.driver =	{
 		.name =	"omap_hdq",
 	},
@@ -628,7 +628,7 @@ err_kmalloc:
 
 }
 
-static int omap_hdq_remove(struct platform_device *pdev)
+static int __devexit omap_hdq_remove(struct platform_device *pdev)
 {
 	struct hdq_data *hdq_data = platform_get_drvdata(pdev);
 
_

Patches currently in -mm which might be from balbi@ti.com are

origin.patch
linux-next.patch

