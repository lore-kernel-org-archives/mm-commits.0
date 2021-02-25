Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D6AC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB1FE64F2A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhBYThD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234965AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A200B64F3D;
        Thu, 25 Feb 2021 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280759;
        bh=3w66xG8FWs+VD4vClP78aXBvBLBBJNlyAubVpcW2iss=;
        h=Date:From:To:Subject:From;
        b=laoRotI+XlM6vrvY1BwSfSx/ccC+8WGEs6fG4JP2urqHi5oktswfIykd+X+gK5FC0
         5lyg7tW5rHttZmHGCU9AdlRB5F8Xy8enl0Jh/IGph3pE4ebT469aPGscFInbp0LkSy
         9aUGuiL9lpI062qIM5/0nZAds/m7cMHuqh1M8yoo=
Date:   Thu, 25 Feb 2021 11:19:19 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-make-hugepage-size-conversion-more-readable.patch removed from
 -mm tree
Message-ID: <20210225191919.afosCpj0S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: make hugepage size conversion more readable
has been removed from the -mm tree.  Its filename was
     hugetlbfs-make-hugepage-size-conversion-more-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: make hugepage size conversion more readable

The calculation 1U << (h->order + PAGE_SHIFT - 10) is actually equal to
(PAGE_SHIFT << (h->order)) >> 10.  So we can make it more readable by
replace it with huge_page_size(h) >> 10.

Link: https://lkml.kernel.org/r/20210122083141.24548-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-make-hugepage-size-conversion-more-readable
+++ a/fs/hugetlbfs/inode.c
@@ -1520,8 +1520,8 @@ static struct vfsmount *__init mount_one
 		put_fs_context(fc);
 	}
 	if (IS_ERR(mnt))
-		pr_err("Cannot mount internal hugetlbfs for page size %uK",
-		       1U << (h->order + PAGE_SHIFT - 10));
+		pr_err("Cannot mount internal hugetlbfs for page size %luK",
+		       huge_page_size(h) >> 10);
 	return mnt;
 }
 
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

