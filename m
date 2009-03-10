From: akpm@linux-foundation.org
Subject: [merged] mmc-add-modalias-linkage-for-mmc-sd-devices.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:45 -0700
Message-ID: <200903101826.n2AIQjf0022665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901AbZCJS2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:28:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, drzeus-mmc@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: add MODALIAS linkage for MMC/SD devices
has been removed from the -mm tree.  Its filename was
     mmc-add-modalias-linkage-for-mmc-sd-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

