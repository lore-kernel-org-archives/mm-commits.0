From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures]
 mm-sparsemem-use-wrapped-macros-instead-of-open-coding.patch removed from
 -mm tree
Date: Wed, 11 Mar 2020 17:34:14 -0700
Message-ID: <20200312003414.wlG9g0vy7%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbgCLAeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:34:15 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse.c: use macros instead of open-coding
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-use-wrapped-macros-instead-of-open-coding.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/sparse.c: use macros instead of open-coding

Use macros instead of open-coding for better code readability.

Link: http://lkml.kernel.org/r/1583489966-16390-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/sparse.c~mm-sparsemem-use-wrapped-macros-instead-of-open-coding
+++ a/mm/sparse.c
@@ -385,8 +385,8 @@ static void __init check_usemap_section_
 		old_pgdat_snr = NR_MEM_SECTIONS;
 	}
 
-	usemap_snr = pfn_to_section_nr(__pa(usage) >> PAGE_SHIFT);
-	pgdat_snr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
+	usemap_snr = pfn_to_section_nr(virt_to_pfn(usage));
+	pgdat_snr = pfn_to_section_nr(virt_to_pfn(pgdat));
 	if (usemap_snr == pgdat_snr)
 		return;
 
@@ -677,7 +677,7 @@ struct page * __meminit populate_section
 
 	return NULL;
 got_map_page:
-	ret = (struct page *)pfn_to_kaddr(page_to_pfn(page));
+	ret = (struct page *)page_to_virt(page);
 got_map_ptr:
 
 	return ret;
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
mm-page_alloc-use-free_area_empty-instead-of-open-coding.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
