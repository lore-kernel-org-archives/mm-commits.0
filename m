Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99F3C4332D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFD464E90
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhBYThT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234962AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 802F564FC6;
        Thu, 25 Feb 2021 19:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280748;
        bh=0Nt2WxrKhaA6Fl/BnbQag4607tIVr86Ycdphlf++C9k=;
        h=Date:From:To:Subject:From;
        b=Wt2RTPBq/qB5zzmgpwLkvHbsm3mAnaHCYUDNa1vcS/pDRyZgc6qIlVLLnOGtemBKm
         y9erIMR9yqZGepxbCf868sQL52CHTehax4J6IIs+OQIzCyhHv2GjlBs7jhu5hLo0gj
         sA71iBPw8pxFsqt4nmDqPSlz1abRJxSd2wmKLB0o=
Date:   Thu, 25 Feb 2021 11:19:08 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch removed
 from -mm tree
Message-ID: <20210225191908.jwP0eOQyg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove useless BUG_ON(!inode) in hugetlbfs_setattr()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -761,8 +761,6 @@ static int hugetlbfs_setattr(struct user
 	unsigned int ia_valid = attr->ia_valid;
 	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 
-	BUG_ON(!inode);
-
 	error = setattr_prepare(&init_user_ns, dentry, attr);
 	if (error)
 		return error;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

