Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6991DC433E9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13EDB23107
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbhASS5v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 13:57:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389819AbhASS5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 13:57:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7AAE20706;
        Tue, 19 Jan 2021 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611082622;
        bh=m4nEsgjoJCyf9QeZBCeuOaNH23G/H0L90WA6bbMWPk8=;
        h=Date:From:To:Subject:From;
        b=R8P9O3Qh3zCYOApflShPBkRbjaqohs+BscO8ALXNNk4VprTGMWfFA1d/9qRVVDXo8
         MhO0pJUcGDNiNxYsKFwCr0z+1yXasRmRvQiqyaMQTifenmbkDBQVW2QYYXsvL1p15G
         P1vWBfFNivG8ygCD+qhHP5Q6IshiO3Ch/JRGZYt8=
Date:   Tue, 19 Jan 2021 10:57:01 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch added
 to -mm tree
Message-ID: <20210119185701.P17foiJX7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: use helper macro default_hstate in init_hugetlbfs_fs
has been added to the -mm tree.  Its filename is
     hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch

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
Subject: hugetlbfs: use helper macro default_hstate in init_hugetlbfs_fs

Since commit e5ff215941d5 ("hugetlb: multiple hstates for multiple page
sizes"), we can use macro default_hstate to get the struct hstate which we
use by default.  But init_hugetlbfs_fs() forgot to use it.

Link: https://lkml.kernel.org/r/20210116091827.20982-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs
+++ a/fs/hugetlbfs/inode.c
@@ -1542,7 +1542,7 @@ static int __init init_hugetlbfs_fs(void
 		goto out_free;
 
 	/* default hstate mount is required */
-	mnt = mount_one_hugetlbfs(&hstates[default_hstate_idx]);
+	mnt = mount_one_hugetlbfs(&default_hstate);
 	if (IS_ERR(mnt)) {
 		error = PTR_ERR(mnt);
 		goto out_unreg;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

