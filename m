Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBAAC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7420361474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhGAAyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236309AbhGAAyD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:54:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADF4A6124B;
        Thu,  1 Jul 2021 00:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100693;
        bh=hvd3X0SMWebvSI87cBblvqddm0HNPRQlUZl3/Zw5VK4=;
        h=Date:From:To:Subject:From;
        b=qKqEbxmcQN2hV4wgzS++ko2n4ZPKMRGSaRZvLLMeLGpE0tl6BKUoHourGcx2DgGLP
         n4QByRjma3Mtxwtbn6NA/mcOU7ycti4L4rMj2I0GwlbL0JXq2FrR+h72QIw7690nij
         V1/3ONWysIYP1cq+0wq/1zy96p+gH37si9ZQ2pWY=
Date:   Wed, 30 Jun 2021 17:51:33 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  [folded-merged]
 mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch
 removed from -mm tree
Message-ID: <20210701005133.gN_D4BYqe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix allocation error check and copy func name
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch

This patch was dropped because it was folded into mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm, hugetlb: fix allocation error check and copy func name

The alloc_huge_page_vma() doesn't return error pointers, it returns NULL.

There is an existing migrate_page_copy() which not only copies the page
contents, but also page state/metadata.  People could get confused that
'migrate_page_copy' and 'migrate_copy_huge_page' do not have the same
functionality.  Rename to 'copy_huge_page()' to make it less likely folks
get confused.

Link: https://lkml.kernel.org/r/20210605010626.1459873-1-almasrymina@google.com
Fixes: 6a0badc266df ("mm, hugetlb: fix racy resv_huge_pages underflow on
UFFDIO_COPY")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 mm/hugetlb.c            |    4 ++--
 mm/migrate.c            |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/migrate.h~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2
+++ a/include/linux/migrate.h
@@ -51,7 +51,7 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
-extern void migrate_copy_huge_page(struct page *dst, struct page *src);
+extern void copy_huge_page(struct page *dst, struct page *src);
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
@@ -78,7 +78,7 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
-static inline void migrate_copy_huge_page(struct page *dst, struct page *src)
+static inline void copy_huge_page(struct page *dst, struct page *src)
 {
 }
 #endif /* CONFIG_MIGRATION */
--- a/mm/hugetlb.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2
+++ a/mm/hugetlb.c
@@ -5126,7 +5126,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			 * contents.
 			 */
 			page = alloc_huge_page_vma(h, dst_vma, dst_addr);
-			if (IS_ERR(page)) {
+			if (!page) {
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -5152,7 +5152,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			*pagep = NULL;
 			goto out;
 		}
-		migrate_copy_huge_page(page, *pagep);
+		copy_huge_page(page, *pagep);
 		put_page(*pagep);
 		*pagep = NULL;
 	}
--- a/mm/migrate.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2
+++ a/mm/migrate.c
@@ -553,7 +553,7 @@ static void __copy_gigantic_page(struct
 	}
 }
 
-void migrate_copy_huge_page(struct page *dst, struct page *src)
+void copy_huge_page(struct page *dst, struct page *src)
 {
 	int i;
 	int nr_pages;
@@ -658,7 +658,7 @@ EXPORT_SYMBOL(migrate_page_states);
 void migrate_page_copy(struct page *newpage, struct page *page)
 {
 	if (PageHuge(page) || PageTransHuge(page))
-		migrate_copy_huge_page(newpage, page);
+		copy_huge_page(newpage, page);
 	else
 		copy_highpage(newpage, page);
 
_

Patches currently in -mm which might be from almasrymina@google.com are

mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

