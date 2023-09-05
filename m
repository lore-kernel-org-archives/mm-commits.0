Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B542AC83F3E
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 18:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbjIESTI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 14:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbjIESSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 14:18:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99731CE
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 11:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F68ECE1263
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958D5C433C7;
        Tue,  5 Sep 2023 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693930623;
        bh=JedMWBTlqe/ZWi+F7vV3Qwy5NXg4qKG6ghbkGo9O3b0=;
        h=Date:To:From:Subject:From;
        b=ule10/RE25/c2+cbvs+GIVNhH6P2+Ghn1AozP65eP1wInbQcx1KDZsEs6sWo2WF+t
         w2CIVZROJ7odsineVn0oFLJh1z2H5TFUltJrwyEDKuXzfkt9xIGB5uzW7AiAZCZ1gY
         Gv42pnz177bGzAroV0JPjBdtWJh+he8+1rJqxznI=
Date:   Tue, 05 Sep 2023 09:17:02 -0700
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
Subject: + seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch added to mm-nonmm-unstable branch
Message-Id: <20230905161703.958D5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: add helper macro to define attribute for rw file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch

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

seq_file-add-helper-macro-to-define-attribute-for-rw-file.patch
scsi-hisi_sas-use-define_show_store_attribute-helper-for-debugfs.patch
scsi-qla2xxx-use-define_show_store_attribute-helper-for-debugfs.patch

