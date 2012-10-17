From: akpm@linux-foundation.org
Subject: + aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:44 -0700
Message-ID: <20121017221045.1D07C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40239 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:45 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so998975ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: "payload" sysfs file exports per-AoE-command data transfer size
has been added to the -mm tree.  Its filename is
     aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

