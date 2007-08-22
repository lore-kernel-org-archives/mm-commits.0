From: akpm@linux-foundation.org
Subject: + update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch added to -mm tree
Date: Wed, 22 Aug 2007 14:07:16 -0700
Message-ID: <200708222107.l7ML7GHP004633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758814AbXHVVHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 17:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     update gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
has been added to the -mm tree.  Its filename is
     update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c     |    2 +-
 drivers/base/firmware_class.c |    1 -
 drivers/s390/crypto/ap_bus.c  |    2 +-
 drivers/spi/spi.c             |    2 +-
 sound/aoa/soundbus/core.c     |    6 +++---
 5 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/arch/powerpc/kernel/vio.c
@@ -373,7 +373,7 @@ static int vio_hotplug(struct device *de
 	dn = dev->archdata.of_node;
 	if (!dn)
 		return -ENODEV;
-	cp = of_get_property(dn, "compatible", &length);
+	cp = of_get_property(dn, "compatible", NULL);
 	if (!cp)
 		return -ENODEV;
 
diff -puN drivers/base/firmware_class.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/drivers/base/firmware_class.c
@@ -91,7 +91,6 @@ static void fw_dev_release(struct device
 static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
-	int i = 0, len = 0;
 
 	if (add_uevent_var(env, "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
diff -puN drivers/s390/crypto/ap_bus.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct drivers/s390/crypto/ap_bus.c
--- a/drivers/s390/crypto/ap_bus.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/drivers/s390/crypto/ap_bus.c
@@ -458,7 +458,7 @@ static int ap_bus_match(struct device *d
  * uevent function for AP devices. It sets up a single environment
  * variable DEV_TYPE which contains the hardware device type.
  */
-static int ap_uevent (struct device *dev, struct kobj_uevent_env)
+static int ap_uevent (struct device *dev, struct kobj_uevent_env *env)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
 	int retval = 0;
diff -puN drivers/spi/spi.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct drivers/spi/spi.c
--- a/drivers/spi/spi.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/drivers/spi/spi.c
@@ -71,7 +71,7 @@ static int spi_uevent(struct device *dev
 {
 	const struct spi_device		*spi = to_spi_device(dev);
 
-	add_uevent_var("MODALIAS=%s", spi->modalias);
+	add_uevent_var(env, "MODALIAS=%s", spi->modalias);
 	return 0;
 }
 
diff -puN sound/aoa/soundbus/core.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct sound/aoa/soundbus/core.c
--- a/sound/aoa/soundbus/core.c~update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/sound/aoa/soundbus/core.c
@@ -88,12 +88,12 @@ static int soundbus_uevent(struct device
 
 	compat = of_get_property(of->node, "compatible", &cplen);
 	while (compat && cplen > 0) {
-		int tmp = length;
+		int tmp = env->buflen;
 		retval = add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat);
 		if (retval)
 			return retval;
-		compat += length - tmp;
-		cplen -= length - tmp;
+		compat += env->buflen - tmp;
+		cplen -= env->buflen - tmp;
 		seen += 1;
 	}
 
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

update-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-2-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-3-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
scsi-send-media-state-change-modification-events.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
