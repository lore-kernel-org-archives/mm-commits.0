From: akpm@linux-foundation.org
Subject: - sysfs-kill-unnecessary-attribute-owner-update.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:30 -0700
Message-ID: <200704132329.l3DNTUkd012627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161151AbXDMX3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: kill unnecessary attribute->owner (update)
has been removed from the -mm tree.  Its filename was
     sysfs-kill-unnecessary-attribute-owner-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: kill unnecessary attribute->owner (update)
From: Tejun Heo <htejun@gmail.com>

Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/ipl.c      |    2 --
 drivers/s390/cio/chsc.c     |    2 --
 drivers/s390/net/qeth_sys.c |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/s390/kernel/ipl.c~sysfs-kill-unnecessary-attribute-owner-update arch/s390/kernel/ipl.c
--- a/arch/s390/kernel/ipl.c~sysfs-kill-unnecessary-attribute-owner-update
+++ a/arch/s390/kernel/ipl.c
@@ -255,7 +255,6 @@ static struct bin_attribute ipl_paramete
 	.attr = {
 		.name = "binary_parameter",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_parameter_read,
@@ -279,7 +278,6 @@ static struct bin_attribute ipl_scp_data
 	.attr = {
 		.name = "scp_data",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_scp_data_read,
diff -puN drivers/s390/cio/chsc.c~sysfs-kill-unnecessary-attribute-owner-update drivers/s390/cio/chsc.c
--- a/drivers/s390/cio/chsc.c~sysfs-kill-unnecessary-attribute-owner-update
+++ a/drivers/s390/cio/chsc.c
@@ -898,7 +898,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement_chars",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_chars),
 	.read = chp_measurement_chars_read,
@@ -950,7 +949,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_entry),
 	.read = chp_measurement_read,
diff -puN drivers/s390/net/qeth_sys.c~sysfs-kill-unnecessary-attribute-owner-update drivers/s390/net/qeth_sys.c
--- a/drivers/s390/net/qeth_sys.c~sysfs-kill-unnecessary-attribute-owner-update
+++ a/drivers/s390/net/qeth_sys.c
@@ -993,7 +993,7 @@ static struct attribute_group qeth_osn_d
 
 #define QETH_DEVICE_ATTR(_id,_name,_mode,_show,_store)			     \
 struct device_attribute dev_attr_##_id = {				     \
-	.attr = {.name=__stringify(_name), .mode=_mode, .owner=THIS_MODULE },\
+	.attr = {.name=__stringify(_name), .mode=_mode, },\
 	.show	= _show,						     \
 	.store	= _store,						     \
 };
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
