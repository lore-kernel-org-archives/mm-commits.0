From: akpm@linux-foundation.org
Subject: + w1-omap-hdq-add-section-annotation-to-remove.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:12:42 -0700
Message-ID: <20120814231243.4B4BA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56742 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2HNXMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:12:44 -0400
Received: by obbwc20 with SMTP id wc20so733742obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:12:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbi@ti.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: add section annotation to remove
has been added to the -mm tree.  Its filename is
     w1-omap-hdq-add-section-annotation-to-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
w1-omap-hdq-add-section-annotation-to-remove.patch
w1-omap-hdq-dont-hardcode-resource-size.patch
w1-omap-hdq-convert-to-module_platform_driver.patch
w1-omap-hdq-convert-to-devm_-functions.patch
w1-omap-hdq-remove-unnecessary-return.patch
w1-omap-hdq-drop-arch-dependency.patch

