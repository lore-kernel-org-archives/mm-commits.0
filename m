From: akpm@linux-foundation.org
Subject: [merged] aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:52 -0800
Message-ID: <20121218200952.97206100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:34224 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:53 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so126075ggm.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: "payload" sysfs file exports per-AoE-command data transfer size
has been removed from the -mm tree.  Its filename was
     aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: "payload" sysfs file exports per-AoE-command data transfer size

The userland aoetools package includes an "aoe-stat" command that can
display a "payload size" column when the aoe driver exports this
information.  Users can quickly see what amount of user data is
transferred inside each AoE command on the network, network headers
excluded.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/block/aoe/aoeblk.c~aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size
+++ a/drivers/block/aoe/aoeblk.c
@@ -98,6 +98,14 @@ static ssize_t aoedisk_show_fwver(struct
 
 	return snprintf(page, PAGE_SIZE, "0x%04x\n", (unsigned int) d->fw_ver);
 }
+static ssize_t aoedisk_show_payload(struct device *dev,
+				    struct device_attribute *attr, char *page)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct aoedev *d = disk->private_data;
+
+	return snprintf(page, PAGE_SIZE, "%lu\n", d->maxbcnt);
+}
 
 static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
@@ -106,12 +114,14 @@ static struct device_attribute dev_attr_
 	.attr = { .name = "firmware-version", .mode = S_IRUGO },
 	.show = aoedisk_show_fwver,
 };
+static DEVICE_ATTR(payload, S_IRUGO, aoedisk_show_payload, NULL);
 
 static struct attribute *aoe_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_mac.attr,
 	&dev_attr_netif.attr,
 	&dev_attr_firmware_version.attr,
+	&dev_attr_payload.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

