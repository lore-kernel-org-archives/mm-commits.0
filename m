Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5A9C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E787364EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhBXUNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhBXUKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8022664F25;
        Wed, 24 Feb 2021 20:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197422;
        bh=yUN5ZcO0jc8n3cZluia1W28TtIUkTxd1OhTe483NuHw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YFcYL9n/0LZ2sQbT/npKdG23QuJykLGmLTBGLCPLf9CQlrcUeP9ooHXvtb5ZpLqzD
         9nFvSPfZA1pcqjPGZKmW6zhTyUpbq9GBcRv1hGjnmjelg1LmaGME7QvYatoSGrPyTO
         kYc2dVLAUzjYK5z76wDfscXeKd5/+C5PAgSx38fQ=
Date:   Wed, 24 Feb 2021 12:10:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 171/173] hugetlbfs: fix some comment typos
Message-ID: <20210224201021.2q1rLvHtB%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
