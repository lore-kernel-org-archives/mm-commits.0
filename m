From: akpm@linux-foundation.org
Subject: [merged] c2port-fix-device_create-return-value-check.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:33 -0400
Message-ID: <201003261937.o2QJbWQL016613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0CZThl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-jani.1.nikula@nokia.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     c2port: fix device_create() return value check
has been removed from the -mm tree.  Its filename was
     c2port-fix-device_create-return-value-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: c2port: fix device_create() return value check
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Use IS_ERR() instead of comparing to NULL.

[akpm@linux-foundation.org: preserve the error code]
Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check
+++ a/drivers/misc/c2port/core.c
@@ -912,8 +912,8 @@ struct c2port_device *c2port_device_regi
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
-	if (unlikely(!c2dev->dev)) {
-		ret = -ENOMEM;
+	if (unlikely(IS_ERR(c2dev->dev))) {
+		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
 	}
 	dev_set_drvdata(c2dev->dev, c2dev);
_

Patches currently in -mm which might be from ext-jani.1.nikula@nokia.com are

origin.patch
linux-next.patch
errh-add-__must_check-to-error-pointer-handlers.patch

