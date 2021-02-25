Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0DBC4332B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F46A64F2D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhBYTha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9680D64FC7;
        Thu, 25 Feb 2021 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280753;
        bh=cHonrgi0pdZszZNpFXazKeSbcZdlHY/exobMhYFrBZQ=;
        h=Date:From:To:Subject:From;
        b=XC3W3ctTKzkV0BZGnN+JLFjk2wilqpPhMy5y2OJv/dXQ04I8IM+pGYe5Q0a3BO63C
         faEfm9O+NG9qqeEjOxY+4wX56MmTbUQnb1fVQSlKZ6PmMB8LXuWfMeAZxYHSZ0fxC4
         HUheBF7Xn3bLlcNEDl2V373t8cWJSTWyviWVA/YM=
Date:   Thu, 25 Feb 2021 11:19:13 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
 removed from -mm tree
Message-ID: <20210225191913.enxKAJ16s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: correct obsolete function name in hugetlbfs_read_iter()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: correct obsolete function name in hugetlbfs_read_iter()

Since commit 36e789144267 ("kill do_generic_mapping_read"), the function
do_generic_mapping_read() is renamed to do_generic_file_read(). And then
commit 47c27bc46946 ("fs: pass iocb to do_generic_file_read") renamed it
to generic_file_buffered_read(). So replace do_generic_mapping_read() with
generic_file_buffered_read() to keep comment uptodate.

Link: https://lkml.kernel.org/r/20210118063210.47118-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter
+++ a/fs/hugetlbfs/inode.c
@@ -310,7 +310,7 @@ hugetlbfs_read_actor(struct page *page,
 
 /*
  * Support for read() - Find the page attached to f_mapping and copy out the
- * data. Its *very* similar to do_generic_mapping_read(), we can't use that
+ * data. Its *very* similar to generic_file_buffered_read(), we can't use that
  * since it has PAGE_SIZE assumptions.
  */
 static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
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

