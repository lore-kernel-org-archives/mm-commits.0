From: akpm@linux-foundation.org
Subject: [merged] virtio-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:55 -0800
Message-ID: <201001212127.o0LLRtGe030681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310Ab0AUV2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     virtio: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     virtio-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: virtio: fix section mismatch warnings
From: Jeff Mahoney <jeffm@suse.com>

Fix fixes the following warnings by renaming the driver structures to be
suffixed with _driver.

WARNING: drivers/virtio/virtio_balloon.o(.data+0x88): Section mismatch in reference from the variable virtio_balloon to the function .devexit.text:virtballoon_remove()

WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x88): Section mismatch in reference from the variable virtio_rng to the function .devexit.text:virtrng_remove()

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/virtio-rng.c |    6 +++---
 drivers/virtio/virtio_balloon.c     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/hw_random/virtio-rng.c~virtio-fix-section-mismatch-warnings drivers/char/hw_random/virtio-rng.c
--- a/drivers/char/hw_random/virtio-rng.c~virtio-fix-section-mismatch-warnings
+++ a/drivers/char/hw_random/virtio-rng.c
@@ -114,7 +114,7 @@ static struct virtio_device_id id_table[
 	{ 0 },
 };
 
-static struct virtio_driver virtio_rng = {
+static struct virtio_driver virtio_rng_driver = {
 	.driver.name =	KBUILD_MODNAME,
 	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
@@ -124,12 +124,12 @@ static struct virtio_driver virtio_rng =
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_rng);
+	return register_virtio_driver(&virtio_rng_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_rng);
+	unregister_virtio_driver(&virtio_rng_driver);
 }
 module_init(init);
 module_exit(fini);
diff -puN drivers/virtio/virtio_balloon.c~virtio-fix-section-mismatch-warnings drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio-fix-section-mismatch-warnings
+++ a/drivers/virtio/virtio_balloon.c
@@ -266,7 +266,7 @@ static void __devexit virtballoon_remove
 
 static unsigned int features[] = { VIRTIO_BALLOON_F_MUST_TELL_HOST };
 
-static struct virtio_driver virtio_balloon = {
+static struct virtio_driver virtio_balloon_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
@@ -279,12 +279,12 @@ static struct virtio_driver virtio_ballo
 
 static int __init init(void)
 {
-	return register_virtio_driver(&virtio_balloon);
+	return register_virtio_driver(&virtio_balloon_driver);
 }
 
 static void __exit fini(void)
 {
-	unregister_virtio_driver(&virtio_balloon);
+	unregister_virtio_driver(&virtio_balloon_driver);
 }
 module_init(init);
 module_exit(fini);
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
drivers-scsi-hpsac-fix-section-mismatch.patch

