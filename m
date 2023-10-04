Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40AEE936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245085AbjJDUY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245117AbjJDUXz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902B010C0
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D84C433CA;
        Wed,  4 Oct 2023 20:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451025;
        bh=GP3RjhOlyMfj3kersiHKnHtIf5cZ2DWIQ4z3aIJHA3s=;
        h=Date:To:From:Subject:From;
        b=DeHTZxEjf3OY9GdJr6gYlz1/2Np6aU51Hec5b9mRprmoaPxChs8zRhipssyeKyfds
         T1Q7e6OkJIVeVjkFCg3mJONUqB9RtMXFGaP/oNiBlXoRZ6qIw6M0XnJ+pcj/sRA4hl
         99Inrp5Yn3wquH5SbL2tL8Jvo+ItlEhVCoVHDD3I=
Date:   Wed, 04 Oct 2023 13:23:43 -0700
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
Subject: [merged mm-nonmm-stable] seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch removed from -mm tree
Message-Id: <20231004202344.F2D84C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: seq_file: add helper macro to define attribute for rw file
has been removed from the -mm tree.  Its filename was
     seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xingui Yang <yangxingui@huawei.com>
Subject: seq_file: add helper macro to define attribute for rw file
Date: Tue, 5 Sep 2023 02:48:33 +0000

Patch series "Add helper macro DEFINE_SHOW_STORE_ATTRIBUTE() at
seq_file.c", v6.

We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
for read-only file, but we found many of drivers also want a helper macro
for read-write file too.

So we add this helper macro to reduce duplicated code.


This patch (of 3):

We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
for read-only file, but many of drivers want a helper macro for read-write
file too.

So we add DEFINE_SHOW_STORE_ATTRIBUTE() helper to reduce duplicated code.

Link: https://lkml.kernel.org/r/20230905024835.43219-1-yangxingui@huawei.com
Link: https://lkml.kernel.org/r/20230905024835.43219-2-yangxingui@huawei.com
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

 include/linux/seq_file.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/seq_file.h~seq_file-add-helper-macro-to-define-attribute-for-rw-file
+++ a/include/linux/seq_file.h
@@ -207,6 +207,21 @@ static const struct file_operations __na
 	.release	= single_release,				\
 }
 
+#define DEFINE_SHOW_STORE_ATTRIBUTE(__name)				\
+static int __name ## _open(struct inode *inode, struct file *file)	\
+{									\
+	return single_open(file, __name ## _show, inode->i_private);	\
+}									\
+									\
+static const struct file_operations __name ## _fops = {			\
+	.owner		= THIS_MODULE,					\
+	.open		= __name ## _open,				\
+	.read		= seq_read,					\
+	.write		= __name ## _write,				\
+	.llseek		= seq_lseek,					\
+	.release	= single_release,				\
+}
+
 #define DEFINE_PROC_SHOW_ATTRIBUTE(__name)				\
 static int __name ## _open(struct inode *inode, struct file *file)	\
 {									\
_

Patches currently in -mm which might be from yangxingui@huawei.com are


