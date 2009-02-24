From: akpm@linux-foundation.org
Subject: + mmc-add-modalias-linkage-for-mmc-sd-devices.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:35:50 -0800
Message-ID: <200902242135.n1OLZoX4012936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759291AbZBXVf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, drzeus-mmc@drzeus.cx


The patch titled
     mmc: add MODALIAS linkage for MMC/SD devices
has been added to the -mm tree.  Its filename is
     mmc-add-modalias-linkage-for-mmc-sd-devices.patch

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
Subject: mmc: add MODALIAS linkage for MMC/SD devices
From: Andy Whitcroft <apw@canonical.com>

Currently we are using an explicit udev rule to trigger loading of the
mmc-block module when an MMC or SD card is detected:

    SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"

It makes much more sense for the mmc bus driver and the mmc-block module
to share MODALIAS information so that they are linked automatically.

There is no real information of use in the MMC system at the current time.
 All devices inserted require us to load the mmc-block device.  Until such
time as useful parameters exist simply reflect the module linkage via the
module alias below:

	mmc:block

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    2 ++
 drivers/mmc/core/bus.c   |    8 ++++++++
 2 files changed, 10 insertions(+)

diff -puN drivers/mmc/card/block.c~mmc-add-modalias-linkage-for-mmc-sd-devices drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-add-modalias-linkage-for-mmc-sd-devices
+++ a/drivers/mmc/card/block.c
@@ -41,6 +41,8 @@
 
 #include "queue.h"
 
+MODULE_ALIAS("mmc:block");
+
 /*
  * max 8 partitions per card
  */
diff -puN drivers/mmc/core/bus.c~mmc-add-modalias-linkage-for-mmc-sd-devices drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~mmc-add-modalias-linkage-for-mmc-sd-devices
+++ a/drivers/mmc/core/bus.c
@@ -84,6 +84,14 @@ mmc_bus_uevent(struct device *dev, struc
 	}
 
 	retval = add_uevent_var(env, "MMC_NAME=%s", mmc_card_name(card));
+	if (retval)
+		return retval;
+
+	/*
+	 * Request the mmc_block device.  Note: that this is a direct request
+	 * for the module it carries no information as to what is inserted.
+	 */
+	retval = add_uevent_var(env, "MODALIAS=mmc:block");
 
 	return retval;
 }
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

