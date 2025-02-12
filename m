Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA321F8BCA;
	Wed, 12 Feb 2025 07:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739343875; cv=none; b=S80Hysq/QXlma8glRRtb0Wkz3Tj1JlwOBbrMVS2OPQtv+WMQM/CU7a1oej8AVSLNNA+MlbCYDKGnzzFt9tp8CzoWSdzTFwXJB0NuagywGAT/eNNJmAo5QdboZXSUwuyD3X0vH9rhWW1QNpkljIlB+nAYHPtVDnMmP3CS4rKPZPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739343875; c=relaxed/simple;
	bh=7aYZTVeKHA59epQdC4mpWCUcpBLfULI6G5NrOYtBcEc=;
	h=Date:To:From:Subject:Message-Id; b=E5NOkBTI/zTws0GeCcS/6JTf7pK4Jq9zOsfBVBELIUya4x62VgG/DcrbhNxqiKr2ch7PMRwAKZdPQoGKF1Msj4cm/yWIUXylLpEf49tquEgLhFSf8vn0KejHVpujldOE5r9GAXgNj8cvt18CvTmFs9Mu1RQYqZqHuhyHRJG/75o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sj6xgGTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sj6xgGTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC518C4CEDF;
	Wed, 12 Feb 2025 07:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739343875;
	bh=7aYZTVeKHA59epQdC4mpWCUcpBLfULI6G5NrOYtBcEc=;
	h=Date:To:From:Subject:From;
	b=sj6xgGTXmke2mmIPTg/wZBlOdw4/vcOlWcy6VQdFiOTiJC1hwyaG+pdzZ1Oxma6af
	 tQekat5jnTma/STgxWnSdvz3BBwFMHHhL+1UOOSqY2XFSDjRt6ezG8TExShmmUl597
	 gJPQ9gxbUTO153i/fsTm+QMopLUBUCo01+plirdA=
Date: Tue, 11 Feb 2025 23:04:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,muchun.song@linux.dev,linux@armlinux.org.uk,hughd@google.com,ezra@easyb.ch,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-pgtable-fix-null-pointer-dereference-issue.patch added to mm-hotfixes-unstable branch
Message-Id: <20250212070434.EC518C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm: pgtable: fix NULL pointer dereference issue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm-pgtable-fix-null-pointer-dereference-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-pgtable-fix-null-pointer-dereference-issue.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: arm: pgtable: fix NULL pointer dereference issue
Date: Wed, 12 Feb 2025 14:40:02 +0800

When update_mmu_cache_range() is called by update_mmu_cache(), the vmf
parameter is NULL, which will cause a NULL pointer dereference issue in
adjust_pte():

Unable to handle kernel NULL pointer dereference at virtual address 00000030 when read
Hardware name: Atmel AT91SAM9
PC is at update_mmu_cache_range+0x1e0/0x278
LR is at pte_offset_map_rw_nolock+0x18/0x2c
Call trace:
 update_mmu_cache_range from remove_migration_pte+0x29c/0x2ec
 remove_migration_pte from rmap_walk_file+0xcc/0x130
 rmap_walk_file from remove_migration_ptes+0x90/0xa4
 remove_migration_ptes from migrate_pages_batch+0x6d4/0x858
 migrate_pages_batch from migrate_pages+0x188/0x488
 migrate_pages from compact_zone+0x56c/0x954
 compact_zone from compact_node+0x90/0xf0
 compact_node from kcompactd+0x1d4/0x204
 kcompactd from kthread+0x120/0x12c
 kthread from ret_from_fork+0x14/0x38
Exception stack(0xc0d8bfb0 to 0xc0d8bff8)

To fix it, do not rely on whether 'ptl' is equal to decide whether to hold
the pte lock, but decide it by whether CONFIG_SPLIT_PTE_PTLOCKS is
enabled. In addition, if two vmas map to the same PTE page, there is no
need to hold the pte lock again, otherwise a deadlock will occur. Just add
the need_lock parameter to let adjust_pte() know this information.

Link: https://lkml.kernel.org/r/20250212064002.55598-1-zhengqi.arch@bytedance.com
Fixes: fc9c45b71f43 ("arm: adjust_pte() use pte_offset_map_rw_nolock()")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Ezra Buehler <ezra@easyb.ch>
Closes: https://lore.kernel.org/lkml/CAM1KZSmZ2T_riHvay+7cKEFxoPgeVpHkVFTzVVEQ1BO0cLkHEQ@mail.gmail.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault-armv.c |   40 +++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/arch/arm/mm/fault-armv.c~arm-pgtable-fix-null-pointer-dereference-issue
+++ a/arch/arm/mm/fault-armv.c
@@ -62,7 +62,7 @@ static int do_adjust_pte(struct vm_area_
 }
 
 static int adjust_pte(struct vm_area_struct *vma, unsigned long address,
-		      unsigned long pfn, struct vm_fault *vmf)
+		      unsigned long pfn, bool need_lock)
 {
 	spinlock_t *ptl;
 	pgd_t *pgd;
@@ -99,12 +99,11 @@ again:
 	if (!pte)
 		return 0;
 
-	/*
-	 * If we are using split PTE locks, then we need to take the page
-	 * lock here.  Otherwise we are using shared mm->page_table_lock
-	 * which is already locked, thus cannot take it.
-	 */
-	if (ptl != vmf->ptl) {
+	if (need_lock) {
+		/*
+		 * Use nested version here to indicate that we are already
+		 * holding one similar spinlock.
+		 */
 		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 		if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 			pte_unmap_unlock(pte, ptl);
@@ -114,7 +113,7 @@ again:
 
 	ret = do_adjust_pte(vma, address, pfn, pte);
 
-	if (ptl != vmf->ptl)
+	if (need_lock)
 		spin_unlock(ptl);
 	pte_unmap(pte);
 
@@ -123,16 +122,17 @@ again:
 
 static void
 make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
-	      unsigned long addr, pte_t *ptep, unsigned long pfn,
-	      struct vm_fault *vmf)
+	      unsigned long addr, pte_t *ptep, unsigned long pfn)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *mpnt;
 	unsigned long offset;
+	unsigned long start;
 	pgoff_t pgoff;
 	int aliases = 0;
 
 	pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	start = ALIGN_DOWN(addr, PMD_SIZE);
 
 	/*
 	 * If we have any shared mappings that are in the same mm
@@ -141,6 +141,14 @@ make_coherent(struct address_space *mapp
 	 */
 	flush_dcache_mmap_lock(mapping);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long mpnt_addr;
+		/*
+		 * If we are using split PTE locks, then we need to take the pte
+		 * lock. Otherwise we are using shared mm->page_table_lock which
+		 * is already locked, thus cannot take it.
+		 */
+		bool need_lock = IS_ENABLED(CONFIG_SPLIT_PTE_PTLOCKS);
+
 		/*
 		 * If this VMA is not in our MM, we can ignore it.
 		 * Note that we intentionally mask out the VMA
@@ -151,7 +159,15 @@ make_coherent(struct address_space *mapp
 		if (!(mpnt->vm_flags & VM_MAYSHARE))
 			continue;
 		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
-		aliases += adjust_pte(mpnt, mpnt->vm_start + offset, pfn, vmf);
+		mpnt_addr = mpnt->vm_start + offset;
+		/*
+		 * If mpnt_addr and addr are mapped to the same PTE page, there
+		 * is no need to hold the pte lock again, otherwise a deadlock
+		 * will occur.
+		 */
+		if (mpnt_addr >= start && mpnt_addr - start < PMD_SIZE)
+			need_lock = false;
+		aliases += adjust_pte(mpnt, mpnt_addr, pfn, need_lock);
 	}
 	flush_dcache_mmap_unlock(mapping);
 	if (aliases)
@@ -194,7 +210,7 @@ void update_mmu_cache_range(struct vm_fa
 		__flush_dcache_folio(mapping, folio);
 	if (mapping) {
 		if (cache_is_vivt())
-			make_coherent(mapping, vma, addr, ptep, pfn, vmf);
+			make_coherent(mapping, vma, addr, ptep, pfn);
 		else if (vma->vm_flags & VM_EXEC)
 			__flush_icache_all();
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-fix-incorrect-reclaim-of-non-empty-pte-pages.patch
arm-pgtable-fix-null-pointer-dereference-issue.patch

