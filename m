From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-dont-hardcode-resource-size.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:55 -0700
Message-ID: <20120820195655.B8A0E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34156 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2HTT44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:56 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4032395obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: don't hardcode resource size
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-dont-hardcode-resource-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

