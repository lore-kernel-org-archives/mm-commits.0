From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-add-modalias-linkage-for-mmc-sd-devices.patch removed from -mm tree
Date: Tue, 24 Feb 2009 13:35:11 -0800
Message-ID: <200902242135.n1OLZBNp012911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbZBXVfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:35:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: add MODALIAS linkage for MMC/SD devices
has been removed from the -mm tree.  Its filename was
     mmc-add-modalias-linkage-for-mmc-sd-devices.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: add MODALIAS linkage for MMC/SD devices
From: Andy Whitcroft <apw@canonical.com>

Currently we are using an explicit udev rule to trigger loading of the
mmc-block module when an MMC or SD card is detected:

    SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"

It makes much more sense for the mmc bus driver and the mmc-block module
to share MODALIAS information so that they are linked automatically.

Add MODALIAS attributes to the uevents as generated, and add the
corresponding MODULE_ALIAS marks to the mmc-block module so that it is
automatically loaded by udev.  I have followed the example set by the SCSI
subsystem in pushing out numeric typed aliases:

	mmc:t-0xNN

Where NN is the MMC type as defined in include/linux/mmc/card.h.  Numeric
types are used to allow automatic handling of new unknown types in the
core.  The matches are open on the right to allow additional fields to be
added as required in the future.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    3 +++
 drivers/mmc/core/bus.c   |    5 +++++
 include/linux/mmc/card.h |   10 +++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc-add-modalias-linkage-for-mmc-sd-devices drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-add-modalias-linkage-for-mmc-sd-devices
+++ a/drivers/mmc/card/block.c
@@ -41,6 +41,9 @@
 
 #include "queue.h"
 
+MODULE_ALIAS_MMC_DEVICE(MMC_TYPE_MMC);
+MODULE_ALIAS_MMC_DEVICE(MMC_TYPE_SD);
+
 /*
  * max 8 partitions per card
  */
diff -puN drivers/mmc/core/bus.c~mmc-add-modalias-linkage-for-mmc-sd-devices drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~mmc-add-modalias-linkage-for-mmc-sd-devices
+++ a/drivers/mmc/core/bus.c
@@ -84,6 +84,11 @@ mmc_bus_uevent(struct device *dev, struc
 	}
 
 	retval = add_uevent_var(env, "MMC_NAME=%s", mmc_card_name(card));
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(env, "MODALIAS=" MMC_DEVICE_MODALIAS_FMT,
+		card->type);
 
 	return retval;
 }
diff -puN include/linux/mmc/card.h~mmc-add-modalias-linkage-for-mmc-sd-devices include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-add-modalias-linkage-for-mmc-sd-devices
+++ a/include/linux/mmc/card.h
@@ -86,9 +86,9 @@ struct mmc_card {
 	struct device		dev;		/* the device */
 	unsigned int		rca;		/* relative card address of device */
 	unsigned int		type;		/* card type */
-#define MMC_TYPE_MMC		0		/* MMC card */
-#define MMC_TYPE_SD		1		/* SD card */
-#define MMC_TYPE_SDIO		2		/* SDIO card */
+#define MMC_TYPE_MMC		0x00		/* MMC card */
+#define MMC_TYPE_SD		0x01		/* SD card */
+#define MMC_TYPE_SDIO		0x02		/* SDIO card */
 	unsigned int		state;		/* (our) card state */
 #define MMC_STATE_PRESENT	(1<<0)		/* present in sysfs */
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
@@ -150,4 +150,8 @@ struct mmc_driver {
 extern int mmc_register_driver(struct mmc_driver *);
 extern void mmc_unregister_driver(struct mmc_driver *);
 
+#define MODULE_ALIAS_MMC_DEVICE(type) \
+	MODULE_ALIAS("mmc:t-" __stringify(type) "*")
+#define MMC_DEVICE_MODALIAS_FMT "mmc:t-0x%02x"
+
 #endif
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch
checkpatch-make-in_atomic-ok-in-the-core.patch
checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
checkpatch-pointer-type-star-may-have-modifiers-following.patch
checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
checkpatch-extend-attribute-testing-to-all-modifiers.patch
checkpatch-add-__ref-as-a-sparse-modifier.patch
checkpatch-version-028.patch

