Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32609CA100A
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 20:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbjIEUQG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 16:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238129AbjIEUQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 16:16:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3CC1A4
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 13:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E8FF2CE1269
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23105C433C9;
        Tue,  5 Sep 2023 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693930630;
        bh=yjAcVQroI+xCNyQyh60li5iG25oVPpFj/7+FTaw/YPA=;
        h=Date:To:From:Subject:From;
        b=I3yKJI89UIn7EzfK4lSieLIwyIbCGuLGa91QN7synuiwGvvEA0L4uFobeRgm/vHWD
         krxAjym1pv0rfUoTtKlM4i2MZyFc8GKbDgmjY+FPPAcsU/tlRXImZrn82NjCbA+IbP
         XhC6SGNCLaTDFaKKeOkwbPhHl46z6Uv97EpI52oU=
Date:   Tue, 05 Sep 2023 09:17:09 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        uma.shankar@intel.com, prime.zeng@hisilicon.com,
        martin.petersen@oracle.com, luojiaxing@huawei.com,
        john.g.garry@oracle.com, jejb@linux.ibm.com,
        himanshu.madhani@cavium.com, gregkh@linuxfoundation.org,
        felipe.balbi@linux.intel.com, damien.lemoal@opensource.wdc.com,
        chenxiang66@hisilicon.com, anshuman.gupta@intel.com,
        animesh.manna@intel.com, andriy.shevchenko@linux.intel.com,
        yangxingui@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch added to mm-nonmm-unstable branch
Message-Id: <20230905161710.23105C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: qla2xxx: use DEFINE_SHOW_STORE_ATTRIBUTE() helper for debugfs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xingui Yang <yangxingui@huawei.com>
Subject: scsi: qla2xxx: use DEFINE_SHOW_STORE_ATTRIBUTE() helper for debugfs
Date: Tue, 5 Sep 2023 02:48:35 +0000

Use DEFINE_SHOW_STORE_ATTRIBUTE() helper for read-write file to reduce some
duplicated code.

Link: https://lkml.kernel.org/r/20230905024835.43219-4-yangxingui@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Co-developed-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Xiang Chen <chenxiang66@hisilicon.com>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_dfs.c |   61 ++++---------------------------
 1 file changed, 8 insertions(+), 53 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_dfs.c~scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs
+++ a/drivers/scsi/qla2xxx/qla_dfs.c
@@ -518,51 +518,22 @@ qla_dfs_naqp_show(struct seq_file *s, vo
  *
  * Example for creating "TEST" sysfs file:
  * 1. struct qla_hw_data { ... struct dentry *dfs_TEST; }
- * 2. QLA_DFS_SETUP_RD(TEST, scsi_qla_host_t);
+ * 2. QLA_DFS_SETUP_RD(TEST);
  * 3. In qla2x00_dfs_setup():
  * QLA_DFS_CREATE_FILE(ha, TEST, 0600, ha->dfs_dir, vha);
  * 4. In qla2x00_dfs_remove():
  * QLA_DFS_REMOVE_FILE(ha, TEST);
  */
-#define QLA_DFS_SETUP_RD(_name, _ctx_struct)				\
-static int								\
-qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
-{									\
-	_ctx_struct *__ctx = inode->i_private;				\
-									\
-	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
-}									\
-									\
-static const struct file_operations qla_dfs_##_name##_ops = {		\
-	.open           = qla_dfs_##_name##_open,			\
-	.read           = seq_read,					\
-	.llseek         = seq_lseek,					\
-	.release        = single_release,				\
-};
-
-#define QLA_DFS_SETUP_RW(_name, _ctx_struct)				\
-static int								\
-qla_dfs_##_name##_open(struct inode *inode, struct file *file)		\
-{									\
-	_ctx_struct *__ctx = inode->i_private;				\
-									\
-	return single_open(file, qla_dfs_##_name##_show, __ctx);	\
-}									\
-									\
-static const struct file_operations qla_dfs_##_name##_ops = {		\
-	.open           = qla_dfs_##_name##_open,			\
-	.read           = seq_read,					\
-	.llseek         = seq_lseek,					\
-	.release        = single_release,				\
-	.write		= qla_dfs_##_name##_write,			\
-};
+#define QLA_DFS_SETUP_RD(_name)	DEFINE_SHOW_ATTRIBUTE(qla_dfs_##_name)
+
+#define QLA_DFS_SETUP_RW(_name)	DEFINE_SHOW_STORE_ATTRIBUTE(qla_dfs_##_name)
 
 #define QLA_DFS_ROOT_CREATE_FILE(_name, _perm, _ctx)			\
 	do {								\
 		if (!qla_dfs_##_name)					\
 			qla_dfs_##_name = debugfs_create_file(#_name,	\
 					_perm, qla2x00_dfs_root, _ctx,	\
-					&qla_dfs_##_name##_ops);	\
+					&qla_dfs_##_name##_fops);	\
 	} while (0)
 
 #define QLA_DFS_ROOT_REMOVE_FILE(_name)					\
@@ -577,7 +548,7 @@ static const struct file_operations qla_
 	do {								\
 		(_struct)->dfs_##_name = debugfs_create_file(#_name,	\
 					_perm, _parent, _ctx,		\
-					&qla_dfs_##_name##_ops)		\
+					&qla_dfs_##_name##_fops)	\
 	} while (0)
 
 #define QLA_DFS_REMOVE_FILE(_struct, _name)				\
@@ -588,14 +559,6 @@ static const struct file_operations qla_
 		}							\
 	} while (0)
 
-static int
-qla_dfs_naqp_open(struct inode *inode, struct file *file)
-{
-	struct scsi_qla_host *vha = inode->i_private;
-
-	return single_open(file, qla_dfs_naqp_show, vha);
-}
-
 static ssize_t
 qla_dfs_naqp_write(struct file *file, const char __user *buffer,
     size_t count, loff_t *pos)
@@ -643,15 +606,7 @@ out_free:
 	kfree(buf);
 	return rc;
 }
-
-static const struct file_operations dfs_naqp_ops = {
-	.open		= qla_dfs_naqp_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= qla_dfs_naqp_write,
-};
-
+QLA_DFS_SETUP_RW(naqp);
 
 int
 qla2x00_dfs_setup(scsi_qla_host_t *vha)
@@ -697,7 +652,7 @@ create_nodes:
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha) || IS_QLA28XX(ha)) {
 		ha->tgt.dfs_naqp = debugfs_create_file("naqp",
-		    0400, ha->dfs_dir, vha, &dfs_naqp_ops);
+		    0400, ha->dfs_dir, vha, &qla_dfs_naqp_fops);
 		if (!ha->tgt.dfs_naqp) {
 			ql_log(ql_log_warn, vha, 0xd011,
 			       "Unable to create debugFS naqp node.\n");
_

Patches currently in -mm which might be from yangxingui@huawei.com are

seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch
scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch
scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch

