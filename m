From: akpm@linux-foundation.org
Subject: + sdio-fix-reference-counting-in-sdio_remove_func.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:52:16 -0800
Message-ID: <200912022352.nB2NqG7d001766__48102.1229330965$1259797992$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791AbZLBXwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     sdio: fix reference counting in sdio_remove_func()
has been added to the -mm tree.  Its filename is
     sdio-fix-reference-counting-in-sdio_remove_func.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

sdio-fix-reference-counting-in-sdio_remove_func.patch

