Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41646C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D6D61130
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbhIHC5F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347302AbhIHC5D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B9C6112F;
        Wed,  8 Sep 2021 02:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069756;
        bh=nFrc7mZ8EW1yGDw5KjWEW6ACBx0L2kgLk7MwftLmXew=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TuC3dM81Wun7lQbvNjcdRycGlb14liTYWYEqZcFtPF5BbfvhG6wgN9tknnhy0qu3m
         OVrlGwOQVN7OGG5Uyy1lblWb8+Sh+zr+dl0W6E7o1YVJjGJEmBoqUkxl8V+oFYC68D
         /C+VR3k9ua5Mom8L39z7OmR/Djz56344STHlJu7M=
Date:   Tue, 07 Sep 2021 19:55:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, hannes@cmpxchg.org,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [patch 052/147] mm: remove redundant compound_head()
 calling
Message-ID: <20210908025555.vSbhhchuo%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: remove redundant compound_head() calling

There is a READ_ONCE() in the macro of compound_head(), which will prevent
compiler from optimizing the code when there are more than once calling of
it in a function.  Remove the redundant calling of compound_head() from
page_to_index() and page_add_file_rmap() for better code generation.

Link: https://lkml.kernel.org/r/20210811101431.83940-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    7 +++----
 mm/rmap.c               |    6 ++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-redundant-compound_head-calling
+++ a/include/linux/pagemap.h
@@ -521,18 +521,17 @@ static inline struct page *read_mapping_
  */
 static inline pgoff_t page_to_index(struct page *page)
 {
-	pgoff_t pgoff;
+	struct page *head;
 
 	if (likely(!PageTransTail(page)))
 		return page->index;
 
+	head = compound_head(page);
 	/*
 	 *  We don't initialize ->index for tail pages: calculate based on
 	 *  head page
 	 */
-	pgoff = compound_head(page)->index;
-	pgoff += page - compound_head(page);
-	return pgoff;
+	return head->index + page - head;
 }
 
 extern pgoff_t hugetlb_basepage_index(struct page *page);
--- a/mm/rmap.c~mm-remove-redundant-compound_head-calling
+++ a/mm/rmap.c
@@ -1230,11 +1230,13 @@ void page_add_file_rmap(struct page *pag
 						nr_pages);
 	} else {
 		if (PageTransCompound(page) && page_mapping(page)) {
+			struct page *head = compound_head(page);
+
 			VM_WARN_ON_ONCE(!PageLocked(page));
 
-			SetPageDoubleMap(compound_head(page));
+			SetPageDoubleMap(head);
 			if (PageMlocked(page))
-				clear_page_mlock(compound_head(page));
+				clear_page_mlock(head);
 		}
 		if (!atomic_inc_and_test(&page->_mapcount))
 			goto out;
_
