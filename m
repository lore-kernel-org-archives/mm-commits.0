Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8C6C6379F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353582086A
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K84x2WLr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKXEWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:22:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgKXEWV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 23:22:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1638920857;
        Tue, 24 Nov 2020 04:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606191740;
        bh=0O5Yd8xMtCaolPDxu3zBqIIqkHavDqVxg3j3h7GuvPw=;
        h=Date:From:To:Subject:From;
        b=K84x2WLrBZiTh9FyT54IHPQpGbDworUAoafy9byDlVLJorFImtDqopI9p4Zr/k9qq
         zD2IhkJz9d+j/DMr7Ha3sZKBmBUByJgQd8+NrdLMxbngz+WuRu4GAHSeovnSw3FEkr
         8k9xcSY8nQbRIarlHxcdQ6fxzesI5GLojm+Vp1Cc=
Date:   Mon, 23 Nov 2020 20:22:19 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-support-thps-in-zero_user_segments.patch added to
 -mm tree
Message-ID: <20201124042219.WS5CCILcM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: support THPs in zero_user_segments
has been added to the -mm tree.  Its filename is
     mm-support-thps-in-zero_user_segments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-support-thps-in-zero_user_segments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-support-thps-in-zero_user_segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: support THPs in zero_user_segments

We can only kmap() one subpage of a THP at a time, so loop over all
relevant subpages, skipping ones which don't need to be zeroed.  This is
too large to inline when THPs are enabled and we actually need highmem, so
put it in highmem.c.

Link: https://lkml.kernel.org/r/20201124041507.28996-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   19 +++++++++---
 mm/highmem.c            |   59 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 4 deletions(-)

--- a/include/linux/highmem.h~mm-support-thps-in-zero_user_segments
+++ a/include/linux/highmem.h
@@ -284,13 +284,22 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr);
 }
 
+/*
+ * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
+ * If we pass in a head page, we can zero up to the size of the compound page.
+ */
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+void zero_user_segments(struct page *page, unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2);
+#else /* !HIGHMEM || !TRANSPARENT_HUGEPAGE */
 static inline void zero_user_segments(struct page *page,
-	unsigned start1, unsigned end1,
-	unsigned start2, unsigned end2)
+		unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2)
 {
 	void *kaddr = kmap_atomic(page);
+	unsigned int i;
 
-	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
+	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
 
 	if (end1 > start1)
 		memset(kaddr + start1, 0, end1 - start1);
@@ -299,8 +308,10 @@ static inline void zero_user_segments(st
 		memset(kaddr + start2, 0, end2 - start2);
 
 	kunmap_atomic(kaddr);
-	flush_dcache_page(page);
+	for (i = 0; i < compound_nr(page); i++)
+		flush_dcache_page(page + i);
 }
+#endif /* !HIGHMEM || !TRANSPARENT_HUGEPAGE */
 
 static inline void zero_user_segment(struct page *page,
 	unsigned start, unsigned end)
--- a/mm/highmem.c~mm-support-thps-in-zero_user_segments
+++ a/mm/highmem.c
@@ -369,6 +369,65 @@ void kunmap_high(struct page *page)
 }
 
 EXPORT_SYMBOL(kunmap_high);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void zero_user_segments(struct page *page, unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2)
+{
+	unsigned int i;
+
+	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
+
+	for (i = 0; i < compound_nr(page); i++) {
+		void *kaddr;
+		unsigned this_end;
+
+		if (end1 == 0 && start2 >= PAGE_SIZE) {
+			start2 -= PAGE_SIZE;
+			end2 -= PAGE_SIZE;
+			continue;
+		}
+
+		if (start1 >= PAGE_SIZE) {
+			start1 -= PAGE_SIZE;
+			end1 -= PAGE_SIZE;
+			if (start2) {
+				start2 -= PAGE_SIZE;
+				end2 -= PAGE_SIZE;
+			}
+			continue;
+		}
+
+		kaddr = kmap_atomic(page + i);
+
+		this_end = min_t(unsigned, end1, PAGE_SIZE);
+		if (end1 > start1)
+			memset(kaddr + start1, 0, this_end - start1);
+		end1 -= this_end;
+		start1 = 0;
+
+		if (start2 >= PAGE_SIZE) {
+			start2 -= PAGE_SIZE;
+			end2 -= PAGE_SIZE;
+		} else {
+			this_end = min_t(unsigned, end2, PAGE_SIZE);
+			if (end2 > start2)
+				memset(kaddr + start2, 0, this_end - start2);
+			end2 -= this_end;
+			start2 = 0;
+		}
+
+		kunmap_atomic(kaddr);
+		flush_dcache_page(page + i);
+
+		if (!end1 && !end2)
+			break;
+	}
+
+	BUG_ON((start1 | start2 | end1 | end2) != 0);
+}
+EXPORT_SYMBOL(zero_user_segments);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif	/* CONFIG_HIGHMEM */
 
 #if defined(HASHED_PAGE_VIRTUAL)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

