Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0872EC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C69B764F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhBYTg7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234946AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B0A64FC4;
        Thu, 25 Feb 2021 19:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280750;
        bh=6nj7QeXI+hY10K2AflhKboM8/UTqcGkHv0bLL72gF7A=;
        h=Date:From:To:Subject:From;
        b=b7iDgNXI/jtj/NyCxCFl3svL3V4EOjTzUx40opJkYAyEVxcrlyT7unFKPdRXH2h8+
         EdgqfhsHr9FLuC7A+qxG92FtMgjYiau3t/uTcvQ5g8hokISKehBUv9sNEPgWeMYod+
         qLHk9tJ88ys6HUXi/W8EcpKqY/iO+P7tGQz58WII=
Date:   Thu, 25 Feb 2021 11:19:10 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
 removed from -mm tree
Message-ID: <20210225191910.fbSGecvmT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: use helper macro default_hstate in init_hugetlbfs_fs
has been removed from the -mm tree.  Its filename was
     hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1543,7 +1543,7 @@ static int __init init_hugetlbfs_fs(void
 		goto out_free;
 
 	/* default hstate mount is required */
-	mnt = mount_one_hugetlbfs(&hstates[default_hstate_idx]);
+	mnt = mount_one_hugetlbfs(&default_hstate);
 	if (IS_ERR(mnt)) {
 		error = PTR_ERR(mnt);
 		goto out_unreg;
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

