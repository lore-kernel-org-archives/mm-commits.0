Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C831AECAAD3
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiIKXit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIKXit (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D2D26552
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06C70B80BA3
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886BCC433D7;
        Sun, 11 Sep 2022 23:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662939525;
        bh=sR7ypbLKvF4qXeaWTucwh5vsaKPT1+noD6X+48iX/IY=;
        h=Date:To:From:Subject:From;
        b=PcQnwj6OOwY08e/vp3fbPHyCkMB9MMjuFidseo0q8EMP+gaLTsH7A2Pg4y+2J0zg+
         +e5dxZm9r1K2sfBtQif/pTh2acdPd4dRYPqY1wlGUbXz+Isq8wnAgnyjt18oxmsbVn
         1p5lwVboQM9n1lrthjFWRPi8zy0IpE/HVcYITqqA=
Date:   Sun, 11 Sep 2022 16:38:44 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, vbabka@suse.cz, surenb@google.com,
        skhan@linuxfoundation.org, shuah@kernel.org, rppt@linux.ibm.com,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        ldv@altlinux.org, jack@suse.cz, hughd@google.com,
        glebfm@altlinux.org, dave.hansen@linux.intel.com, corbet@lwn.net,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7.patch removed from -mm tree
Message-Id: <20220911233845.886BCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7.patch

This patch was dropped because it was folded into userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7
Date: Fri, 19 Aug 2022 13:51:58 -0700

Handle misc_register() failure properly by propagating the error instead
of just WARN_ON-ing.  

Link: https://lkml.kernel.org/r/20220819205201.658693-3-axelrasmussen@google.com
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dmitry V. Levin <ldv@altlinux.org>
Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control-v7
+++ a/fs/userfaultfd.c
@@ -2114,11 +2114,6 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	return new_userfaultfd(flags);
 }
 
-static int userfaultfd_dev_open(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-
 static long userfaultfd_dev_ioctl(struct file *file, unsigned int cmd, unsigned long flags)
 {
 	if (cmd != USERFAULTFD_IOC_NEW)
@@ -2128,7 +2123,6 @@ static long userfaultfd_dev_ioctl(struct
 }
 
 static const struct file_operations userfaultfd_dev_fops = {
-	.open = userfaultfd_dev_open,
 	.unlocked_ioctl = userfaultfd_dev_ioctl,
 	.compat_ioctl = userfaultfd_dev_ioctl,
 	.owner = THIS_MODULE,
@@ -2143,7 +2137,11 @@ static struct miscdevice userfaultfd_mis
 
 static int __init userfaultfd_init(void)
 {
-	WARN_ON(misc_register(&userfaultfd_misc));
+	int ret;
+
+	ret = misc_register(&userfaultfd_misc);
+	if (ret)
+		return ret;
 
 	userfaultfd_ctx_cachep = kmem_cache_create("userfaultfd_ctx_cache",
 						sizeof(struct userfaultfd_ctx),
_

Patches currently in -mm which might be from axelrasmussen@google.com are

selftests-vm-add-hugetlb_shared-userfaultfd-test-to-run_vmtestssh.patch
userfaultfd-add-dev-userfaultfd-for-fine-grained-access-control.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd.patch
userfaultfd-selftests-modify-selftest-to-use-dev-userfaultfd-v7.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd.patch
userfaultfd-update-documentation-to-describe-dev-userfaultfd-v7.patch
selftests-vm-add-dev-userfaultfd-test-cases-to-run_vmtestssh.patch
kselftests-removing-support-of-libhugetlbfs-from-kselftests-fix.patch

