Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5815C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 19:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjFIT1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 15:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjFIT1v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 15:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1ED30FF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 12:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847DA65B4B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 19:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C58C433D2;
        Fri,  9 Jun 2023 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686338866;
        bh=kur796kW22WFo9V27qOqjN0eR4Ad92FZx3V6fNHAPgc=;
        h=Date:To:From:Subject:From;
        b=yXARDrtPXrxmLPM8dwy2UnK7EBAmBb+TiwP5yfNQSje5O5L2P7mFCq7/d0FK3kxGQ
         sNDtYqzS2SG0+PKBg4zOg4SZprbLauxX4SJrKo4Q7Af57JMgwY3SXKWXRXrSnTTpKb
         esRUJdyCg5cxjWZNxUpuU9Tmj2TgABt6R3G94ftk=
Date:   Fri, 09 Jun 2023 12:27:46 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-update_mmu_cache-can-replace-__update_tlb-fix.patch added to mm-unstable branch
Message-Id: <20230609192746.D3C58C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: update_mmu_cache() can replace __update_tlb(): fix
has been added to the -mm mm-unstable branch.  Its filename is
     mips-update_mmu_cache-can-replace-__update_tlb-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-update_mmu_cache-can-replace-__update_tlb-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mips: update_mmu_cache() can replace __update_tlb(): fix
Date: Fri, 9 Jun 2023 01:08:52 -0700 (PDT)

I expect this to fix the
arch/mips/mm/tlb-r4k.c:300:16: warning: variable 'pmdp' set but not used
reported by the kernel test robot; but I am uncomfortable rearranging
lines in this tlb_probe_hazard() area, and would be glad for review and
testing by someone familiar with mips - thanks in advance!

Link: https://lkml.kernel.org/r/6852be98-64e6-6092-d1c-13124b97bc75@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306091304.cNVIspK0-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/tlb-r4k.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/mips/mm/tlb-r4k.c~mips-update_mmu_cache-can-replace-__update_tlb-fix
+++ a/arch/mips/mm/tlb-r4k.c
@@ -293,11 +293,13 @@ void local_flush_tlb_one(unsigned long p
 void update_mmu_cache(struct vm_area_struct *vma,
 		      unsigned long address, pte_t *ptep)
 {
-	unsigned long flags;
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
+#endif
+	unsigned long flags;
 	int idx, pid;
 
 	/*
@@ -316,15 +318,15 @@ void update_mmu_cache(struct vm_area_str
 		pid = read_c0_entryhi() & cpu_asid_mask(&current_cpu_data);
 		write_c0_entryhi(address | pid);
 	}
-	pgdp = pgd_offset(vma->vm_mm, address);
 	mtc0_tlbw_hazard();
 	tlb_probe();
 	tlb_probe_hazard();
+	idx = read_c0_index();
+#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
+	pgdp = pgd_offset(vma->vm_mm, address);
 	p4dp = p4d_offset(pgdp, address);
 	pudp = pud_offset(p4dp, address);
 	pmdp = pmd_offset(pudp, address);
-	idx = read_c0_index();
-#ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	/* this could be a huge page  */
 	if (ptep == (pte_t *)pmdp) {
 		unsigned long lo;
_

Patches currently in -mm which might be from hughd@google.com are

arm-allow-pte_offset_map-to-fail.patch
arm64-allow-pte_offset_map-to-fail.patch
arm64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
ia64-hugetlb-pte_alloc_huge-pte_offset_huge.patch
m68k-allow-pte_offset_map-to-fail.patch
microblaze-allow-pte_offset_map-to-fail.patch
mips-update_mmu_cache-can-replace-__update_tlb.patch
mips-update_mmu_cache-can-replace-__update_tlb-fix.patch
parisc-add-pte_unmap-to-balance-get_ptep.patch
parisc-unmap_uncached_pte-use-pte_offset_kernel.patch
parisc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
powerpc-kvmppc_unmap_free_pmd-pte_offset_kernel.patch
powerpc-allow-pte_offset_map-to-fail.patch
powerpc-hugetlb-pte_alloc_huge.patch
riscv-hugetlb-pte_alloc_huge-pte_offset_huge.patch
s390-allow-pte_offset_map_lock-to-fail.patch
s390-gmap-use-pte_unmap_unlock-not-spin_unlock.patch
sh-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-hugetlb-pte_alloc_huge-pte_offset_huge.patch
sparc-allow-pte_offset_map-to-fail.patch
sparc-iounit-and-iommu-use-pte_offset_kernel.patch
x86-allow-get_locked_pte-to-fail.patch
x86-sme_populate_pgd-use-pte_offset_kernel.patch
xtensa-add-pte_unmap-to-balance-pte_offset_map.patch

