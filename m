From: akpm@linux-foundation.org
Subject: - depcac-fix-handling-of-platorm_device_add-failure.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:18 -0700
Message-ID: <200704252040.l3PKeI3R012403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993162AbXDYUkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.righi@cineca.it, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     depca.c: fix handling of platorm_device_add() failure
has been removed from the -mm tree.  Its filename was
     depcac-fix-handling-of-platorm_device_add-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: depca.c: fix handling of platorm_device_add() failure
From: Andrea Righi <a.righi@cineca.it>

Fix a bug in depca_platform_probe().

We don't use a dynamic pointer for pldev->dev.platform_data, so it seems
that the correct way to proceed if platform_device_add(pldev) fails is to
explicitly set the pldev->dev.platform_data pointer to NULL, before calling
the platform_device_put(pldev), or it will be kfree'ed by
platform_device_release().

This will cause double-kfree if the driver is loaded when the hardware is not
present.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/depca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/depca.c~depcac-fix-handling-of-platorm_device_add-failure drivers/net/depca.c
--- a/drivers/net/depca.c~depcac-fix-handling-of-platorm_device_add-failure
+++ a/drivers/net/depca.c
@@ -1490,8 +1490,9 @@ static void __init depca_platform_probe 
 		depca_io_ports[i].device = pldev;
 
 		if (platform_device_add(pldev)) {
-			platform_device_put(pldev);
 			depca_io_ports[i].device = NULL;
+			pldev->dev.platform_data = NULL;
+			platform_device_put(pldev);
 			continue;
 		}
 
_

Patches currently in -mm which might be from a.righi@cineca.it are

origin.patch
