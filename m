From: akpm@linux-foundation.org
Subject: + w1-omap-hdq-dont-hardcode-resource-size.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:12:45 -0700
Message-ID: <20120814231246.8B1805C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54373 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2HNXMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:12:49 -0400
Received: by wibhr14 with SMTP id hr14so45597wib.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:12:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbi@ti.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: don't hardcode resource size
has been added to the -mm tree.  Its filename is
     w1-omap-hdq-dont-hardcode-resource-size.patch

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
Subject: drivers/w1/masters/omap_hdq.c: don't hardcode resource size

We have the helpful resource_size() macro to calculate the size of the
memory resource for us, let's use it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-dont-hardcode-resource-size drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-dont-hardcode-resource-size
+++ a/drivers/w1/masters/omap_hdq.c
@@ -566,7 +566,7 @@ static int __devinit omap_hdq_probe(stru
 		goto err_resource;
 	}
 
-	hdq_data->hdq_base = ioremap(res->start, SZ_4K);
+	hdq_data->hdq_base = ioremap(res->start, resource_size(res));
 	if (!hdq_data->hdq_base) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		ret = -EINVAL;
_

Patches currently in -mm which might be from balbi@ti.com are

linux-next.patch
w1-omap-hdq-add-section-annotation-to-remove.patch
w1-omap-hdq-dont-hardcode-resource-size.patch
w1-omap-hdq-convert-to-module_platform_driver.patch
w1-omap-hdq-convert-to-devm_-functions.patch
w1-omap-hdq-remove-unnecessary-return.patch
w1-omap-hdq-drop-arch-dependency.patch

