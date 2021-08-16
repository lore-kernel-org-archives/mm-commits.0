Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F8CC4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B5F60F38
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 23:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhHPXaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 19:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234391AbhHPXaF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 19:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F4C60F35;
        Mon, 16 Aug 2021 23:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629156573;
        bh=/GV/sFmfxV/HlKUeW1nHWPOHs2cy9+i4iH1/Alee3VI=;
        h=Date:From:To:Subject:From;
        b=uTfzSVyZj0GD6U4uW/MzfbdcW7itijkxsUHTocjQqrIFlW5cZwqaei5nAUl+sHKfS
         JqKMlSns2v33NfaiijKmLH16ynG770cBB+wUekqahYUPg98G9zeFebTDpCN8vlPinK
         YSTdV4xu/OO2TA3rBNVQafZLvZQ4ZiDd9RcSFa+Q=
Date:   Mon, 16 Aug 2021 16:29:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        songmuchun@bytedance.com, rientjes@google.com, osalvador@suse.de,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        mike.kravetz@oracle.com
Subject:  +
 hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
 added to -mm tree
Message-ID: <20210816232932.Dua8t%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: prepare destroy and prep routines for vmemmap optimized pages
has been added to the -mm tree.  Its filename is
     hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch

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
Subject: hugetlb: prepare destroy and prep routines for vmemmap optimized pages

When optimally demoting huge pages with vmemmap optimizations, the
routines which destroy and prep hugetlb pages need to be modified. 
Currently, these routines expect all vmemmap pages to be present as they
will write to all page structs for tail pages.  To optimallly handle
demotion of huge pages not all vmemmap pages will be present.  Only those
pages required for the demoted pages will be present.  Therefore, the
destroy and prep routines must only write to struct pages for which
vmammap pages are present.

Modify destroy_compound_gigantic_page_for_demote and
prep_compound_gigantic_page_for_demote to take vmemmap optimized pages
into account.  Use the hugetlb specific flag HPageVmemmapOptimized to
determine if this special processing is needed.

These modifications will be used in subsequent patches where vmemmap
optimizations for demote are fully enabled.

Also modify the routine free_huge_page_vmemmap to immediately return if
the passed page is already optimized.  With demotion, prep_new_huge_page
can be called for vmemmap optimized pages.

Link: https://lkml.kernel.org/r/20210816224953.157796-8-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c         |   17 +++++++++++++++--
 mm/hugetlb_vmemmap.c |   12 ++----------
 mm/hugetlb_vmemmap.h |   10 ++++++++++
 3 files changed, 27 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages
+++ a/mm/hugetlb.c
@@ -1255,12 +1255,18 @@ static void __destroy_compound_gigantic_
 					unsigned int order, bool demote)
 {
 	int i;
-	int nr_pages = 1 << order;
+	int nr_pages;
 	struct page *p = page + 1;
 
 	atomic_set(compound_mapcount_ptr(page), 0);
 	atomic_set(compound_pincount_ptr(page), 0);
 
+	if (demote && HPageVmemmapOptimized(page)) {
+		clear_compound_head(page);
+		nr_pages = RESERVE_VMEMMAP_SIZE / sizeof(struct page);
+	} else
+		nr_pages = 1 << order;
+
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
 		p->mapping = NULL;
 		clear_compound_head(p);
@@ -1517,6 +1523,7 @@ static void __update_and_free_page(struc
 			return;
 		}
 #endif
+		prep_compound_page(page, huge_page_order(h));
 		__free_pages(page, huge_page_order(h));
 	}
 }
@@ -1705,9 +1712,14 @@ static bool __prep_compound_gigantic_pag
 								bool demote)
 {
 	int i, j;
-	int nr_pages = 1 << order;
+	int nr_pages;
 	struct page *p = page + 1;
 
+	if (demote && HPageVmemmapOptimized(page))
+		nr_pages = RESERVE_VMEMMAP_SIZE / sizeof(struct page);
+	else
+		nr_pages = 1 << order;
+
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
 	__ClearPageReserved(page);
@@ -1751,6 +1763,7 @@ static bool __prep_compound_gigantic_pag
 		} else {
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
+		p->mapping = TAIL_MAPPING;
 		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
--- a/mm/hugetlb_vmemmap.c~hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages
+++ a/mm/hugetlb_vmemmap.c
@@ -172,16 +172,6 @@
 
 #include "hugetlb_vmemmap.h"
 
-/*
- * There are a lot of struct page structures associated with each HugeTLB page.
- * For tail pages, the value of compound_head is the same. So we can reuse first
- * page of tail page structures. We map the virtual addresses of the remaining
- * pages of tail page structures to the first tail page struct, and then free
- * these page frames. Therefore, we need to reserve two pages as vmemmap areas.
- */
-#define RESERVE_VMEMMAP_NR		2U
-#define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
-
 bool hugetlb_free_vmemmap_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON);
 
 static int __init early_hugetlb_free_vmemmap_param(char *buf)
@@ -250,6 +240,8 @@ void free_huge_page_vmemmap(struct hstat
 
 	if (!free_vmemmap_pages_per_hpage(h))
 		return;
+	if (HPageVmemmapOptimized(head))	/* possible for demote */
+		return;
 
 	vmemmap_addr += RESERVE_VMEMMAP_SIZE;
 	vmemmap_end = vmemmap_addr + free_vmemmap_pages_size_per_hpage(h);
--- a/mm/hugetlb_vmemmap.h~hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages
+++ a/mm/hugetlb_vmemmap.h
@@ -10,6 +10,16 @@
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
 
+/*
+ * There are a lot of struct page structures associated with each HugeTLB page.
+ * For tail pages, the value of compound_head is the same. So we can reuse first
+ * page of tail page structures. We map the virtual addresses of the remaining
+ * pages of tail page structures to the first tail page struct, and then free
+ * these page frames. Therefore, we need to reserve two pages as vmemmap areas.
+ */
+#define RESERVE_VMEMMAP_NR		2U
+#define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
+
 #ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
 int alloc_huge_page_vmemmap(struct hstate *h, struct page *head);
 void free_huge_page_vmemmap(struct hstate *h, struct page *head);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-hpagecma-flag-and-code-to-free-non-gigantic-pages-in-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-document-the-demote-sysfs-interfaces.patch
hugetlb-vmemmap-optimizations-when-demoting-hugetlb-pages.patch
hugetlb-prepare-destroy-and-prep-routines-for-vmemmap-optimized-pages.patch
hugetlb-optimized-demote-vmemmap-optimizatized-pages.patch

