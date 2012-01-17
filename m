From: akpm@linux-foundation.org
Subject: + x86-mm-fix-the-size-calculation-of-mapping-tables.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:34:00 -0800
Message-ID: <20120117223401.306C95C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54522 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2AQWeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:34:04 -0500
Received: by eaaf1 with SMTP id f1so73420eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:34:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, hpa@zytor.com, ianfang.cn@gmail.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: x86, mm: fix the size calculation of mapping tables
has been added to the -mm tree.  Its filename is
     x86-mm-fix-the-size-calculation-of-mapping-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
