Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3194C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F89F64EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhBXUMu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235489AbhBXUKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0BF64F27;
        Wed, 24 Feb 2021 20:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197399;
        bh=4MJ/NAWmYYe0nNVtU+J2jEVOC5245uE7UWy6odDvmxY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZSGxZixPGLYWxGeGgrzyLUaOSIDxEaPVamXsmgvyt44UQstEJ9IpUBbqvNKARSWNl
         6lqFahkY/9Eg/PEfoqs/R8BcIj06sWRWYfIMHvEU/XOcyo9OThAKJbPKTpnAZTcVdc
         JUuqE+jJ++M/MmFkHW9G2jX5PDwkgaRe/Q2iYLcs=
Date:   Wed, 24 Feb 2021 12:09:58 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        dave@stgolabs.net, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 164/173] hugetlbfs: remove special
 hugetlbfs_set_page_dirty()
Message-ID: <20210224200958.LUMxEgoR8%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
