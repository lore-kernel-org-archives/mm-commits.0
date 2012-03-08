From: akpm@linux-foundation.org
Subject: [merged] x86-mm-fix-the-size-calculation-of-mapping-tables.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:31 -0800
Message-ID: <20120308191731.6B1FFA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35115 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab2CHTRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:33 -0500
Received: by eekc41 with SMTP id c41so30194eek.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, hpa@zytor.com, ianfang.cn@gmail.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: fix the size calculation of mapping tables
has been removed from the -mm tree.  Its filename was
     x86-mm-fix-the-size-calculation-of-mapping-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: x86, mm: fix the size calculation of mapping tables

For machine enables PSE, the first 2/4M memory region still uses 4K pages,
so needs more PTEs in this case, but find_early_table_space() doesn't
count this.  This patch fixes it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <ianfang.cn@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN arch/x86/mm/init.c~x86-mm-fix-the-size-calculation-of-mapping-tables arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-fix-the-size-calculation-of-mapping-tables
+++ a/arch/x86/mm/init.c
@@ -30,8 +30,14 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+static void __init find_early_table_space(struct map_range *mr, unsigned long end,
+					  int use_pse, int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -56,6 +62,9 @@ static void __init find_early_table_spac
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
 #endif
+		/* The first 2/4M doesn't use large pages. */
+		extra += mr->end - mr->start;
+
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -85,12 +94,6 @@ void __init native_pagetable_reserve(u64
 	memblock_reserve(start, end - start);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
