Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294A0C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 18:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE42720706
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 18:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732437AbhASS4B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 13:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390170AbhASSz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 13:55:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9CA20706;
        Tue, 19 Jan 2021 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611082518;
        bh=BAu0YBYFycxJuz80hS7JMXD5pS8OCLm3U8Mq03hn2Xw=;
        h=Date:From:To:Subject:From;
        b=hFC2oT4igce4QcCssWSzFV7SW7Y3ImAXCRevJU5YNUoSPB/RBAPNYdPsPriKM/8Bn
         yIBrq/+ybQxEyiSxKs/yLEl1hb1B8VHIrCAcpo2sYdGcFn4novMfIYak+nGu3fEUtd
         zdguO0NqGykyEjonFyejfSjEJn/sPHLpD6TMI06I=
Date:   Tue, 19 Jan 2021 10:55:17 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch added to
 -mm tree
Message-ID: <20210119185517.hnX_vk1sT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove useless BUG_ON(!inode) in hugetlbfs_setattr()
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove useless BUG_ON(!inode) in hugetlbfs_setattr()

When we reach here with inode = NULL, we should have crashed as inode has
already been dereferenced via hstate_inode.  So this BUG_ON(!inode) does
not take effect and should be removed.

Link: https://lkml.kernel.org/r/20210118110700.52506-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr
+++ a/fs/hugetlbfs/inode.c
@@ -760,8 +760,6 @@ static int hugetlbfs_setattr(struct dent
 	unsigned int ia_valid = attr->ia_valid;
 	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 
-	BUG_ON(!inode);
-
 	error = setattr_prepare(dentry, attr);
 	if (error)
 		return error;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

