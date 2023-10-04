Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0557DE936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244241AbjJDUYv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244811AbjJDUXh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A7019C
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE435C433CA;
        Wed,  4 Oct 2023 20:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451013;
        bh=qbe8mYaPjF+JPICiXOcIFVMWWBDDhoBMN8Rw3yhmuyM=;
        h=Date:To:From:Subject:From;
        b=vPxKcmYhlSAnrf5w+Vam4VK5eCMr1kY8b4BT35enCdpg8zgbSjjvakgBIexK2p6m1
         VIeCNwo4AVaI0qXRbZG1Yle6qNep/9alajDEUXFSFRdg94wBHVpc5ShDaOIHbSJYnc
         ErKXhVxT9ApKG8PYvzGVlKR8/8FxiBxebxdV/eD0=
Date:   Wed, 04 Oct 2023 13:23:31 -0700
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
Subject: [merged mm-nonmm-stable] scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch removed from -mm tree
Message-Id: <20231004202332.BE435C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scsi: hisi_sas: use DEFINE_SHOW_STORE_ATTRIBUTE() helper for debugfs
has been removed from the -mm tree.  Its filename was
     scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xingui Yang <yangxingui@huawei.com>
Subject: scsi: hisi_sas: use DEFINE_SHOW_STORE_ATTRIBUTE() helper for debugfs
Date: Tue, 5 Sep 2023 02:48:34 +0000

Use DEFINE_SHOW_STORE_ATTRIBUTE() helper for read-write file to reduce some
duplicated code.

Link: https://lkml.kernel.org/r/20230905024835.43219-3-yangxingui@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Co-developed-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  137 +----------------------
 1 file changed, 9 insertions(+), 128 deletions(-)

--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c~scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs
+++ a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3990,22 +3990,7 @@ static ssize_t debugfs_bist_linkrate_v3_
 
 	return count;
 }
-
-static int debugfs_bist_linkrate_v3_hw_open(struct inode *inode,
-					    struct file *filp)
-{
-	return single_open(filp, debugfs_bist_linkrate_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_linkrate_v3_hw_fops = {
-	.open = debugfs_bist_linkrate_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_linkrate_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_linkrate_v3_hw);
 
 static const struct {
 	int		value;
@@ -4080,22 +4065,7 @@ static ssize_t debugfs_bist_code_mode_v3
 
 	return count;
 }
-
-static int debugfs_bist_code_mode_v3_hw_open(struct inode *inode,
-					     struct file *filp)
-{
-	return single_open(filp, debugfs_bist_code_mode_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_code_mode_v3_hw_fops = {
-	.open = debugfs_bist_code_mode_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_code_mode_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_code_mode_v3_hw);
 
 static ssize_t debugfs_bist_phy_v3_hw_write(struct file *filp,
 					    const char __user *buf,
@@ -4129,22 +4099,7 @@ static int debugfs_bist_phy_v3_hw_show(s
 
 	return 0;
 }
-
-static int debugfs_bist_phy_v3_hw_open(struct inode *inode,
-				       struct file *filp)
-{
-	return single_open(filp, debugfs_bist_phy_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_phy_v3_hw_fops = {
-	.open = debugfs_bist_phy_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_phy_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_phy_v3_hw);
 
 static ssize_t debugfs_bist_cnt_v3_hw_write(struct file *filp,
 					const char __user *buf,
@@ -4177,22 +4132,7 @@ static int debugfs_bist_cnt_v3_hw_show(s
 
 	return 0;
 }
-
-static int debugfs_bist_cnt_v3_hw_open(struct inode *inode,
-					  struct file *filp)
-{
-	return single_open(filp, debugfs_bist_cnt_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_cnt_v3_hw_ops = {
-	.open = debugfs_bist_cnt_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_cnt_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_cnt_v3_hw);
 
 static const struct {
 	int		value;
@@ -4256,22 +4196,7 @@ static ssize_t debugfs_bist_mode_v3_hw_w
 
 	return count;
 }
-
-static int debugfs_bist_mode_v3_hw_open(struct inode *inode,
-					struct file *filp)
-{
-	return single_open(filp, debugfs_bist_mode_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_mode_v3_hw_fops = {
-	.open = debugfs_bist_mode_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_mode_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_mode_v3_hw);
 
 static ssize_t debugfs_bist_enable_v3_hw_write(struct file *filp,
 					       const char __user *buf,
@@ -4309,22 +4234,7 @@ static int debugfs_bist_enable_v3_hw_sho
 
 	return 0;
 }
-
-static int debugfs_bist_enable_v3_hw_open(struct inode *inode,
-					  struct file *filp)
-{
-	return single_open(filp, debugfs_bist_enable_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_bist_enable_v3_hw_fops = {
-	.open = debugfs_bist_enable_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_bist_enable_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_bist_enable_v3_hw);
 
 static const struct {
 	char *name;
@@ -4362,21 +4272,7 @@ static int debugfs_v3_hw_show(struct seq
 
 	return 0;
 }
-
-static int debugfs_v3_hw_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, debugfs_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_v3_hw_fops = {
-	.open = debugfs_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_v3_hw);
 
 static ssize_t debugfs_phy_down_cnt_v3_hw_write(struct file *filp,
 						const char __user *buf,
@@ -4407,22 +4303,7 @@ static int debugfs_phy_down_cnt_v3_hw_sh
 
 	return 0;
 }
-
-static int debugfs_phy_down_cnt_v3_hw_open(struct inode *inode,
-					   struct file *filp)
-{
-	return single_open(filp, debugfs_phy_down_cnt_v3_hw_show,
-			   inode->i_private);
-}
-
-static const struct file_operations debugfs_phy_down_cnt_v3_hw_fops = {
-	.open = debugfs_phy_down_cnt_v3_hw_open,
-	.read = seq_read,
-	.write = debugfs_phy_down_cnt_v3_hw_write,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_STORE_ATTRIBUTE(debugfs_phy_down_cnt_v3_hw);
 
 enum fifo_dump_mode_v3_hw {
 	FIFO_DUMP_FORVER =		(1U << 0),
@@ -4832,7 +4713,7 @@ static void debugfs_bist_init_v3_hw(stru
 			    hisi_hba, &debugfs_bist_phy_v3_hw_fops);
 
 	debugfs_create_file("cnt", 0600, hisi_hba->debugfs_bist_dentry,
-			    hisi_hba, &debugfs_bist_cnt_v3_hw_ops);
+			    hisi_hba, &debugfs_bist_cnt_v3_hw_fops);
 
 	debugfs_create_file("loopback_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry,
_

Patches currently in -mm which might be from yangxingui@huawei.com are


