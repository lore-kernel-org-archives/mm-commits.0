From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mmhwpoison-refactor-soft=5Foffline=5Fhuge=5Fpage-and-=5F?=
 =?US-ASCII?Q?=5Fsoft=5Foffline=5Fpage-fix-fix.patch?= added to -mm tree
Date: Thu, 02 Jul 2020 21:54:25 -0700
Message-ID: <20200703045425.DqmQ0aYME%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgGCEy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, osalvador@suse.de, rdunlap@infradead.org


The patch titled
     Subject: mm/memory-failure: remove stub function
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memory-failure: remove stub function

This stub is no longer needed since the function is no longer
inside an #ifdef/#endif block.

Fixes this build error:

../mm/memory-failure.c:180:13: error: redefinition of `page_handle_poison'

Link: http://lkml.kernel.org/r/adb60490-484f-a154-e163-725e35a821dc@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-fix
+++ a/mm/memory-failure.c
@@ -169,10 +169,6 @@ int hwpoison_filter(struct page *p)
 	return 0;
 }
 
-static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
-{
-	return true;
-}
 #endif
 
 EXPORT_SYMBOL_GPL(hwpoison_filter);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mmhwpoison-rework-soft-offline-for-free-pages-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-fix.patch
