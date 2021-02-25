Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A75BC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B42664F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhBYThR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923F464F40;
        Thu, 25 Feb 2021 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280765;
        bh=I83TWsTc/2c9Wgov7oEsfNDjVu4yXw9q2jEw2yPKk18=;
        h=Date:From:To:Subject:From;
        b=YrYMqiuIavvYG92ug/JM/42vjxbWfmkrfFHFuTCV1uBjxCz3nzTHhsY+W1zx7IYCO
         nHIH3h8DROC1cOz+cP7N6B7O9bKBpWn1l1qvQ5eIz5hUFM8QSMVQo1dq9/bqW++EGT
         2m2i8AvSOB6eI8J3Sm5BhoqG1oac2JZUzfJawkQM=
Date:   Thu, 25 Feb 2021 11:19:25 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged] hugetlbfs-fix-some-comment-typos.patch removed
 from -mm tree
Message-ID: <20210225191925.t-iELAScb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix some comment typos
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-some-comment-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: fix some comment typos

Fix typos reserv to reserve, minimim to minimum. No functional change
intended.

Link: https://lkml.kernel.org/r/20210130092351.28072-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-some-comment-typos
+++ a/fs/hugetlbfs/inode.c
@@ -442,15 +442,15 @@ hugetlb_vmdelete_list(struct rb_root_cac
  *
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
- *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserv
+ *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserve
  *	maps and global counts.  Page faults can not race with truncation
  *	in this routine.  hugetlb_no_page() holds i_mmap_rwsem and prevents
  *	page faults in the truncated range by checking i_size.  i_size is
  *	modified while holding i_mmap_rwsem.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
- *	Only when releasing a page is the associated region/reserv map
- *	deleted.  The region/reserv map for ranges without associated
+ *	Only when releasing a page is the associated region/reserve map
+ *	deleted.  The region/reserve map for ranges without associated
  *	pages are not modified.  Page faults can race with hole punch.
  *	This is indicated if we find a mapped page.
  * Note: If the passed end of range value is beyond the end of file, but
@@ -1343,7 +1343,7 @@ hugetlbfs_fill_super(struct super_block
 
 	/*
 	 * Allocate and initialize subpool if maximum or minimum size is
-	 * specified.  Any needed reservations (for minimim size) are taken
+	 * specified.  Any needed reservations (for minimum size) are taken
 	 * taken when the subpool is created.
 	 */
 	if (ctx->max_hpages != -1 || ctx->min_hpages != -1) {
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

