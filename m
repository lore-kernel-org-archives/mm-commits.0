From: akpm@linux-foundation.org
Subject: [merged] sdio-fix-reference-counting-in-sdio_remove_func.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:37 -0800
Message-ID: <200912182026.nBIKQbwB016542__3834.13450695134$1261168081$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598AbZLRU0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org, mm-commits@vger.kernel.org


The patch titled
     sdio: fix reference counting in sdio_remove_func()
has been removed from the -mm tree.  Its filename was
     sdio-fix-reference-counting-in-sdio_remove_func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: fix reference counting in sdio_remove_func()
From: Daniel Drake <dsd@laptop.org>

sdio_remove_func() needs to be more careful about reference counting.  It
can be called in error paths where sdio_add_func() has never been called
e.g.  mmc_attach_sdio error path --> mmc_sdio_remove --> sdio_remove_func

Signed-off-by: Daniel Drake <dsd@laptop.org>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_bus.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/sdio_bus.c~sdio-fix-reference-counting-in-sdio_remove_func drivers/mmc/core/sdio_bus.c
--- a/drivers/mmc/core/sdio_bus.c~sdio-fix-reference-counting-in-sdio_remove_func
+++ a/drivers/mmc/core/sdio_bus.c
@@ -248,12 +248,15 @@ int sdio_add_func(struct sdio_func *func
 /*
  * Unregister a SDIO function with the driver model, and
  * (eventually) free it.
+ * This function can be called through error paths where sdio_add_func() was
+ * never executed (because a failure occurred at an earlier point).
  */
 void sdio_remove_func(struct sdio_func *func)
 {
-	if (sdio_func_present(func))
-		device_del(&func->dev);
+	if (!sdio_func_present(func))
+		return;
 
+	device_del(&func->dev);
 	put_device(&func->dev);
 }
 
_

Patches currently in -mm which might be from dsd@laptop.org are


