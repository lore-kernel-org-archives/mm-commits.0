From: akpm@linux-foundation.org
Subject: [merged] backlight-88pm860x_bl-add-missing-of_node_put.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:12 -0800
Message-ID: <20130222204212.A4F285A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42009 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so103731vbi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, haojian.zhuang@gmail.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/88pm860x_bl.c: add missing of_node_put()
has been removed from the -mm tree.  Its filename was
     backlight-88pm860x_bl-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/video/backlight/88pm860x_bl.c: add missing of_node_put()

of_find_node_by_name() returns a node pointer with refcount incremented,
use of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against the node pass to
from parameter, thus we also need to call of_node_get(from) before calling
of_find_node_by_name().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-add-missing-of_node_put drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-add-missing-of_node_put
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -165,8 +165,10 @@ static int pm860x_backlight_dt_init(stru
 				    struct pm860x_backlight_data *data,
 				    char *name)
 {
-	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	struct device_node *nproot, *np;
 	int iset = 0;
+
+	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
 	nproot = of_find_node_by_name(nproot, "backlights");
@@ -184,6 +186,7 @@ static int pm860x_backlight_dt_init(stru
 			break;
 		}
 	}
+	of_node_put(nproot);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from axel.lin@ingics.com are

origin.patch
linux-next.patch

