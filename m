From: akpm@linux-foundation.org
Subject: + agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch added to -mm tree
Date: Tue, 28 Jul 2009 15:19:23 -0700
Message-ID: <200907282219.n6SMJNWc006969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbZG1WT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 18:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kjwinchester@gmail.com, airlied@linux.ie


The patch titled
     agp: correct missing cleanup on error in agp_add_bridge
has been added to the -mm tree.  Its filename is
     agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch

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
Subject: agp: correct missing cleanup on error in agp_add_bridge
From: Kevin Winchester <kjwinchester@gmail.com>

While investigating a kmemleak detected leak, I encountered the
agp_add_bridge function.  It appears to be responsible for freeing
the agp_bridge_data in the case of a failure, but it is only doing
so for some errors.

Fix it to always free the bridge data if a failure condition is
encountered.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/backend.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/backend.c~agp-correct-missing-cleanup-on-error-in-agp_add_bridge drivers/char/agp/backend.c
--- a/drivers/char/agp/backend.c~agp-correct-missing-cleanup-on-error-in-agp_add_bridge
+++ a/drivers/char/agp/backend.c
@@ -263,18 +263,22 @@ int agp_add_bridge(struct agp_bridge_dat
 {
 	int error;
 
-	if (agp_off)
-		return -ENODEV;
+	if (agp_off) {
+		error = -ENODEV;
+		goto err_put_bridge;
+	}
 
 	if (!bridge->dev) {
 		printk (KERN_DEBUG PFX "Erk, registering with no pci_dev!\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto err_put_bridge;
 	}
 
 	/* Grab reference on the chipset driver. */
 	if (!try_module_get(bridge->driver->owner)) {
 		dev_info(&bridge->dev->dev, "can't lock chipset driver\n");
-		return -EINVAL;
+		error = -EINVAL;
+		goto err_put_bridge;
 	}
 
 	error = agp_backend_initialize(bridge);
@@ -304,6 +308,7 @@ frontend_err:
 	agp_backend_cleanup(bridge);
 err_out:
 	module_put(bridge->driver->owner);
+err_put_bridge:
 	agp_put_bridge(bridge);
 	return error;
 }
_

Patches currently in -mm which might be from kjwinchester@gmail.com are

agp-correct-missing-cleanup-on-error-in-agp_add_bridge.patch

