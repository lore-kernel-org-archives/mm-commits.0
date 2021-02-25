Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D66C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E11B64F18
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhBYThP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234951AbhBYTfO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9119A64FC5;
        Thu, 25 Feb 2021 19:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280746;
        bh=DbvTQuK7zIt7BcDnhFfQv8Fmj1/EWRy+L1hOvToXAc8=;
        h=Date:From:To:Subject:From;
        b=GOGbehx5N1MhheXkssds7QCEEdZzPxj/kdWlcr7OWXngLekYyub4KY+lMULunwQ8v
         iBTSphwSRlKI6TcLRugcuHeiyy7/ev7FmM2qq58C5AdTHXzWKs0jr58EVoSjIrbm9A
         yQlKXfeg3lRuuIm0Iac+GT63P+yb92SMN6x8prH8=
Date:   Thu, 25 Feb 2021 11:19:05 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, dave@stgolabs.net, david@redhat.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch removed from -mm
 tree
Message-ID: <20210225191905.IUNCdDejE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove special hugetlbfs_set_page_dirty()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -952,17 +952,6 @@ static int hugetlbfs_symlink(struct user
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
@@ -1150,7 +1139,7 @@ static void hugetlbfs_destroy_inode(stru
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


