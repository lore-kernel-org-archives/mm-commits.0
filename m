From: akpm@linux-foundation.org
Subject: + backlight-88pm860x_bl-add-missing-of_node_put.patch added to -mm tree
Date: Mon, 28 Jan 2013 14:08:14 -0800
Message-ID: <20130128220814.9138831C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47452 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3A1WIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 17:08:15 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so328423yen.5
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 14:08:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com, jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/88pm860x_bl.c: add missing of_node_put()
has been added to the -mm tree.  Its filename is
     backlight-88pm860x_bl-add-missing-of_node_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch
backlight-88pm860x_bl-add-missing-of_node_put.patch

