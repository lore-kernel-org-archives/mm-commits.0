Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31D0C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2E9A60FE9
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFHACw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhFHACv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2DBB6120F;
        Tue,  8 Jun 2021 00:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623110447;
        bh=gw+iP/piqSAW8vK2fTxzGpxONJIcTsEACunRrkzRXao=;
        h=Date:From:To:Subject:From;
        b=x5iDs63zODkZUTVtinQWXnh5pxvcftYSNFIOtrj+5mHdd7iKUxa40XvNNGWc2YCff
         e/PLd8Zd5oaDW9Ty49oVMZy4f4G6tRSv0LS3U7QwUC4B0IZYjlFLFT3O+n4zwMpJkI
         pvglIr0C6SsFBX7zSf6uMrRriUE2v3CoOMx3UJ1g=
Date:   Mon, 07 Jun 2021 17:00:47 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  +
 mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch
 added to -mm tree
Message-ID: <20210608000047.oveMu6ti4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix allocation error check and copy func name
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5130,7 +5130,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			 * contents.
 			 */
 			page = alloc_huge_page_vma(h, dst_vma, dst_addr);
-			if (IS_ERR(page)) {
+			if (!page) {
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -5156,7 +5156,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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
@@ -557,7 +557,7 @@ static void __copy_gigantic_page(struct
 	}
 }
 
-void migrate_copy_huge_page(struct page *dst, struct page *src)
+void copy_huge_page(struct page *dst, struct page *src)
 {
 	int i;
 	int nr_pages;
@@ -662,7 +662,7 @@ EXPORT_SYMBOL(migrate_page_states);
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
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix-2.patch

