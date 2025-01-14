Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506B53232
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837145; cv=none; b=pEBSlUY81O8eoilhULthelkWjSuSPG2HiLMi3KjHJs+VnLKugL3qvaObmxEZqglku6ZkyBAE/KTcM5+y+A93B2KG8DUd5ZxQjOmw4/Ek0V/XJht8fO15enEfC8iSJVyUy7NS+p20rknmsXvgMC+Uu+mO5h3U2eKRx/yqCFzqtIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837145; c=relaxed/simple;
	bh=cBrJssp1EtIfJvvL/9PcTOLah9wrDbYHI3Ad0lGsKtY=;
	h=Date:To:From:Subject:Message-Id; b=eixbZqtrtoy1QRNQfoTyjQh6oKuK1+7inbymaZM7szPz2VvC2JmSO6deEolEK17EG5vWTUlSKmoB5Wy/YtIHLIbVuOixO4AlhRsppBBqTGiCzrXgn3RbQ49YwsfP+FVRtphyKTGoHivpJPbcLHqVIBriHvg8CGWlA5Snmw/6JsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZSBJy8Hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZSBJy8Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6D4C4CEE5;
	Tue, 14 Jan 2025 06:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837145;
	bh=cBrJssp1EtIfJvvL/9PcTOLah9wrDbYHI3Ad0lGsKtY=;
	h=Date:To:From:Subject:From;
	b=ZSBJy8HqyKDORsYn9qtPVSLdhMNljpzUpNi92gaWN5ncs1/XhSIi7H9CeQpSyokNw
	 5qIxph8oerxlJIiKpWn2yqso5CaC99JesOPbH04jH9wYoR26k4uZdEvwaLNChx2/9m
	 2CL+IpyGLu7PEF0atCGp2wGK5vMe73fFJMa3JzZg=
Date: Mon, 13 Jan 2025 22:45:44 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-ctor-dtor-at-pgd-level.patch removed from -mm tree
Message-Id: <20250114064545.1B6D4C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce ctor/dtor at PGD level
has been removed from the -mm tree.  Its filename was
     mm-introduce-ctor-dtor-at-pgd-level.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3159,6 +3159,11 @@ static inline void pagetable_p4d_ctor(st
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


