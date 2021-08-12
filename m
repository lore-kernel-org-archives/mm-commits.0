Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDC9C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4296104F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 21:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhHLVyf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 17:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhHLVyf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 17:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE7160F57;
        Thu, 12 Aug 2021 21:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628805249;
        bh=xkgeM92eIOsrNdSJIpPuRFixnMTc1o0tlwufw0SMWRk=;
        h=Date:From:To:Subject:From;
        b=rhZIq5m3FTwKju62Glz+5Metv0eQZhTDofe3wPv4R8saWIIardaYz/XmOo77rMUYU
         FYZQo02yAFTfwqXy2mlK3koXr8IB4CkyN0AmqZUvik1qSFO+6Ohr6dwOT0R65nYmK1
         R30bOY6Ym9MnYLqbnEFwa9w6gIwc+RmBH492kqPU=
Date:   Thu, 12 Aug 2021 14:54:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, kirill.shutemov@linux.intel.com,
        hannes@cmpxchg.org, dhowells@redhat.com, songmuchun@bytedance.com
Subject:  + mm-remove-redundant-compound_head-calling.patch added to
 -mm tree
Message-ID: <20210812215406.bDjzn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove redundant compound_head() calling
has been added to the -mm tree.  Its filename is
     mm-remove-redundant-compound_head-calling.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-redundant-compound_head-calling.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-redundant-compound_head-calling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: remove redundant compound_head() calling

There is a READ_ONCE() in the macro of compound_head(), which will prevent
compiler from optimizing the code when there are more than once calling of
it in a function.  Remove the redundant calling of compound_head() from
page_to_index() and page_add_file_rmap() for better code generation.

Link: https://lkml.kernel.org/r/20210811101431.83940-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    7 +++----
 mm/rmap.c               |    6 ++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-redundant-compound_head-calling
+++ a/include/linux/pagemap.h
@@ -571,18 +571,17 @@ static inline struct page *read_mapping_
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

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-remove-redundant-compound_head-calling.patch

