From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:04 -0700
Message-ID: <20121029195004.A44B91E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53197 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2J2TuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:05 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so682958ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, m.szyprowski@samsung.com, nizhan.chen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c:alloc_contig_range(): return early for err path
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm/page_alloc.c:alloc_contig_range(): return early for err path

If start_isolate_page_range() failed, unset_migratetype_isolate() has been
done inside it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-alloc_contig_range-return-early-for-err-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-alloc_contig_range-return-early-for-err-path
+++ a/mm/page_alloc.c
@@ -5825,7 +5825,7 @@ int alloc_contig_range(unsigned long sta
 	ret = start_isolate_page_range(pfn_max_align_down(start),
 				       pfn_max_align_up(end), migratetype);
 	if (ret)
-		goto done;
+		return ret;
 
 	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret)
_

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch

