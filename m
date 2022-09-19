Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB9FECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 20:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiISUwu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 16:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiISUwt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 16:52:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A463765E
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 13:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3D01B81C55
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 20:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B065C433D6;
        Mon, 19 Sep 2022 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663620765;
        bh=b0QPWAwfTLV+jPtoVAiL2ntgdnKCOczSDpQdNGC0QN8=;
        h=Date:To:From:Subject:From;
        b=fVEE5X7co4m7mfoAF1uptwHQnvR3tCrHixXX/ywJhzE3isAk+9Ais7ChBELNVGHOj
         cwdJX40RrXVIBhFYQ52YISWskw3GZTfQmGIvyydUMa+PNidsG0tAz+dW6sFRWByAZZ
         usbgITlXPNNFRGv8uSxgud7wgbl9wIIOpYuMbQaQ=
Date:   Mon, 19 Sep 2022 13:52:37 -0700
To:     mm-commits@vger.kernel.org, zhaogongyi@huawei.com,
        yangyicong@hisilicon.com, weiyongjun1@huawei.com,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rafael@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, david@redhat.com,
        corbet@lwn.net, akinobu.mita@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + libfs-add-define_simple_attribute_signed-for-signed-value.patch added to mm-nonmm-unstable branch
Message-Id: <20220919205244.9B065C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     libfs-add-define_simple_attribute_signed-for-signed-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/libfs-add-define_simple_attribute_signed-for-signed-value.patch

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
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value
Date: Tue, 20 Sep 2022 02:24:16 +0900

Patch series "fix error when writing negative value to simple attribute
files".

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), but some attribute files want to accept a negative
value.


This patch (of 3):

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), so we have to use a 64-bit value to write a
negative value.

This adds DEFINE_SIMPLE_ATTRIBUTE_SIGNED for a signed value.

Link: https://lkml.kernel.org/r/20220919172418.45257-1-akinobu.mita@gmail.com
Link: https://lkml.kernel.org/r/20220919172418.45257-2-akinobu.mita@gmail.com
Fixes: 488dac0c9237 ("libfs: fix error cast of negative value in simple_attr_write()")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Zhao Gongyi <zhaogongyi@huawei.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/libfs.c~libfs-add-define_simple_attribute_signed-for-signed-value
+++ a/fs/libfs.c
@@ -995,8 +995,8 @@ out:
 EXPORT_SYMBOL_GPL(simple_attr_read);
 
 /* interpret the buffer as a number to call the set function with */
-ssize_t simple_attr_write(struct file *file, const char __user *buf,
-			  size_t len, loff_t *ppos)
+static ssize_t simple_attr_write_xsigned(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos, bool is_signed)
 {
 	struct simple_attr *attr;
 	unsigned long long val;
@@ -1017,7 +1017,10 @@ ssize_t simple_attr_write(struct file *f
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	ret = kstrtoull(attr->set_buf, 0, &val);
+	if (is_signed)
+		ret = kstrtoll(attr->set_buf, 0, &val);
+	else
+		ret = kstrtoull(attr->set_buf, 0, &val);
 	if (ret)
 		goto out;
 	ret = attr->set(attr->data, val);
@@ -1027,8 +1030,21 @@ out:
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
+
+ssize_t simple_attr_write(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, false);
+}
 EXPORT_SYMBOL_GPL(simple_attr_write);
 
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+			  size_t len, loff_t *ppos)
+{
+	return simple_attr_write_xsigned(file, buf, len, ppos, true);
+}
+EXPORT_SYMBOL_GPL(simple_attr_write_signed);
+
 /**
  * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
  * @sb:		filesystem to do the file handle conversion on
--- a/include/linux/fs.h~libfs-add-define_simple_attribute_signed-for-signed-value
+++ a/include/linux/fs.h
@@ -3471,7 +3471,7 @@ void simple_transaction_set(struct file
  * All attributes contain a text representation of a numeric value
  * that are accessed with the get() and set() functions.
  */
-#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, __is_signed)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
@@ -3482,10 +3482,16 @@ static const struct file_operations __fo
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
-	.write	 = simple_attr_write,					\
+	.write	 = (__is_signed) ? simple_attr_write_signed : simple_attr_write,	\
 	.llseek	 = generic_file_llseek,					\
 }
 
+#define DEFINE_SIMPLE_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, false)
+
+#define DEFINE_SIMPLE_ATTRIBUTE_SIGNED(__fops, __get, __set, __fmt)	\
+	DEFINE_SIMPLE_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, true)
+
 static inline __printf(1, 2)
 void __simple_attr_check_format(const char *fmt, ...)
 {
@@ -3500,6 +3506,8 @@ ssize_t simple_attr_read(struct file *fi
 			 size_t len, loff_t *ppos);
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
+ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
+				 size_t len, loff_t *ppos);
 
 struct ctl_table;
 int __init list_bdev_fs_names(char *buf, size_t size);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

libfs-add-define_simple_attribute_signed-for-signed-value.patch
lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch
debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch

