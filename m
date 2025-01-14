Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD4223D3CE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837141; cv=none; b=ni5qwZACocr7Pnj6+T3Nhk3zvW/w2gFqBIgmiqX16++6Ruf72nzt1tmnXe+cW8p+2B0ef+FBY4smXZ0dYpa69QK17DbTLhXKlUaiLkFGhLwWRlprccmb2g/46u7ugrwg6uRf++0lL764cPh79V5KR3SrmrvPub9wfaFxVxMSzuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837141; c=relaxed/simple;
	bh=0wtcDdiFFkr0M+AXHft8mN3k+XCTv6i4GgQdKi1tgWI=;
	h=Date:To:From:Subject:Message-Id; b=ZvPDgxRLLqAoKas4XJOOobXM8uxE3+MrhyxL5SYKieX5FjaJvqg4ATV7rapikV7yLiTd8v0ZiMnHRbwM89k9BtJpNYV5JTlcIAqm7saa7iWT7eHVaoWVvY59EdTucQxDoCwRwDvLZ1w0tbTzkiaJfwQd3/bVM8+wYeYMA3ofZYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wq8ajLSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wq8ajLSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61584C4CEDD;
	Tue, 14 Jan 2025 06:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837141;
	bh=0wtcDdiFFkr0M+AXHft8mN3k+XCTv6i4GgQdKi1tgWI=;
	h=Date:To:From:Subject:From;
	b=Wq8ajLSmy4K14NFeWJOB4YH7GADRFaM1KbJC8Zd0R/CsS0Jw1oHZOQA3q9L8C7MsE
	 zHsZYt1o8T+3TPTH02BCI2v2s2Am47obPDDdUNLMhL5BTl/KGH2kBGQxlAOOVYmd+x
	 9NKVxYybZQ7s4it487dSuIPxT7Wy6yymcN3yMCo0=
Date: Mon, 13 Jan 2025 22:45:40 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-add-calls-to-pagetable_pmd_tor.patch removed from -mm tree
Message-Id: <20250114064541.61584C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: m68k: mm: add calls to pagetable_pmd_[cd]tor
has been removed from the -mm tree.  Its filename was
     m68k-mm-add-calls-to-pagetable_pmd_tor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: m68k: mm: add calls to pagetable_pmd_[cd]tor
Date: Fri, 3 Jan 2025 18:44:12 +0000

get_pointer_table() and free_pointer_table() already special-case
TABLE_PTE to call pagetable_pte_[cd]tor.  Let's do the same at PMD level
to improve accounting further.  TABLE_PGD and TABLE_PMD are currently
defined to the same value, so we first need to separate them.  That also
implies separating ptable_list for PMD/PGD levels.

Link: https://lkml.kernel.org/r/20250103184415.2744423-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/motorola_pgalloc.h |    6 +++---
 arch/m68k/mm/motorola.c                  |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/arch/m68k/include/asm/motorola_pgalloc.h~m68k-mm-add-calls-to-pagetable_pmd_tor
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -9,9 +9,9 @@ extern void mmu_page_ctor(void *page);
 extern void mmu_page_dtor(void *page);
 
 enum m68k_table_types {
-	TABLE_PGD = 0,
-	TABLE_PMD = 0, /* same size as PGD */
-	TABLE_PTE = 1,
+	TABLE_PGD,
+	TABLE_PMD,
+	TABLE_PTE,
 };
 
 extern void init_pointer_table(void *table, int type);
--- a/arch/m68k/mm/motorola.c~m68k-mm-add-calls-to-pagetable_pmd_tor
+++ a/arch/m68k/mm/motorola.c
@@ -97,17 +97,19 @@ void mmu_page_dtor(void *page)
 
 typedef struct list_head ptable_desc;
 
-static struct list_head ptable_list[2] = {
+static struct list_head ptable_list[3] = {
 	LIST_HEAD_INIT(ptable_list[0]),
 	LIST_HEAD_INIT(ptable_list[1]),
+	LIST_HEAD_INIT(ptable_list[2]),
 };
 
 #define PD_PTABLE(page) ((ptable_desc *)&(virt_to_page((void *)(page))->lru))
 #define PD_PAGE(ptable) (list_entry(ptable, struct page, lru))
 #define PD_MARKBITS(dp) (*(unsigned int *)&PD_PAGE(dp)->index)
 
-static const int ptable_shift[2] = {
-	7+2, /* PGD, PMD */
+static const int ptable_shift[3] = {
+	7+2, /* PGD */
+	7+2, /* PMD */
 	6+2, /* PTE */
 };
 
@@ -156,12 +158,17 @@ void *get_pointer_table(int type)
 		if (!(page = (void *)get_zeroed_page(GFP_KERNEL)))
 			return NULL;
 
-		if (type == TABLE_PTE) {
+		switch (type) {
+		case TABLE_PTE:
 			/*
 			 * m68k doesn't have SPLIT_PTE_PTLOCKS for not having
 			 * SMP.
 			 */
 			pagetable_pte_ctor(virt_to_ptdesc(page));
+			break;
+		case TABLE_PMD:
+			pagetable_pmd_ctor(virt_to_ptdesc(page));
+			break;
 		}
 
 		mmu_page_ctor(page);
@@ -200,7 +207,7 @@ int free_pointer_table(void *table, int
 		/* all tables in page are free, free page */
 		list_del(dp);
 		mmu_page_dtor((void *)page);
-		if (type == TABLE_PTE)
+		if (type == TABLE_PTE || type == TABLE_PMD)
 			pagetable_dtor(virt_to_ptdesc((void *)page));
 		free_page (page);
 		return 1;
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


