From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch added to -mm tree
Date: Thu, 09 May 2013 11:33:40 -0700
Message-ID: <20130509183340.88FA031C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61788 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3EISdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:33:41 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so319283yho.1
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:33:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Leonid.Yegoshin@imgtec.com, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com, stable@vger.kernel.org, yegoshin@mips.com


The patch titled
     Subject: mm compaction: fix of improper cache flush in migration code
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Subject: mm compaction: fix of improper cache flush in migration code

Page 'new' during MIGRATION can't be flushed with flush_cache_page(). 
Using flush_cache_page(vma, addr, pfn) is justified only if the page is
already placed in process page table, and that is done right after
flush_cache_page().  But without it the arch function has no knowledge of
process PTE and does nothing.

Besides that, flush_cache_page() flushes an application cache page, but
the kernel has a different page virtual address and dirtied it.

Replace it with flush_dcache_page(new) which is the proper usage.

The old page is flushed in try_to_unmap_one() before migration.

This bug takes place in Sead3 board with M14Kc MIPS CPU without cache
aliasing (but Harvard arch - separate I and D cache) in tight memory
environment (128MB) each 1-3days on SOAK test.  It fails in cc1 during
kernel build (SIGILL, SIGBUS, SIGSEG) if CONFIG_COMPACTION is switched ON.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: Leonid Yegoshin <yegoshin@mips.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-compaction-fix-of-improper-cache-flush-in-migration-code mm/migrate.c
--- a/mm/migrate.c~mm-compaction-fix-of-improper-cache-flush-in-migration-code
+++ a/mm/migrate.c
@@ -165,7 +165,7 @@ static int remove_migration_pte(struct p
 		pte = arch_make_huge_pte(pte, vma, new, 0);
 	}
 #endif
-	flush_cache_page(vma, addr, pte_pfn(pte));
+	flush_dcache_page(new);
 	set_pte_at(mm, addr, ptep, pte);
 
 	if (PageHuge(new)) {
_

Patches currently in -mm which might be from Leonid.Yegoshin@imgtec.com are

linux-next.patch
mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch

