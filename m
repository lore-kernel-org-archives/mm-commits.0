Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B402C19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiG3BJl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED3287F6C
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DBDEB82926
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87CAC433D7;
        Sat, 30 Jul 2022 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143330;
        bh=PcZgYizg9F7Y9BeMcVsOcAYj0+H5WZWf4fF1xoUdVuk=;
        h=Date:To:From:Subject:From;
        b=S9MSBOTQiFZDSYBQU4lovaF/eyq/GQ6H1L+LcWnCg6qqSafDid0fHmtwEEfhQym7O
         0vGouganrpLVrQ6J+JVrEZ4tOek1r3k/dMnzrg3pBgUkX/OaYyd/SwyIRPTr6VTXmS
         JnpbI3x4spw/vI1Cpf+EYdqwG9/wGhIdHsPqYMdY=
Date:   Fri, 29 Jul 2022 18:08:49 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-cleanup-some-comments-in-inodec.patch removed from -mm tree
Message-Id: <20220730010849.E87CAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: cleanup some comments in inode.c
has been removed from the -mm tree.  Its filename was
     hugetlbfs-cleanup-some-comments-in-inodec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: cleanup some comments in inode.c
Date: Tue, 26 Jul 2022 22:29:17 +0800

The function generic_file_buffered_read has been renamed to filemap_read
since commit 87fa0f3eb267 ("mm/filemap: rename generic_file_buffered_read
to filemap_read").  Update the corresponding comment.  And duplicated
taken in hugetlbfs_fill_super is removed.

Link: https://lkml.kernel.org/r/20220726142918.51693-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-cleanup-some-comments-in-inodec
+++ a/fs/hugetlbfs/inode.c
@@ -323,8 +323,7 @@ hugetlbfs_read_actor(struct page *page,
 
 /*
  * Support for read() - Find the page attached to f_mapping and copy out the
- * data. Its *very* similar to generic_file_buffered_read(), we can't use that
- * since it has PAGE_SIZE assumptions.
+ * data. This provides functionality similar to filemap_read().
  */
 static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
@@ -1394,7 +1393,7 @@ hugetlbfs_fill_super(struct super_block
 	/*
 	 * Allocate and initialize subpool if maximum or minimum size is
 	 * specified.  Any needed reservations (for minimum size) are taken
-	 * taken when the subpool is created.
+	 * when the subpool is created.
 	 */
 	if (ctx->max_hpages != -1 || ctx->min_hpages != -1) {
 		sbinfo->spool = hugepage_new_subpool(ctx->hstate,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

