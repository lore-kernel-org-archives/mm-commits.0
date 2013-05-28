From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch removed
 from -mm tree
Date: Tue, 28 May 2013 12:36:53 -0700
Message-ID: <51a50755.Mluyne5Q9Ns7dunC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3E1Tgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yegoshin@mips.com, stable@vger.kernel.org, rmk@arm.linux.org.uk, riel@redhat.com, ralf@linux-mips.org, mhocko@suse.cz, mgorman@suse.de, davem@davemloft.net, Leonid.Yegoshin@imgtec.com

Subject: [merged] mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch removed from -mm tree
To: Leonid.Yegoshin@imgtec.com,davem@davemloft.net,mgorman@suse.de,mhocko@suse.cz,ralf@linux-mips.org,riel@redhat.com,rmk@arm.linux.org.uk,stable@vger.kernel.org,yegoshin@mips.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:53 -0700


The patch titled
     Subject: mm compaction: fix of improper cache flush in migration code
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-of-improper-cache-flush-in-migration-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>
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


