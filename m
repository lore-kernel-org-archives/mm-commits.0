From: akpm@linux-foundation.org
Subject: + hpsa-make-device-attrs-static.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:46:39 -0800
Message-ID: <200911122346.nACNkdkJ002012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbZKLXrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com


The patch titled
     hpsa: make device attrs static
has been added to the -mm tree.  Its filename is
     hpsa-make-device-attrs-static.patch

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
Subject: hpsa: make device attrs static
From: Alex Chiang <achiang@hp.com>

No need to export those device attributes.

In fact, without this patch, we can trip over a build error if hpsa
is a built-in and another driver also declares and exports attributes
with the same name.

You'll see errors like:

	drivers/scsi/built-in.o: multiple definition of `dev_attr_lunid'
	drivers/block/built-in.o: first defined here

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-make-device-attrs-static drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-make-device-attrs-static
+++ a/drivers/scsi/hpsa.c
@@ -151,10 +151,10 @@ static int check_for_unit_attention(stru
 static void check_ioctl_unit_attention(struct ctlr_info *h,
 	struct CommandList *c);
 
-DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
-DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
-DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
-DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
+static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
+static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
+static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch
hpsa-make-device-attrs-static.patch
cciss-make-device-attrs-static.patch
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch

