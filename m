Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EB714EC42
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714067274; cv=none; b=m76MXKc17diajP5sDj7Sc6hbMYfBJY4aysObwYCk6hSlQlXRCWsc0y2ygbnWhV7/qGY7Ai4m3i2aFZvxTja44kfon7qvog1pDqxhqCxaDa0oEEidoCfR7vmU8CL3li5YdBTgQlskrj6zZhcXnx+E7Oh7XLh0+PUM2x8UCyxiz5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714067274; c=relaxed/simple;
	bh=88RnhWE3AQqyQMm72Q/gNcMiJfCgAfbG7w2J4/C+BN0=;
	h=Date:To:From:Subject:Message-Id; b=cTO9iqQn7b5rFdhAsMqEH9JTPhIvkDCPh58pUwQ6oSrxWcN/f0dxrHvU1MAQAG1R6ZCFF2THFgvWIfdnh1O+frtHcTk/Y8CN9wcwuiN040UN5yzMXbXJoElr6+rO22p1vh/CRCLqAdF4pWuiFqewoDyQFXL0rkk/LuDLHX9PzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=StJ6nLO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="StJ6nLO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199E0C113CC;
	Thu, 25 Apr 2024 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714067274;
	bh=88RnhWE3AQqyQMm72Q/gNcMiJfCgAfbG7w2J4/C+BN0=;
	h=Date:To:From:Subject:From;
	b=StJ6nLO3DbEim7eg970U2xM0HiECdm+zqytmcSHCDszbl0fiv1A0eZb5rkq8pd5Fs
	 BtyCkpuRehXekSmXqY6qdxMmpJrXcEULrWCO4zOCoVNu1zbB1aLmCtRRpLS514FNOA
	 6xerWbWZrZll+NdFP3jWcaDnjRmlyDH4IxAhIYJ0=
Date: Thu, 25 Apr 2024 10:47:53 -0700
To: mm-commits@vger.kernel.org,zi.yan@cs.rutgers.edu,aneesh.kumar@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch added to mm-unstable branch
Message-Id: <20240425174754.199E0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix race between __split_huge_pmd_locked() and GUP-fast
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: fix race between __split_huge_pmd_locked() and GUP-fast
Date: Thu, 25 Apr 2024 18:07:04 +0100

__split_huge_pmd_locked() can be called for a present THP, devmap or
(non-present) migration entry.  It calls pmdp_invalidate() unconditionally
on the pmdp and only determines if it is present or not based on the
returned old pmd.  This is a problem for the migration entry case because
pmd_mkinvalid(), called by pmdp_invalidate() must only be called for a
present pmd.

On arm64 at least, pmd_mkinvalid() will mark the pmd such that any future
call to pmd_present() will return true.  And therefore any lockless
pgtable walker could see the migration entry pmd in this state and start
interpretting the fields as if it were present, leading to BadThings (TM).
GUP-fast appears to be one such lockless pgtable walker.  I suspect the
same is possible on other architectures.

Fix this by only calling pmdp_invalidate() for a present pmd.  And for
good measure let's add a warning to the generic implementation of
pmdp_invalidate().  I've manually reviewed all other
pmdp_invalidate[_ad]() call sites and believe all others to be conformant.

This is a theoretical bug found during code review. I don't have any
test case to trigger it in practice.

Link: https://lkml.kernel.org/r/20240425170704.3379492-1-ryan.roberts@arm.com
Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c     |    5 +++--
 mm/pgtable-generic.c |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast
+++ a/mm/huge_memory.c
@@ -2533,12 +2533,12 @@ static void __split_huge_pmd_locked(stru
 	 * for this pmd), then we flush the SMP TLB and finally we write the
 	 * non-huge version of the pmd entry with pmd_populate.
 	 */
-	old_pmd = pmdp_invalidate(vma, haddr, pmd);
 
-	pmd_migration = is_pmd_migration_entry(old_pmd);
+	pmd_migration = is_pmd_migration_entry(*pmd);
 	if (unlikely(pmd_migration)) {
 		swp_entry_t entry;
 
+		old_pmd = *pmd;
 		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_swap_entry_to_page(entry);
 		write = is_writable_migration_entry(entry);
@@ -2549,6 +2549,7 @@ static void __split_huge_pmd_locked(stru
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
+		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
 		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
--- a/mm/pgtable-generic.c~mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast
+++ a/mm/pgtable-generic.c
@@ -198,6 +198,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
+	VM_WARN_ON(!pmd_present(*pmdp));
 	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return old;
@@ -208,6 +209,7 @@ pmd_t pmdp_invalidate(struct vm_area_str
 pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 			 pmd_t *pmdp)
 {
+	VM_WARN_ON(!pmd_present(*pmdp));
 	return pmdp_invalidate(vma, address, pmdp);
 }
 #endif
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache-fix.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch
selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

