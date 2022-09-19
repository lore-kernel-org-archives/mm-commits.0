Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47551ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 20:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiISUxL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 16:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiISUxL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 16:53:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118274B492
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 13:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 922FE61B63
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 20:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E550C433C1;
        Mon, 19 Sep 2022 20:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663620789;
        bh=juMM02lNBJQ9rwCKYE1QfFST63CAQcM7VkbXnTGjXNY=;
        h=Date:To:From:Subject:From;
        b=j4OPR0S2TCyrghxolsMYLsr7JwAWn0BVcUE8eJ6mOE8rvKN8+yp3Vd6DSq1Xoy2xL
         G7CZRxFDTNw+TPHjl6XIjB3k89s9yCadGwxwXEXlbFElTMKuKWt7G0ZrSo1d7X8xMb
         m4WNyrpy0XiVGucPioPGl7YGomiNz/k1CLoxyWwY=
Date:   Mon, 19 Sep 2022 13:52:57 -0700
To:     mm-commits@vger.kernel.org, zhaogongyi@huawei.com,
        yangyicong@hisilicon.com, weiyongjun1@huawei.com,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rafael@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, david@redhat.com,
        corbet@lwn.net, akinobu.mita@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch added to mm-nonmm-unstable branch
Message-Id: <20220919205308.0E550C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: debugfs: fix error when writing negative value to atomic_t debugfs file
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch

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
Subject: debugfs: fix error when writing negative value to atomic_t debugfs file
Date: Tue, 20 Sep 2022 02:24:18 +0900

The simple attribute files do not accept a negative value since the commit
488dac0c9237 ("libfs: fix error cast of negative value in
simple_attr_write()"), so we have to use a 64-bit value to write a
negative value for a debugfs file created by debugfs_create_atomic_t().

This restores the previous behaviour by introducing
DEFINE_DEBUGFS_ATTRIBUTE_SIGNED for a signed value.

Link: https://lkml.kernel.org/r/20220919172418.45257-4-akinobu.mita@gmail.com
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


--- a/Documentation/fault-injection/fault-injection.rst~debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file
+++ a/Documentation/fault-injection/fault-injection.rst
@@ -83,9 +83,7 @@ configuration of fault-injection capabil
 - /sys/kernel/debug/fail*/times:
 
 	specifies how many times failures may happen at most. A value of -1
-	means "no limit". Note, though, that this file only accepts unsigned
-	values. So, if you want to specify -1, you better use 'printf' instead
-	of 'echo', e.g.: $ printf %#x -1 > times
+	means "no limit".
 
 - /sys/kernel/debug/fail*/space:
 
@@ -284,7 +282,7 @@ Application Examples
     echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo Y > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -338,7 +336,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 10 > /sys/kernel/debug/$FAILTYPE/probability
     echo 100 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 2 > /sys/kernel/debug/$FAILTYPE/verbose
     echo Y > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
@@ -369,7 +367,7 @@ Application Examples
     echo N > /sys/kernel/debug/$FAILTYPE/task-filter
     echo 100 > /sys/kernel/debug/$FAILTYPE/probability
     echo 0 > /sys/kernel/debug/$FAILTYPE/interval
-    printf %#x -1 > /sys/kernel/debug/$FAILTYPE/times
+    echo -1 > /sys/kernel/debug/$FAILTYPE/times
     echo 0 > /sys/kernel/debug/$FAILTYPE/space
     echo 1 > /sys/kernel/debug/$FAILTYPE/verbose
 
--- a/fs/debugfs/file.c~debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file
+++ a/fs/debugfs/file.c
@@ -378,8 +378,8 @@ ssize_t debugfs_attr_read(struct file *f
 }
 EXPORT_SYMBOL_GPL(debugfs_attr_read);
 
-ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
-			 size_t len, loff_t *ppos)
+static ssize_t debugfs_attr_write_xsigned(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos, bool is_signed)
 {
 	struct dentry *dentry = F_DENTRY(file);
 	ssize_t ret;
@@ -387,12 +387,28 @@ ssize_t debugfs_attr_write(struct file *
 	ret = debugfs_file_get(dentry);
 	if (unlikely(ret))
 		return ret;
-	ret = simple_attr_write(file, buf, len, ppos);
+	if (is_signed)
+		ret = simple_attr_write_signed(file, buf, len, ppos);
+	else
+		ret = simple_attr_write(file, buf, len, ppos);
 	debugfs_file_put(dentry);
 	return ret;
 }
+
+ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos)
+{
+	return debugfs_attr_write_xsigned(file, buf, len, ppos, false);
+}
 EXPORT_SYMBOL_GPL(debugfs_attr_write);
 
+ssize_t debugfs_attr_write_signed(struct file *file, const char __user *buf,
+			 size_t len, loff_t *ppos)
+{
+	return debugfs_attr_write_xsigned(file, buf, len, ppos, true);
+}
+EXPORT_SYMBOL_GPL(debugfs_attr_write_signed);
+
 static struct dentry *debugfs_create_mode_unsafe(const char *name, umode_t mode,
 					struct dentry *parent, void *value,
 					const struct file_operations *fops,
@@ -738,11 +754,11 @@ static int debugfs_atomic_t_get(void *da
 	*val = atomic_read((atomic_t *)data);
 	return 0;
 }
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t, debugfs_atomic_t_get,
 			debugfs_atomic_t_set, "%lld\n");
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t_ro, debugfs_atomic_t_get, NULL,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t_ro, debugfs_atomic_t_get, NULL,
 			"%lld\n");
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_t_wo, NULL, debugfs_atomic_t_set,
+DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(fops_atomic_t_wo, NULL, debugfs_atomic_t_set,
 			"%lld\n");
 
 /**
--- a/include/linux/debugfs.h~debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file
+++ a/include/linux/debugfs.h
@@ -45,7 +45,7 @@ struct debugfs_u32_array {
 
 extern struct dentry *arch_debugfs_dir;
 
-#define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+#define DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, __is_signed)	\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
 	__simple_attr_check_format(__fmt, 0ull);			\
@@ -56,10 +56,16 @@ static const struct file_operations __fo
 	.open	 = __fops ## _open,					\
 	.release = simple_attr_release,					\
 	.read	 = debugfs_attr_read,					\
-	.write	 = debugfs_attr_write,					\
+	.write	 = (__is_signed) ? debugfs_attr_write_signed : debugfs_attr_write,	\
 	.llseek  = no_llseek,						\
 }
 
+#define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
+	DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, false)
+
+#define DEFINE_DEBUGFS_ATTRIBUTE_SIGNED(__fops, __get, __set, __fmt)	\
+	DEFINE_DEBUGFS_ATTRIBUTE_XSIGNED(__fops, __get, __set, __fmt, true)
+
 typedef struct vfsmount *(*debugfs_automount_t)(struct dentry *, void *);
 
 #if defined(CONFIG_DEBUG_FS)
@@ -100,6 +106,8 @@ ssize_t debugfs_attr_read(struct file *f
 			size_t len, loff_t *ppos);
 ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
 			size_t len, loff_t *ppos);
+ssize_t debugfs_attr_write_signed(struct file *file, const char __user *buf,
+			size_t len, loff_t *ppos);
 
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, const char *new_name);
@@ -245,6 +253,13 @@ static inline ssize_t debugfs_attr_write
 					const char __user *buf,
 					size_t len, loff_t *ppos)
 {
+	return -ENODEV;
+}
+
+static inline ssize_t debugfs_attr_write_signed(struct file *file,
+					const char __user *buf,
+					size_t len, loff_t *ppos)
+{
 	return -ENODEV;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

libfs-add-define_simple_attribute_signed-for-signed-value.patch
lib-notifier-error-inject-fix-error-when-writing-errno-to-debugfs-file.patch
debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch

