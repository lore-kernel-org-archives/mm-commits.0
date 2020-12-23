Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D66DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD07207B1
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 00:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgLWAry (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 19:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLWArx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 19:47:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FD24207A8;
        Wed, 23 Dec 2020 00:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608684432;
        bh=cd0lT7YeqEGlrqzAQT0Dk6cBy8RHQpyXXXT/EtUIZmA=;
        h=Date:From:To:Subject:From;
        b=qrmN1+mnc+UtbpzO7ufy5okbia6JClihEJNAJblri1rekcERBCYEig8ZN7aLRrM7M
         88hPti0XlEESprZtyFWtcsWiFcP7ZbP8p21AicsaLa5NYdNyY/dkTzMED/IL9+FqCa
         hafdBk3rN1k4XESsFrUFZx3GkyFOxkwOEdztP7Zo=
Date:   Tue, 22 Dec 2020 16:47:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, mhocko@kernel.org,
        david@redhat.com, dave@stgolabs.net, dan.carpenter@oracle.com,
        mike.kravetz@oracle.com
Subject:  + hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch
 added to -mm tree
Message-ID: <20201223004712.XJ38s%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove special hugetlbfs_set_page_dirty()
has been added to the -mm tree.  Its filename is
     hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: remove special hugetlbfs_set_page_dirty()

Matthew Wilcox noticed that hugetlbfs_set_page_dirty always returns 0. 
Instead, it should return 1 or 0 depending on the previous state of the
dirty bit.  In addition, the call to compound_head is redundant as it is
also performed in calling routine set_page_dirty.

Replace the hugetlbfs specific routine hugetlbfs_set_page_dirty with
__set_page_dirty_no_writeback as it addresses both of these issues.

Link: https://lkml.kernel.org/r/20201221192542.15732-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-special-hugetlbfs_set_page_dirty
+++ a/fs/hugetlbfs/inode.c
@@ -944,17 +944,6 @@ static int hugetlbfs_symlink(struct inod
 	return error;
 }
 
-/*
- * mark the head page dirty
- */
-static int hugetlbfs_set_page_dirty(struct page *page)
-{
-	struct page *head = compound_head(page);
-
-	SetPageDirty(head);
-	return 0;
-}
-
 static int hugetlbfs_migrate_page(struct address_space *mapping,
 				struct page *newpage, struct page *page,
 				enum migrate_mode mode)
@@ -1148,7 +1137,7 @@ static void hugetlbfs_destroy_inode(stru
 static const struct address_space_operations hugetlbfs_aops = {
 	.write_begin	= hugetlbfs_write_begin,
 	.write_end	= hugetlbfs_write_end,
-	.set_page_dirty	= hugetlbfs_set_page_dirty,
+	.set_page_dirty	=  __set_page_dirty_no_writeback,
 	.migratepage    = hugetlbfs_migrate_page,
 	.error_remove_page	= hugetlbfs_error_remove_page,
 };
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-fix-deadlock-in-hugetlb_cow-error-path.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

