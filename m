Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0249BC04A68
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 18:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbiGZSjU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiGZSjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 14:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928E333366
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 11:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF976B81974
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8306CC433C1;
        Tue, 26 Jul 2022 18:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658860737;
        bh=2vSpBD2z6SUptnVP/0BKloHEZ8xPNRs9iMk6N2HyOTo=;
        h=Date:To:From:Subject:From;
        b=YkOzIqrBC0oGsP4nOmZs7YN/k0RMNcNglyaQZwmxhhwlFy7RrE3hFS2kZdppzMdak
         vb3AvX3DZWFlZhWKcDqaoUuQnU0OCwS0tYbgP463q8pVWWtejQi7QBHesZgrsKfM7t
         eDI/h+6dPiM+Wvc3zbCA9woLu/YL3vujx60Ndafk=
Date:   Tue, 26 Jul 2022 11:38:56 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-cleanup-some-comments-in-inodec.patch added to mm-unstable branch
Message-Id: <20220726183857.8306CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: cleanup some comments in inode.c
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-cleanup-some-comments-in-inodec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-cleanup-some-comments-in-inodec.patch

This patch will later appear in the mm-unstable branch at
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
Cc: <songmuchun@bytedance.com>
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
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch
mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch
mm-mempolicy-remove-unneeded-out-label.patch
hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch
hugetlbfs-use-helper-macro-sz_1km.patch
hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch
hugetlbfs-remove-unneeded-header-file.patch
hugetlbfs-cleanup-some-comments-in-inodec.patch
hugetlbfs-fix-inaccurate-comment-in-hugetlbfs_statfs.patch

