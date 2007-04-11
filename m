From: akpm@linux-foundation.org
Subject: + sysfs-kill-unnecessary-attribute-owner-update.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:34:06 -0700
Message-ID: <200704110634.l3B6Y64e030387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXDKGiC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:38:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com


The patch titled
     sysfs: kill unnecessary attribute->owner (update)
has been added to the -mm tree.  Its filename is
     sysfs-kill-unnecessary-attribute-owner-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
revert-gregkh-driver-sysfs-crash-debugging.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect-update.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-update.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
