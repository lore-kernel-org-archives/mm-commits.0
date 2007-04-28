From: akpm@linux-foundation.org
Subject: - s390-cio-delay-uevents-for-subchannels.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:50:57 -0700
Message-ID: <200704281050.l3SAovJb019962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965638AbXD1KvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, eric.rannaud@gmail.com, greg@kroah.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     s390: cio: Delay uevents for subchannels
has been removed from the -mm tree.  Its filename was
     s390-cio-delay-uevents-for-subchannels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: cio: Delay uevents for subchannels
From: Cornelia Huck <cornelia.huck@de.ibm.com>

We often have the situation that we register a subchannel and start device
recognition, only to find out that the device is not usable after all, which
triggers an unregister of the subchannel.  This often happens on hundreds of
subchannels on a LPAR, leading to a storm of events which aren't of any use. 
Therefore, use uevent_suppress to delay the KOBJ_ADD uevent for a subchannel
until we know that its ccw_device is to be registered.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/cio/css.c    |    9 +++++++++
 drivers/s390/cio/device.c |    6 ++++++
 2 files changed, 15 insertions(+)

diff -puN drivers/s390/cio/css.c~s390-cio-delay-uevents-for-subchannels drivers/s390/cio/css.c
--- a/drivers/s390/cio/css.c~s390-cio-delay-uevents-for-subchannels
+++ a/drivers/s390/cio/css.c
@@ -135,6 +135,15 @@ css_register_subchannel(struct subchanne
 	sch->dev.bus = &css_bus_type;
 	sch->dev.release = &css_subchannel_release;
 	sch->dev.groups = subch_attr_groups;
+	/*
+	 * We don't want to generate uevents for I/O subchannels that don't
+	 * have a working ccw device behind them since they will be
+	 * unregistered before they can be used anyway, so we delay the add
+	 * uevent until after device recognition was successful.
+	 */
+	if (!cio_is_console(sch->schid))
+		/* Console is special, no need to suppress. */
+		sch->dev.uevent_suppress = 1;
 
 	css_get_ssd_info(sch);
 
diff -puN drivers/s390/cio/device.c~s390-cio-delay-uevents-for-subchannels drivers/s390/cio/device.c
--- a/drivers/s390/cio/device.c~s390-cio-delay-uevents-for-subchannels
+++ a/drivers/s390/cio/device.c
@@ -888,6 +888,12 @@ io_subchannel_register(struct work_struc
 		}
 		goto out;
 	}
+	/*
+	 * Now we know this subchannel will stay, we can throw
+	 * our delayed uevent.
+	 */
+	sch->dev.uevent_suppress = 0;
+	kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 	/* make it known to the system */
 	ret = ccw_device_register(cdev);
 	if (ret) {
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
