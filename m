Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F41BDCF
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958215; cv=none; b=WWR2iKarbuhlqzXNYXgMvr+BU+e+c/dueF3I0Zie6Q4KpMFQVrVAT2eJaceQafZRvaUsBcHLeujGpVcVsVR5T3WGL4jnKSzk9Telm0Dd+rsRbOG/+WOtiC3Oec/mEWfHlYu1xvsmVbtyverkhOw+zl9KM+5sENM2cqNxs4thv6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958215; c=relaxed/simple;
	bh=xN80ig4vC+0R5eOG566IhP/MkBDBYYLQ+3NK5DLHdLc=;
	h=Date:To:From:Subject:Message-Id; b=Zn9hz9S4WM5vxhlRrd6Dfq39jOLDb52Xck+A5PhmgIfYJNsg5DjqxhFm8v7/BvNSbYTozWqwQf7jJW2ECWG7XZ4d4hCq6vO9Jiirl+Sq4PA+o1y4Hsz2Sdhy/Vx2Rrjr5vf6Gm1Xt7c8PvHpytX7IwNR7AFsfyyfGYaM6y5A/7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T5CYI92B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T5CYI92B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB5DC4CED6;
	Sat,  4 Jan 2025 02:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958215;
	bh=xN80ig4vC+0R5eOG566IhP/MkBDBYYLQ+3NK5DLHdLc=;
	h=Date:To:From:Subject:From;
	b=T5CYI92BOqZ0wdVUkRp8YCH/n0wDhZlMFmERk+V9DDs6fFgCDFFChbRwRdY9d9uoC
	 7qECooPZi4qR7rCkV5PiVYueo3pV+jlwYg5CeSSE38C60oyTsDTJmNTaCMjccgA2Gl
	 cXAnNunwVOrQrh+5T/LhYloSNt3CuCVLE8Rx30KQ=
Date: Fri, 03 Jan 2025 18:36:54 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-ctor-dtor-at-pgd-level.patch added to mm-unstable branch
Message-Id: <20250104023654.DEB5DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce ctor/dtor at PGD level
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-ctor-dtor-at-pgd-level.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-ctor-dtor-at-pgd-level.patch

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
Subject: mm: introduce ctor/dtor at PGD level
Date: Fri, 3 Jan 2025 18:44:15 +0000

Following on from the introduction of P4D-level ctor/dtor, let's finish
the job and introduce ctor/dtor at PGD level.  The incurred improvement in
page accounting is minimal - the main motivation is to create a single,
generic place where construction/destruction hooks can be added for all
page table pages.

This patch should cover all architectures and all configurations where
PGDs are one or more regular pages.  This excludes any configuration where
PGDs are allocated from a kmem_cache object.

Link: https://lkml.kernel.org/r/20250103184415.2744423-7-kevin.brodsky@arm.com
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

 arch/m68k/include/asm/mcf_pgalloc.h |    3 ++-
 arch/m68k/mm/motorola.c             |    6 ++++--
 arch/s390/include/asm/pgalloc.h     |    9 ++++++++-
 include/asm-generic/pgalloc.h       |    3 ++-
 include/linux/mm.h                  |    5 +++++
 5 files changed, 21 insertions(+), 5 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgalloc.h~mm-introduce-ctor-dtor-at-pgd-level
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -73,7 +73,7 @@ static inline void pte_free(struct mm_st
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pagetable_free(virt_to_ptdesc(pgd));
+	pagetable_dtor_free(virt_to_ptdesc(pgd));
 }
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
@@ -84,6 +84,7 @@ static inline pgd_t *pgd_alloc(struct mm
 
 	if (!ptdesc)
 		return NULL;
+	pagetable_pgd_ctor(ptdesc);
 	new_pgd = ptdesc_address(ptdesc);
 
 	memcpy(new_pgd, swapper_pg_dir, PTRS_PER_PGD * sizeof(pgd_t));
--- a/arch/m68k/mm/motorola.c~mm-introduce-ctor-dtor-at-pgd-level
+++ a/arch/m68k/mm/motorola.c
@@ -169,6 +169,9 @@ void *get_pointer_table(int type)
 		case TABLE_PMD:
 			pagetable_pmd_ctor(virt_to_ptdesc(page));
 			break;
+		case TABLE_PGD:
+			pagetable_pgd_ctor(virt_to_ptdesc(page));
+			break;
 		}
 
 		mmu_page_ctor(page);
@@ -207,8 +210,7 @@ int free_pointer_table(void *table, int
 		/* all tables in page are free, free page */
 		list_del(dp);
 		mmu_page_dtor((void *)page);
-		if (type == TABLE_PTE || type == TABLE_PMD)
-			pagetable_dtor(virt_to_ptdesc((void *)page));
+		pagetable_dtor(virt_to_ptdesc((void *)page));
 		free_page (page);
 		return 1;
 	} else if (ptable_list[type].next != dp) {
--- a/arch/s390/include/asm/pgalloc.h~mm-introduce-ctor-dtor-at-pgd-level
+++ a/arch/s390/include/asm/pgalloc.h
@@ -130,11 +130,18 @@ static inline void pud_populate(struct m
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return (pgd_t *) crst_table_alloc(mm);
+	unsigned long *table = crst_table_alloc(mm);
+
+	if (!table)
+		return NULL;
+	pagetable_pgd_ctor(virt_to_ptdesc(table));
+
+	return (pgd_t *) table;
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	pagetable_dtor(virt_to_ptdesc(pgd));
 	crst_table_free(mm, (unsigned long *) pgd);
 }
 
--- a/include/asm-generic/pgalloc.h~mm-introduce-ctor-dtor-at-pgd-level
+++ a/include/asm-generic/pgalloc.h
@@ -271,6 +271,7 @@ static inline pgd_t *__pgd_alloc_noprof(
 	if (!ptdesc)
 		return NULL;
 
+	pagetable_pgd_ctor(ptdesc);
 	return ptdesc_address(ptdesc);
 }
 #define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
@@ -280,7 +281,7 @@ static inline void __pgd_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
 
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PGD_FREE
--- a/include/linux/mm.h~mm-introduce-ctor-dtor-at-pgd-level
+++ a/include/linux/mm.h
@@ -3243,6 +3243,11 @@ static inline void pagetable_p4d_ctor(st
 	__pagetable_ctor(ptdesc);
 }
 
+static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
+{
+	__pagetable_ctor(ptdesc);
+}
+
 extern void __init pagecache_init(void);
 extern void free_initmem(void);
 
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

