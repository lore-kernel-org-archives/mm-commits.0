From: akpm@linux-foundation.org
Subject: + mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch added to -mm tree
Date: Tue, 23 Oct 2012 13:24:43 -0700
Message-ID: <20121023202444.35DF420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52835 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2JWUYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:24:46 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so258087wey.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:24:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, m.szyprowski@samsung.com, nizhan.chen@gmail.com


The patch titled
     Subject: mm/page_alloc.c:alloc_contig_range(): return early for err path
has been added to the -mm tree.  Its filename is
     mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_allocc-alloc_contig_range-return-early-for-err-path.patch
linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-introduce-hugepage_get_pmd.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch

