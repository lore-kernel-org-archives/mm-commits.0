Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EBFC83F3E
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjIEQfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349309AbjIEQVn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 12:21:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5501FD0
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 09:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D6CB8125E
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91892C433C7;
        Tue,  5 Sep 2023 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693930626;
        bh=FARSS660gglU8dGY0DjsYptxsCw1yfXV8gUuoHa8kno=;
        h=Date:To:From:Subject:From;
        b=t7NpnHPGbgmiJLbBJZoDfx8B4t9o5jiLQnhvEGUB3ozdfTB5kNkDsgt8GoDxuDfP4
         efCxTMFTLk+4WmdQ5jeJ5cJHtId1B2redOo2YQKX2C/pLOm2nTF0LZWSFjpBqnQRzp
         ox59sGnEW3DK5ReVfnsojkHdUS+kZCA6jE3UaVwU=
Date:   Tue, 05 Sep 2023 09:17:05 -0700
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
Subject: + scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch added to mm-nonmm-unstable branch
Message-Id: <20230905161706.91892C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: hisi_sas: use DEFINE_SHOW_STORE_ATTRIBUTE() helper for debugfs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch

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

seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch
scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch
scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch

