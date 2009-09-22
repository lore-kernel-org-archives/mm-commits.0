From: akpm@linux-foundation.org
Subject: [folded] kcore-use-registerd-physmem-information-ia64-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:45:53 -0700
Message-ID: <200909222145.n8MLjrTa005483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZIVVqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kcore-use-registerd-physmem-information-ia64-fix
has been removed from the -mm tree.  Its filename was
     kcore-use-registerd-physmem-information-ia64-fix.patch

This patch was dropped because it was folded into kcore-use-registerd-physmem-information.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore-use-registerd-physmem-information-ia64-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

kcore-use-registerd-physmem-information.patch registers physmem
information based on ioresource.  Then, this addition is unnecessary.

Why panic:
  At boot, rebuilding kclist for physmem, all KCORE_RAM entries are kfreed.
  Because this ramaining one entires kclist of KCORE_RAM in kernel data area
  to ther list, this causes panic in kclist rebuilding which calls kfree().

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/ia64/mm/init.c~kcore-use-registerd-physmem-information-ia64-fix arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~kcore-use-registerd-physmem-information-ia64-fix
+++ a/arch/ia64/mm/init.c
@@ -617,7 +617,6 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_mem;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -639,8 +638,6 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
