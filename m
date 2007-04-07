From: akpm@linux-foundation.org
Subject: + depcac-fix-handling-of-platorm_device_add-failure.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:57:22 -0700
Message-ID: <200704070557.l375vMlB028654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXDGF5f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.righi@cineca.it, greg@kroah.com, jeff@garzik.org


The patch titled
     depca.c: fix handling of platorm_device_add() failure
has been added to the -mm tree.  Its filename is
     depcac-fix-handling-of-platorm_device_add-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: depca.c: fix handling of platorm_device_add() failure
From: Andrea Righi <a.righi@cineca.it>

Fix a bug in depca_platform_probe().

We don't use a dynamic pointer for pldev->dev.platform_data, so it seems
that the correct way to proceed if platform_device_add(pldev) fails is to
explicitly set the pldev->dev.platform_data pointer to NULL, before calling
the platform_device_put(pldev), or it will be kfree'ed by
platform_device_release().

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/depca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/depca.c~depcac-fix-handling-of-platorm_device_add-failure drivers/net/depca.c
--- a/drivers/net/depca.c~depcac-fix-handling-of-platorm_device_add-failure
+++ a/drivers/net/depca.c
@@ -1491,8 +1491,9 @@ static void __init depca_platform_probe 
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

depcac-fix-handling-of-platorm_device_add-failure.patch
