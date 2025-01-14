Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AD3243326
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837111; cv=none; b=XJOyrktn2Q8sIebWxCzoMrE99NJExFyDS8OFJbnhdwC+zR5r77VR394VmNCxqIRrjxAwiZe2/94snadnI8HSwcw2+QWLaCjSe2VI/G4mjceDMxGxwi21Aow/I8k4XpOjHKlbIG70gNN+6CNhE3YFDdHmx8eej+QkW4ZRE20BODE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837111; c=relaxed/simple;
	bh=BKnqp+CjV5zwu3hWu93mVHMTv+t1Z8Dxu1Cgi5JxH3Q=;
	h=Date:To:From:Subject:Message-Id; b=KndtspwEMp2hZpkqKIBuKQWrn8/tgL82Z5mim+gEz91gnLMXi1xkkfq6NwoMxcPIC7B2RRhHhQHzqwSxqE7r/oCcMJH6hBP5RjteQGVrwzEj3RiTl2yA18SkIHdVxDy+xUSrnaDLe/sil3nTgxpmGU0OGSZw05Tt61xhB46O9zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmsjhcvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmsjhcvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D1AC4CEDD;
	Tue, 14 Jan 2025 06:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837110;
	bh=BKnqp+CjV5zwu3hWu93mVHMTv+t1Z8Dxu1Cgi5JxH3Q=;
	h=Date:To:From:Subject:From;
	b=rmsjhcvSYb9wFtwC//xEfJOkPPWic1dfjubCe0wGbbTgRHeMdaGi2xmRIXnlR8xsk
	 4B8syniacBgpGe788DI8yYeJ5mHyxearUfvdKxs7Dq1xV1GdHlSqnpWCmcAZt+COPs
	 3Q8QlNMyPl3BXfToJzFFZd38XYRpATXJdOVU4RxU=
Date: Mon, 13 Jan 2025 22:45:10 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch removed from -mm tree
Message-Id: <20250114064510.93D1AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: skip pgtable level check in {pud,p4d}_alloc_one
has been removed from the -mm tree.  Its filename was
     riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: riscv: mm: skip pgtable level check in {pud,p4d}_alloc_one
Date: Wed, 8 Jan 2025 14:57:18 +0800

Patch series "move pagetable_*_dtor() to __tlb_remove_table()", v5.

As proposed [1] by Peter Zijlstra below, this patch series aims to move
pagetable_*_dtor() into __tlb_remove_table().  This will cleanup
pagetable_*_dtor() a bit and more gracefully fix the UAF issue [2]
reported by syzbot.

: Notably:
: 
:  - s390 pud isn't calling the existing pagetable_pud_[cd]tor()
:  - none of the p4d things have pagetable_p4d_[cd]tor() (x86,arm64,s390,riscv)
:    and they have inconsistent accounting
:  - while much of the _ctor calls are in generic code, many of the _dtor
:    calls are in arch code for hysterial raisins, this could easily be
:    fixed
:  - if we fix ptlock_free() to handle NULL, then all the _dtor()
:    functions can use it, and we can observe they're all identical
:    and can be folded
: 
: after all that cleanup, you can move the _dtor from *_free_tlb() into
: tlb_remove_table() -- which for the above case, would then have it called
: from __tlb_remove_table_free().


This patch (of 16):

{pmd,pud,p4d}_alloc_one() is never called if the corresponding page table
level is folded, as {pmd,pud,p4d}_alloc() already does the required check.
We can therefore remove the runtime page table level checks in
{pud,p4d}_alloc_one.  The PUD helper becomes equivalent to the generic
version, so we remove it altogether.

This is consistent with the way arm64 and x86 handle this situation
(runtime check in p4d_free() only).

Link: https://lkml.kernel.org/r/cover.1736317725.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/93a1c6bddc0ded9f1a9f15658c1e4af5c93d1194.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgalloc.h |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/arch/riscv/include/asm/pgalloc.h~riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -12,7 +12,6 @@
 #include <asm/tlb.h>
 
 #ifdef CONFIG_MMU
-#define __HAVE_ARCH_PUD_ALLOC_ONE
 #define __HAVE_ARCH_PUD_FREE
 #include <asm-generic/pgalloc.h>
 
@@ -88,15 +87,6 @@ static inline void pgd_populate_safe(str
 	}
 }
 
-#define pud_alloc_one pud_alloc_one
-static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
-{
-	if (pgtable_l4_enabled)
-		return __pud_alloc_one(mm, addr);
-
-	return NULL;
-}
-
 #define pud_free pud_free
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
 {
@@ -118,15 +108,11 @@ static inline void __pud_free_tlb(struct
 #define p4d_alloc_one p4d_alloc_one
 static inline p4d_t *p4d_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	if (pgtable_l5_enabled) {
-		gfp_t gfp = GFP_PGTABLE_USER;
-
-		if (mm == &init_mm)
-			gfp = GFP_PGTABLE_KERNEL;
-		return (p4d_t *)get_zeroed_page(gfp);
-	}
+	gfp_t gfp = GFP_PGTABLE_USER;
 
-	return NULL;
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	return (p4d_t *)get_zeroed_page(gfp);
 }
 
 static inline void __p4d_free(struct mm_struct *mm, p4d_t *p4d)
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


