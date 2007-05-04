From: akpm@linux-foundation.org
Subject: + s390-fix-subsystem-removal-fallout.patch added to -mm tree
Date: Fri, 04 May 2007 12:55:36 -0700
Message-ID: <200705041955.l44Jtabs012750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161926AbXEDTzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 15:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com


The patch titled
     s390: fix subsystem removal fallout
has been added to the -mm tree.  Its filename is
     s390-fix-subsystem-removal-fallout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s390: fix subsystem removal fallout
From: Cornelia Huck <cornelia.huck@de.ibm.com>

This patch fixes compilation on s390 in the current driver tree. It
should probably be merged into
remove-struct-subsystem-as-it-is-no-longer-needed.patch.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/hypfs/inode.c |    2 +-
 arch/s390/kernel/ipl.c  |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/s390/hypfs/inode.c~s390-fix-subsystem-removal-fallout arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~s390-fix-subsystem-removal-fallout
+++ a/arch/s390/hypfs/inode.c
@@ -477,7 +477,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	kset_set_kset_s(&s390_subsys, hypervisor_subsys);
+	kobj_set_kset_s(&s390_subsys, hypervisor_subsys);
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff -puN arch/s390/kernel/ipl.c~s390-fix-subsystem-removal-fallout arch/s390/kernel/ipl.c
--- a/arch/s390/kernel/ipl.c~s390-fix-subsystem-removal-fallout
+++ a/arch/s390/kernel/ipl.c
@@ -814,23 +814,23 @@ static int __init ipl_register_fcp_files
 {
 	int rc;
 
-	rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_group(&ipl_subsys.kobj,
 				&ipl_fcp_attr_group);
 	if (rc)
 		goto out;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_parameter_attr);
 	if (rc)
 		goto out_ipl_parm;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_scp_data_attr);
 	if (!rc)
 		goto out;
 
-	sysfs_remove_bin_file(&ipl_subsys.kset.kobj, &ipl_parameter_attr);
+	sysfs_remove_bin_file(&ipl_subsys.kobj, &ipl_parameter_attr);
 
 out_ipl_parm:
-	sysfs_remove_group(&ipl_subsys.kset.kobj, &ipl_fcp_attr_group);
+	sysfs_remove_group(&ipl_subsys.kobj, &ipl_fcp_attr_group);
 out:
 	return rc;
 }
@@ -844,7 +844,7 @@ static int __init ipl_init(void)
 		return rc;
 	switch (ipl_info.type) {
 	case IPL_TYPE_CCW:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_ccw_attr_group);
 		break;
 	case IPL_TYPE_FCP:
@@ -852,11 +852,11 @@ static int __init ipl_init(void)
 		rc = ipl_register_fcp_files();
 		break;
 	case IPL_TYPE_NSS:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_nss_attr_group);
 		break;
 	default:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_unknown_attr_group);
 		break;
 	}
@@ -883,7 +883,7 @@ static int __init reipl_nss_init(void)
 
 	if (!MACHINE_IS_VM)
 		return 0;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_nss_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_nss_attr_group);
 	if (rc)
 		return rc;
 	strncpy(reipl_nss_name, kernel_nss_name, NSS_NAME_SIZE + 1);
@@ -898,7 +898,7 @@ static int __init reipl_ccw_init(void)
 	reipl_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_ccw_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_ccw);
 		return rc;
@@ -936,7 +936,7 @@ static int __init reipl_fcp_init(void)
 	reipl_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_fcp_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_fcp);
 		return rc;
@@ -988,7 +988,7 @@ static int __init dump_ccw_init(void)
 	dump_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_ccw_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_ccw);
 		return rc;
@@ -1012,7 +1012,7 @@ static int __init dump_fcp_init(void)
 	dump_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_fcp_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_fcp);
 		return rc;
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
s390-fix-subsystem-removal-fallout.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
