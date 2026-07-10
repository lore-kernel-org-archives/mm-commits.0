Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC56D34AB03
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718043; cv=none; b=UWdgUHJhwwEFbGLtyKEUTeW5jpH0EdSfDNmbqiIZWMSAIAiuLrg7JkiUs4tHlnzQBbX9USDnJPdwPwE6Oa3h1PqSVzcCWaZG88AoHKEhYfeslYT6z6mLy1kTyY9omvIlDA5M4kaYE3Ww1Yyyt+wFG1OFIyeNKuIWPJK+dYCqLH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718043; c=relaxed/simple;
	bh=tjbYgmPHZB+klVaBP1s1qZOeI2ZJUuWCy6dWBQ4q5GE=;
	h=Date:To:From:Subject:Message-Id; b=azqKSa8c60fxCloDDMvftsmeF6gvGzX1yhEqQDc3nlkcfoncNaF4U23li5TFmQPqSlYck0gXrC1Wz5Hifz6Qp4DRtQCROWxTch6NTu6kPnBw4dVSFUiNdrkvBHGbgdJb/a3mNMLIGV+0uDhsnRebT6wamaIaw2B65OPn1kXgiC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kzWc5PY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kzWc5PY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEB61F000E9;
	Fri, 10 Jul 2026 21:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783718041;
	bh=ko73lEztljDB0q+f7Mq3XOm62ypbAHD9iwPdS4SIaxU=;
	h=Date:To:From:Subject;
	b=kzWc5PY5TX/ES0Z86UNVU1C50NBJa2M4eIoX6TuX71e1IV6+N5ge1DQWy4Gp0yvXo
	 T280HgcCPmYSAW3nifh0zZ2NQSeRSTOz+mJEswaZEhvsYw3ma2zGmImnkVWgS0NPna
	 F/iG+fD+IjX8bxvqAFMHQ0LaAfddtqOyC4ZjBZJY=
Date: Fri, 10 Jul 2026 14:14:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,urezki@gmail.com,toshi.kani@hpe.com,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,liam@infradead.org,devnexen@gmail.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-arm64-enable-vmalloc-huge-with-ptdump.patch added to mm-new branch
Message-Id: <20260710211401.9FEB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "arm64: Enable vmalloc-huge with ptdump"
has been added to the -mm mm-new branch.  Its filename is
     revert-arm64-enable-vmalloc-huge-with-ptdump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-arm64-enable-vmalloc-huge-with-ptdump.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: Revert "arm64: Enable vmalloc-huge with ptdump"
Date: Fri, 10 Jul 2026 11:49:19 +0100

This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
with ptdump"), retaining vmalloc-huge support but eliminating the now
redundant mitigation against a race between huge vmap page table freeing
and ptdump, as this issue has now been fixed at core.

We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
read lock upon vmap huge page table promotion as it is no longer required.

Link: https://lore.kernel.org/20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David CARLIER <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/ptdump.h |    2 -
 arch/arm64/mm/mmu.c             |   43 ++----------------------------
 arch/arm64/mm/ptdump.c          |   11 +------
 mm/vmalloc.c                    |   15 ++--------
 4 files changed, 9 insertions(+), 62 deletions(-)

--- a/arch/arm64/include/asm/ptdump.h~revert-arm64-enable-vmalloc-huge-with-ptdump
+++ a/arch/arm64/include/asm/ptdump.h
@@ -7,8 +7,6 @@
 
 #include <linux/ptdump.h>
 
-DECLARE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
-
 #ifdef CONFIG_PTDUMP
 
 #include <linux/mm_types.h>
--- a/arch/arm64/mm/mmu.c~revert-arm64-enable-vmalloc-huge-with-ptdump
+++ a/arch/arm64/mm/mmu.c
@@ -49,8 +49,6 @@
 #define NO_CONT_MAPPINGS	BIT(1)
 #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
 
-DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
-
 u64 kimage_voffset __ro_after_init;
 EXPORT_SYMBOL(kimage_voffset);
 
@@ -1857,8 +1855,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 	return 1;
 }
 
-static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
-			       bool acquire_mmap_lock)
+int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
 	pte_t *table;
 	pmd_t pmd;
@@ -1870,25 +1867,13 @@ static int __pmd_free_pte_page(pmd_t *pm
 		return 1;
 	}
 
-	/* See comment in pud_free_pmd_page for static key logic */
 	table = pte_offset_kernel(pmdp, addr);
 	pmd_clear(pmdp);
 	__flush_tlb_kernel_pgtable(addr);
-	if (static_branch_unlikely(&arm64_ptdump_lock_key) && acquire_mmap_lock) {
-		mmap_read_lock(&init_mm);
-		mmap_read_unlock(&init_mm);
-	}
-
 	pte_free_kernel(NULL, table);
 	return 1;
 }
 
-int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
-{
-	/* If ptdump is walking the pagetables, acquire init_mm.mmap_lock */
-	return __pmd_free_pte_page(pmdp, addr, /* acquire_mmap_lock = */ true);
-}
-
 int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
 {
 	pmd_t *table;
@@ -1904,36 +1889,16 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	}
 
 	table = pmd_offset(pudp, addr);
-
-	/*
-	 * Our objective is to prevent ptdump from reading a PMD table which has
-	 * been freed. In this race, if pud_free_pmd_page observes the key on
-	 * (which got flipped by ptdump) then the mmap lock sequence here will,
-	 * as a result of the mmap write lock/unlock sequence in ptdump, give
-	 * us the correct synchronization. If not, this means that ptdump has
-	 * yet not started walking the pagetables - the sequence of barriers
-	 * issued by __flush_tlb_kernel_pgtable() guarantees that ptdump will
-	 * observe an empty PUD.
-	 */
-	pud_clear(pudp);
-	__flush_tlb_kernel_pgtable(addr);
-	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
-		mmap_read_lock(&init_mm);
-		mmap_read_unlock(&init_mm);
-	}
-
 	pmdp = table;
 	next = addr;
 	end = addr + PUD_SIZE;
 	do {
 		if (pmd_present(pmdp_get(pmdp)))
-			/*
-			 * PMD has been isolated, so ptdump won't see it. No
-			 * need to acquire init_mm.mmap_lock.
-			 */
-			__pmd_free_pte_page(pmdp, next, /* acquire_mmap_lock = */ false);
+			pmd_free_pte_page(pmdp, next);
 	} while (pmdp++, next += PMD_SIZE, next != end);
 
+	pud_clear(pudp);
+	__flush_tlb_kernel_pgtable(addr);
 	pmd_free(NULL, table);
 	return 1;
 }
--- a/arch/arm64/mm/ptdump.c~revert-arm64-enable-vmalloc-huge-with-ptdump
+++ a/arch/arm64/mm/ptdump.c
@@ -283,13 +283,6 @@ void note_page_flush(struct ptdump_state
 	note_page(pt_st, 0, -1, pte_val(pte_zero));
 }
 
-static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
-{
-	static_branch_inc(&arm64_ptdump_lock_key);
-	ptdump_walk_pgd(st, mm, NULL);
-	static_branch_dec(&arm64_ptdump_lock_key);
-}
-
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 {
 	unsigned long end = ~0UL;
@@ -318,7 +311,7 @@ void ptdump_walk(struct seq_file *s, str
 		}
 	};
 
-	arm64_ptdump_walk_pgd(&st.ptdump, info->mm);
+	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
 }
 
 static void __init ptdump_initialize(void)
@@ -360,7 +353,7 @@ bool ptdump_check_wx(void)
 		}
 	};
 
-	arm64_ptdump_walk_pgd(&st.ptdump, &init_mm);
+	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
 	if (st.wx_pages || st.uxn_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
--- a/mm/vmalloc.c~revert-arm64-enable-vmalloc-huge-with-ptdump
+++ a/mm/vmalloc.c
@@ -188,10 +188,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd,
 	 * Therefore, acquire the mmap read lock to prevent use-after-free when
 	 * freeing page tables.
 	 */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pmd_free_pte_page(pmd, addr))
 			return 0;
 		return pmd_set_huge(pmd, phys_addr, prot);
@@ -248,10 +245,7 @@ static int vmap_try_huge_pud(pud_t *pud,
 		return pud_set_huge(pud, phys_addr, prot);
 
 	/* See comment in vmap_try_huge_pmd(). */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!pud_free_pmd_page(pud, addr))
 			return 0;
 		return pud_set_huge(pud, phys_addr, prot);
@@ -308,10 +302,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d,
 		return p4d_set_huge(p4d, phys_addr, prot);
 
 	/* See comment in vmap_try_huge_pmd(). */
-#ifndef CONFIG_ARM64
-	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
-#endif
-	{
+	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
 		if (!p4d_free_pud_page(p4d, addr))
 			return 0;
 		return p4d_set_huge(p4d, phys_addr, prot);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch

