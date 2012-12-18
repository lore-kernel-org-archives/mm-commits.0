From: akpm@linux-foundation.org
Subject: [merged] aoe-provide-ata-identify-device-content-to-user-on-request.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:05 -0800
Message-ID: <20121218201006.1AC75200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53994 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:08 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63387wib.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: provide ATA identify device content to user on request
has been removed from the -mm tree.  Its filename was
     aoe-provide-ata-identify-device-content-to-user-on-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: provide ATA identify device content to user on request

Make the aoe driver follow expected behavior when the user uses ioctl to
get the ATA device identify information, allowing access to model, serial
number, etc.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoeblk.c |   30 ++++++++++++++++++++++++++++++
 drivers/block/aoe/aoecmd.c |   16 ++++++++++++++++
 3 files changed, 47 insertions(+)

diff -puN drivers/block/aoe/aoe.h~aoe-provide-ata-identify-device-content-to-user-on-request drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-provide-ata-identify-device-content-to-user-on-request
+++ a/drivers/block/aoe/aoe.h
@@ -169,6 +169,7 @@ struct aoedev {
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
 	ulong ntargets;
 	ulong kicked;
+	char ident[512];
 };
 
 /* kthread tracking */
diff -puN drivers/block/aoe/aoeblk.c~aoe-provide-ata-identify-device-content-to-user-on-request drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-provide-ata-identify-device-content-to-user-on-request
+++ a/drivers/block/aoe/aoeblk.c
@@ -17,6 +17,7 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/moduleparam.h>
+#include <scsi/sg.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
@@ -212,9 +213,38 @@ aoeblk_getgeo(struct block_device *bdev,
 	return 0;
 }
 
+static int
+aoeblk_ioctl(struct block_device *bdev, fmode_t mode, uint cmd, ulong arg)
+{
+	struct aoedev *d;
+
+	if (!arg)
+		return -EINVAL;
+
+	d = bdev->bd_disk->private_data;
+	if ((d->flags & DEVFL_UP) == 0) {
+		pr_err("aoe: disk not up\n");
+		return -ENODEV;
+	}
+
+	if (cmd == HDIO_GET_IDENTITY) {
+		if (!copy_to_user((void __user *) arg, &d->ident,
+			sizeof(d->ident)))
+			return 0;
+		return -EFAULT;
+	}
+
+	/* udev calls scsi_id, which uses SG_IO, resulting in noise */
+	if (cmd != SG_IO)
+		pr_info("aoe: unknown ioctl 0x%x\n", cmd);
+
+	return -ENOTTY;
+}
+
 static const struct block_device_operations aoe_bdops = {
 	.open = aoeblk_open,
 	.release = aoeblk_release,
+	.ioctl = aoeblk_ioctl,
 	.getgeo = aoeblk_getgeo,
 	.owner = THIS_MODULE,
 };
diff -puN drivers/block/aoe/aoecmd.c~aoe-provide-ata-identify-device-content-to-user-on-request drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-provide-ata-identify-device-content-to-user-on-request
+++ a/drivers/block/aoe/aoecmd.c
@@ -799,6 +799,17 @@ aoecmd_sleepwork(struct work_struct *wor
 }
 
 static void
+ata_ident_fixstring(u16 *id, int ns)
+{
+	u16 s;
+
+	while (ns-- > 0) {
+		s = *id;
+		*id++ = s >> 8 | s << 8;
+	}
+}
+
+static void
 ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 {
 	u64 ssize;
@@ -833,6 +844,11 @@ ataid_complete(struct aoedev *d, struct 
 		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
 	}
 
+	ata_ident_fixstring((u16 *) &id[10<<1], 10);	/* serial */
+	ata_ident_fixstring((u16 *) &id[23<<1], 4);	/* firmware */
+	ata_ident_fixstring((u16 *) &id[27<<1], 20);	/* model */
+	memcpy(d->ident, id, sizeof(d->ident));
+
 	if (d->ssize != ssize)
 		printk(KERN_INFO
 			"aoe: %pm e%ld.%d v%04x has %llu sectors\n",
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

