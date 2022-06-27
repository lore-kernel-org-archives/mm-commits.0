Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1728EC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 19:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiF0Tb4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiF0Tb4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 15:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D4722C
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 12:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3FE5615FF
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 19:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F886C3411D;
        Mon, 27 Jun 2022 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656358314;
        bh=7fGbwCV7HmCsDFD8SxW7GAmnZ8KEcvqfqb0pt0ADzdk=;
        h=Date:To:From:Subject:From;
        b=PRZR/i71UDv3GQaN1zMzI5m64ObjlJzZhSNX6+Qx7Y/aAYhZzlPQYcKep0Haek7IJ
         d7bCTuYDXyqPS6eL8x8sko8cSbBuF/GUv7d9eQjvBN/1pph0eI9fHYonkbfxRRBoJI
         1SSvs+fvsfMyXXcY8tcZle02qpMeiiWZjSHqPEdU=
Date:   Mon, 27 Jun 2022 12:31:53 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch removed from -mm tree
Message-Id: <20220627193154.1F886C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison, hugetlb: introduce SUBPAGE_INDEX_HWPOISON to save raw error page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison, hugetlb: introduce SUBPAGE_INDEX_HWPOISON to save raw error page
Date: Thu, 2 Jun 2022 14:06:27 +0900

This patchset enables memory error handling on 1GB hugepage.

"Save raw error page" patch (1/4 of patchset [1]) is necessary, so it's
included in this series (the remaining part of hotplug related things are
still in progress).  Patch 2/5 solves issues in a corner case of hugepage
handling, which might not be the main target of this patchset, but
slightly related.  It was posted separately [2] but depends on 1/5, so I
group them together.

Patches 3/5 to 5/5 are the main part of this series and fix a small issue
about handling 1GB hugepage, which I hope will be workable.

[1]: https://lore.kernel.org/linux-mm/20220427042841.678351-1-naoya.horiguchi@linux.dev/T/#u

[2]: https://lore.kernel.org/linux-mm/20220511151955.3951352-1-naoya.horiguchi@linux.dev/T/


This patch (of 5):

When handling memory error on a hugetlb page, the error handler tries to
dissolve and turn it into 4kB pages.  If it's successfully dissolved,
PageHWPoison flag is moved to the raw error page, so that's all right. 
However, dissolve sometimes fails, then the error page is left as
hwpoisoned hugepage.  It's useful if we can retry to dissolve it to save
healthy pages, but that's not possible now because the information about
where the raw error page is lost.

Use the private field of a tail page to keep that information.  The code
path of shrinking hugepage pool used this info to try delayed dissolve. 
This only keeps one hwpoison page for now, which might be OK because it's
simple and multiple hwpoison pages in a hugepage can be rare.  But it can
be extended in the future.

Link: https://lkml.kernel.org/r/20220602050631.771414-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20220602050631.771414-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   24 ++++++++++++++++++++++++
 mm/hugetlb.c            |    9 +++++++++
 mm/memory-failure.c     |    2 ++
 3 files changed, 35 insertions(+)

--- a/include/linux/hugetlb.h~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page
+++ a/include/linux/hugetlb.h
@@ -43,6 +43,9 @@ enum {
 	SUBPAGE_INDEX_CGROUP_RSVD,	/* reuse page->private */
 	__MAX_CGROUP_SUBPAGE_INDEX = SUBPAGE_INDEX_CGROUP_RSVD,
 #endif
+#ifdef CONFIG_MEMORY_FAILURE
+	SUBPAGE_INDEX_HWPOISON,
+#endif
 	__NR_USED_SUBPAGE,
 };
 
@@ -798,6 +801,27 @@ extern int dissolve_free_huge_page(struc
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
+#ifdef CONFIG_MEMORY_FAILURE
+/*
+ * pointer to raw error page is located in hpage[SUBPAGE_INDEX_HWPOISON].private
+ */
+static inline struct page *hugetlb_page_hwpoison(struct page *hpage)
+{
+	return (void *)page_private(hpage + SUBPAGE_INDEX_HWPOISON);
+}
+
+static inline void hugetlb_set_page_hwpoison(struct page *hpage,
+					struct page *page)
+{
+	set_page_private(hpage + SUBPAGE_INDEX_HWPOISON, (unsigned long)page);
+}
+#else
+static inline struct page *hugetlb_page_hwpoison(struct page *hpage)
+{
+	return NULL;
+}
+#endif
+
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 #ifndef arch_hugetlb_migration_supported
 static inline bool arch_hugetlb_migration_supported(struct hstate *h)
--- a/mm/hugetlb.c~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page
+++ a/mm/hugetlb.c
@@ -1553,6 +1553,15 @@ static void __update_and_free_page(struc
 		return;
 	}
 
+	if (unlikely(PageHWPoison(page))) {
+		struct page *raw_error = hugetlb_page_hwpoison(page);
+
+		if (raw_error && raw_error != page) {
+			SetPageHWPoison(raw_error);
+			ClearPageHWPoison(page);
+		}
+	}
+
 	for (i = 0; i < pages_per_huge_page(h);
 	     i++, subpage = mem_map_next(subpage, page, i)) {
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
--- a/mm/memory-failure.c~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page
+++ a/mm/memory-failure.c
@@ -1537,6 +1537,8 @@ int __get_huge_page_for_hwpoison(unsigne
 		goto out;
 	}
 
+	hugetlb_set_page_hwpoison(head, page);
+
 	return ret;
 out:
 	if (count_increased)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch
mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

