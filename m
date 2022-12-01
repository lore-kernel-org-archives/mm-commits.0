Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FAFC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiLAARV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiLAARA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83669077D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB29B81D17
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F23C433C1;
        Thu,  1 Dec 2022 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853630;
        bh=Hj0/WrPsroDdssMYLPgweZizw7aR0rQ0mubd/5ABSA8=;
        h=Date:To:From:Subject:From;
        b=gI1jjNLhdx6YCcyIPs0Es0ZqxHbLWpjLkuYcB0cqbvL4JuoMUtiVi0xI35FGjj22d
         Sa0T1IRnsAlpkILzaWlY3fL68Xbasr8R2ghPOQLAJ8dgX2yjXLzW4LRSuiPOQ1ON6x
         hx4+ukMUq8v/7r4lAENlDIMXJu1Ay4KXIBLn/fIo=
Date:   Wed, 30 Nov 2022 16:13:49 -0800
To:     mm-commits@vger.kernel.org, zhaogongyi@huawei.com,
        yangyicong@hisilicon.com, weiyongjun1@huawei.com,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rafael@kernel.org,
        osalvador@suse.de, gregkh@linuxfoundation.org, david@redhat.com,
        corbet@lwn.net, akinobu.mita@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch removed from -mm tree
Message-Id: <20221201001350.11F23C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: debugfs: fix error when writing negative value to atomic_t debugfs file
has been removed from the -mm tree.  Its filename was
     debugfs-fix-error-when-writing-negative-value-to-atomic_t-debugfs-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.rst |   10 +---
 fs/debugfs/file.c                                 |   28 +++++++++---
 include/linux/debugfs.h                           |   19 +++++++-
 3 files changed, 43 insertions(+), 14 deletions(-)

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
@@ -102,6 +108,8 @@ ssize_t debugfs_attr_read(struct file *f
 			size_t len, loff_t *ppos);
 ssize_t debugfs_attr_write(struct file *file, const char __user *buf,
 			size_t len, loff_t *ppos);
+ssize_t debugfs_attr_write_signed(struct file *file, const char __user *buf,
+			size_t len, loff_t *ppos);
 
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, const char *new_name);
@@ -251,6 +259,13 @@ static inline ssize_t debugfs_attr_write
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


