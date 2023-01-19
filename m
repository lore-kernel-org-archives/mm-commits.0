Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EE5C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjASBTb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjASBRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D023A6921B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8692BB81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E1FC433EF;
        Thu, 19 Jan 2023 01:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090933;
        bh=ZnATWSfeh/vC7kIB7ANFpinXfBOxk+Owi1C7NHT7fBs=;
        h=Date:To:From:Subject:From;
        b=1rSfktpnUGYknK8DohxKKkASbBYTBm9lf97TnmHNZ7f2MD957MQgGxxilWFBH+KnC
         cfELpv2wiD7XUGimYS0M8RifFQ2dW72vvyeqkpkLFcjntlhZRWGeJZiwEQ8qXZ8tIF
         DQx4BlgDGTLtBK3CuR2kM8R1PXufbMenvq1yr8D0=
Date:   Wed, 18 Jan 2023 17:15:32 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        nadav.amit@gmail.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch removed from -mm tree
Message-Id: <20230119011533.32E1FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: drop pgprot_t parameter from change_protection()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mprotect: drop pgprot_t parameter from change_protection()
Date: Fri, 23 Dec 2022 16:56:16 +0100

Being able to provide a custom protection opens the door for
inconsistencies and BUGs: for example, accidentally allowing for more
permissions than desired by other mechanisms (e.g., softdirty tracking). 
vma->vm_page_prot should be the single source of truth.

Only PROT_NUMA is special: there is no way we can erroneously allow
for more permissions when removing all permissions. Special-case using
the MM_CP_PROT_NUMA flag.

[david@redhat.com: PAGE_NONE might not be defined without CONFIG_NUMA_BALANCING]  
  Link: https://lkml.kernel.org/r/5084ff1c-ebb3-f918-6a60-bacabf550a88@redhat.com
Link: https://lkml.kernel.org/r/20221223155616.297723-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 mm/mempolicy.c     |    3 +--
 mm/mprotect.c      |   18 +++++++++++++++---
 mm/userfaultfd.c   |    3 +--
 4 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/include/linux/mm.h
@@ -2134,8 +2134,7 @@ bool can_change_pte_writable(struct vm_a
 			     pte_t pte);
 extern unsigned long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
-			      unsigned long end, pgprot_t newprot,
-			      unsigned long cp_flags);
+			      unsigned long end, unsigned long cp_flags);
 extern int mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
--- a/mm/mempolicy.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/mempolicy.c
@@ -635,8 +635,7 @@ unsigned long change_prot_numa(struct vm
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	nr_updated = change_protection(&tlb, vma, addr, end, PAGE_NONE,
-				       MM_CP_PROT_NUMA);
+	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
 	if (nr_updated)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
--- a/mm/mprotect.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/mprotect.c
@@ -507,13 +507,25 @@ static unsigned long change_protection_r
 
 unsigned long change_protection(struct mmu_gather *tlb,
 		       struct vm_area_struct *vma, unsigned long start,
-		       unsigned long end, pgprot_t newprot,
-		       unsigned long cp_flags)
+		       unsigned long end, unsigned long cp_flags)
 {
+	pgprot_t newprot = vma->vm_page_prot;
 	unsigned long pages;
 
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 
+#ifdef CONFIG_NUMA_BALANCING
+	/*
+	 * Ordinary protection updates (mprotect, uffd-wp, softdirty tracking)
+	 * are expected to reflect their requirements via VMA flags such that
+	 * vma_set_page_prot() will adjust vma->vm_page_prot accordingly.
+	 */
+	if (cp_flags & MM_CP_PROT_NUMA)
+		newprot = PAGE_NONE;
+#else
+	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
+#endif
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
@@ -642,7 +654,7 @@ success:
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
 
-	change_protection(tlb, vma, start, end, vma->vm_page_prot, mm_cp_flags);
+	change_protection(tlb, vma, start, end, mm_cp_flags);
 
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
--- a/mm/userfaultfd.c~mm-mprotect-drop-pgprot_t-parameter-from-change_protection
+++ a/mm/userfaultfd.c
@@ -730,8 +730,7 @@ void uffd_wp_range(struct mm_struct *dst
 	if (!enable_wp && vma_wants_manual_pte_write_upgrade(dst_vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	tlb_gather_mmu(&tlb, dst_mm);
-	change_protection(&tlb, dst_vma, start, start + len, vma->vm_page_prot,
-			  mm_cp_flags);
+	change_protection(&tlb, dst_vma, start, start + len, mm_cp_flags);
 	tlb_finish_mmu(&tlb);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

