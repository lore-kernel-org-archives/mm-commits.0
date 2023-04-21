Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D1DC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjDUVz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDUVzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38C410E6
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 559956529C
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3EDC433D2;
        Fri, 21 Apr 2023 21:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682114119;
        bh=6chTO+kzPtPKc6RCPPSxFrwP32mGSAAVwwmYkOEILcY=;
        h=Date:To:From:Subject:From;
        b=wvnIAmZVxDcGqcSlHrGnLjkIcRiynHKqdi9llRwvnsL/a2rT0vtFogxgus7Ihs96T
         Z10DhLhIW1bgiYSGS6eXpRkBwLUj+tnmnk+1JH54CAhUy0pA4G1A3i+HdsKM9oukgZ
         NQmX68kWF676BUBBWCwsnnic7bbLkAP1jwazVsSI=
Date:   Fri, 21 Apr 2023 14:55:19 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reduce-ioctl-stack-usage.patch removed from -mm tree
Message-Id: <20230421215519.AE3EDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: reduce ioctl stack usage
has been removed from the -mm tree.  Its filename was
     ocfs2-reduce-ioctl-stack-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ocfs2: reduce ioctl stack usage
Date: Mon, 17 Apr 2023 22:56:24 +0200

On 32-bit architectures with KASAN_STACK enabled, the total stack usage of
the ocfs2_ioctl function grows beyond the warning limit:

fs/ocfs2/ioctl.c: In function 'ocfs2_ioctl':
fs/ocfs2/ioctl.c:934:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

Move each of the variables into a basic block, and mark
ocfs2_info_handle() as noinline_for_stack, in order to have the variable
share stack slots.

Link: https://lkml.kernel.org/r/20230417205631.1956027-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/ioctl.c~ocfs2-reduce-ioctl-stack-usage
+++ a/fs/ocfs2/ioctl.c
@@ -803,8 +803,8 @@ bail:
  * a better backward&forward compatibility, since a small piece of
  * request will be less likely to be broken if disk layout get changed.
  */
-static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
-			     int compat_flag)
+static noinline_for_stack int
+ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info, int compat_flag)
 {
 	int i, status = 0;
 	u64 req_addr;
@@ -840,27 +840,26 @@ bail:
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
-	int new_clusters;
-	int status;
-	struct ocfs2_space_resv sr;
-	struct ocfs2_new_group_input input;
-	struct reflink_arguments args;
-	const char __user *old_path;
-	const char __user *new_path;
-	bool preserve;
-	struct ocfs2_info info;
 	void __user *argp = (void __user *)arg;
+	int status;
 
 	switch (cmd) {
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
+	{
+		struct ocfs2_space_resv sr;
+
 		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
 			return -EFAULT;
 
 		return ocfs2_change_file_space(filp, cmd, &sr);
+	}
 	case OCFS2_IOC_GROUP_EXTEND:
+	{
+		int new_clusters;
+
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
@@ -873,8 +872,12 @@ long ocfs2_ioctl(struct file *filp, unsi
 		status = ocfs2_group_extend(inode, new_clusters);
 		mnt_drop_write_file(filp);
 		return status;
+	}
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+	{
+		struct ocfs2_new_group_input input;
+
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
@@ -887,7 +890,14 @@ long ocfs2_ioctl(struct file *filp, unsi
 		status = ocfs2_group_add(inode, &input);
 		mnt_drop_write_file(filp);
 		return status;
+	}
 	case OCFS2_IOC_REFLINK:
+	{
+		struct reflink_arguments args;
+		const char __user *old_path;
+		const char __user *new_path;
+		bool preserve;
+
 		if (copy_from_user(&args, argp, sizeof(args)))
 			return -EFAULT;
 		old_path = (const char __user *)(unsigned long)args.old_path;
@@ -895,11 +905,16 @@ long ocfs2_ioctl(struct file *filp, unsi
 		preserve = (args.preserve != 0);
 
 		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
+	}
 	case OCFS2_IOC_INFO:
+	{
+		struct ocfs2_info info;
+
 		if (copy_from_user(&info, argp, sizeof(struct ocfs2_info)))
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 0);
+	}
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
_

Patches currently in -mm which might be from arnd@arndb.de are


