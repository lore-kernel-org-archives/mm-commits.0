From: akpm@linux-foundation.org
Subject: - sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:22 -0700
Message-ID: <200805021942.m42JgMCV011187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301AbYEBTnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
has been removed from the -mm tree.  Its filename was
     sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_transport_spi uses sysfs_update_group() when CONFIG_SYSFS=n, so provide a
stub for it.

next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/sysfs.h~sysfs-sysfs_update_group-stub-for-config_sysfs=n include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-sysfs_update_group-stub-for-config_sysfs=n
+++ a/include/linux/sysfs.h
@@ -196,6 +196,12 @@ static inline int sysfs_update_group(str
 	return 0;
 }
 
+static inline int sysfs_update_group(struct kobject *kobj,
+				const struct attribute_group *grp)
+{
+	return 0;
+}
+
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
pnp-fix-missing-kernel-doc-notation.patch
x86-fix-setup-printk-format-warning.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-sched.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
uwb-fix-all-printk-format-warnings.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

