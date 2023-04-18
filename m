Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD9CC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 19:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjDRTt1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjDRTtR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 15:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08547AF1F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 12:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C2261240
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 19:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA15C433AE;
        Tue, 18 Apr 2023 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681847348;
        bh=oCM98Cxxs3llJFqoNm5+m0S3vf2kQi249apkPR1b4jU=;
        h=Date:To:From:Subject:From;
        b=zSzmIuHuT8snrP58gev1c0ZIut6eQUS0/LweYQLULSKSHwCiQdnFJt8KsHN+BRKsg
         wqHGzNldK0J+zj9uJjFrtCO7uANUzgWNrBMX+BtWaKitdnHwjXARvO1LdUTrrv9fV7
         TYJpFg2eZe/GC0AE9NZBDGoDMNan7yN3Wah5bqe0=
Date:   Tue, 18 Apr 2023 12:49:08 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reduce-ioctl-stack-usage.patch added to mm-nonmm-unstable branch
Message-Id: <20230418194908.DAA15C433AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: reduce ioctl stack usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reduce-ioctl-stack-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reduce-ioctl-stack-usage.patch

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
Cc: Mark Fasheh <mark@fasheh.com>
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

mm-make-arch_has_descending_max_zone_pfns-static.patch
mm-make-arch_has_descending_max_zone_pfns-static-v2.patch
kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch
ocfs2-reduce-ioctl-stack-usage.patch

