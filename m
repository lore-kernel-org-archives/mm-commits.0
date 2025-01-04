Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0FC42AAB
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958201; cv=none; b=GN0j4mhtBt98iz/4lP9SAlMngfKFEPeYMLFagIMamCrX+E1RL6O+J5odydS9fJ6A5CI8cMFf+SDiKiPKYXLKt4iGpdLiItSrpN9JKmRszIjfaGu4Fnor6xgyp8xIs8UkvLrV17xFUFUZs8VcEb4kmZM1gy92+QgrCFcEPXxIn6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958201; c=relaxed/simple;
	bh=QsRUccWb/jzXiy66hjGLhmbckoamRxew//ai85nIHAY=;
	h=Date:To:From:Subject:Message-Id; b=FYPHr+wuItNMo4c9Nyvb9eKjmUZ+/dJqXYxtcOHmgxTkHZetF5VG4c5SLuREQz3Fv40ybuzETvkUdvwqTxcJCxSr/6dl67B+xEAGHTPpO9i9/dxkC8kmIXYc8+xOlHWEwI+H2JXt6z2z+Y+9hD6B8wWGwJBZZ6mtX5yWw8F/0Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rMTk2EQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rMTk2EQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F52CC4CED6;
	Sat,  4 Jan 2025 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958200;
	bh=QsRUccWb/jzXiy66hjGLhmbckoamRxew//ai85nIHAY=;
	h=Date:To:From:Subject:From;
	b=rMTk2EQZdnq+PCHDXamvmLhVYzk+nrCBzOrklHjBRJA2zsKcE9dsYX8mzk+F/FD+0
	 qrL+coZP8hpYkD94KGm6SWLPlfctOA9Z/k2LHt8Vv0IS0nZclhEYjbY+g7FE/pr0ci
	 d3L5viY9ochDIQoKot7QhPfp9OTsPn34cUvbllt0=
Date: Fri, 03 Jan 2025 18:36:40 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-add-calls-to-pagetable_pmd_tor.patch added to mm-unstable branch
Message-Id: <20250104023640.8F52CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: m68k: mm: add calls to pagetable_pmd_[cd]tor
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-mm-add-calls-to-pagetable_pmd_tor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-mm-add-calls-to-pagetable_pmd_tor.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
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

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

