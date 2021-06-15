Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE175C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60D4611CE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhFOAN4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFOAN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 20:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF79611CE;
        Tue, 15 Jun 2021 00:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623715898;
        bh=TpZvyGEfIuFa+nNoGPm64YsyZJjWMWGT4BfZOtVXdL4=;
        h=Date:From:To:Subject:From;
        b=slfeOyI+XSuk8G6E+u2hMJF26N03dH7IrI25gn/SpG/+NRFoj4Kq0O8bDGce/VnB8
         fJhKDS22iELS/s5VlIyMN94NUEryCdm/PV5073+RtQGrVRUCrj7zMeJeqTv+ic8Lk4
         h7cpbPtx0HBs+cJY6WWMF9xXz51PvI/99esV5JPw=
Date:   Mon, 14 Jun 2021 17:11:37 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, catalin.marinas@arm.com,
        david@redhat.com, mm-commits@vger.kernel.org, rppt@kernel.org,
        rppt@linux.ibm.com, will@kernel.org
Subject:  + arm64-mm-drop-have_arch_pfn_valid.patch added to -mm
 tree
Message-ID: <20210615001137.qOiQI3w4P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: drop HAVE_ARCH_PFN_VALID
has been added to the -mm tree.  Its filename is
     arm64-mm-drop-have_arch_pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-drop-have_arch_pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-drop-have_arch_pfn_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: drop HAVE_ARCH_PFN_VALID

CONFIG_SPARSEMEM_VMEMMAP is now the only available memory model on arm64
platforms and free_unused_memmap() would just return without creating any
holes in the memmap mapping.  There is no need for any special handling in
pfn_valid() and HAVE_ARCH_PFN_VALID can just be dropped.  This also moves
the pfn upper bits sanity check into generic pfn_valid().

Link: https://lkml.kernel.org/r/1621947349-25421-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig            |    1 
 arch/arm64/include/asm/page.h |    1 
 arch/arm64/mm/init.c          |   37 --------------------------------
 include/linux/mmzone.h        |    9 +++++++
 4 files changed, 9 insertions(+), 39 deletions(-)

--- a/arch/arm64/include/asm/page.h~arm64-mm-drop-have_arch_pfn_valid
+++ a/arch/arm64/include/asm/page.h
@@ -37,7 +37,6 @@ void copy_highpage(struct page *to, stru
 
 typedef struct page *pgtable_t;
 
-int pfn_valid(unsigned long pfn);
 int pfn_is_map_memory(unsigned long pfn);
 
 #include <asm/memory.h>
--- a/arch/arm64/Kconfig~arm64-mm-drop-have_arch_pfn_valid
+++ a/arch/arm64/Kconfig
@@ -154,7 +154,6 @@ config ARM64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
-	select HAVE_ARCH_PFN_VALID
 	select HAVE_ARCH_PREL32_RELOCATIONS
 	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
--- a/arch/arm64/mm/init.c~arm64-mm-drop-have_arch_pfn_valid
+++ a/arch/arm64/mm/init.c
@@ -219,43 +219,6 @@ static void __init zone_sizes_init(unsig
 	free_area_init(max_zone_pfns);
 }
 
-int pfn_valid(unsigned long pfn)
-{
-	phys_addr_t addr = PFN_PHYS(pfn);
-	struct mem_section *ms;
-
-	/*
-	 * Ensure the upper PAGE_SHIFT bits are clear in the
-	 * pfn. Else it might lead to false positives when
-	 * some of the upper bits are set, but the lower bits
-	 * match a valid pfn.
-	 */
-	if (PHYS_PFN(addr) != pfn)
-		return 0;
-
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-
-	ms = __pfn_to_section(pfn);
-	if (!valid_section(ms))
-		return 0;
-
-	/*
-	 * ZONE_DEVICE memory does not have the memblock entries.
-	 * memblock_is_map_memory() check for ZONE_DEVICE based
-	 * addresses will always fail. Even the normal hotplugged
-	 * memory will never have MEMBLOCK_NOMAP flag set in their
-	 * memblock entries. Skip memblock search for all non early
-	 * memory sections covering all of hotplug memory including
-	 * both normal and ZONE_DEVICE based.
-	 */
-	if (!early_section(ms))
-		return pfn_section_valid(ms, pfn);
-
-	return memblock_is_memory(addr);
-}
-EXPORT_SYMBOL(pfn_valid);
-
 int pfn_is_map_memory(unsigned long pfn)
 {
 	phys_addr_t addr = PFN_PHYS(pfn);
--- a/include/linux/mmzone.h~arm64-mm-drop-have_arch_pfn_valid
+++ a/include/linux/mmzone.h
@@ -1460,6 +1460,15 @@ static inline int pfn_valid(unsigned lon
 {
 	struct mem_section *ms;
 
+	/*
+	 * Ensure the upper PAGE_SHIFT bits are clear in the
+	 * pfn. Else it might lead to false positives when
+	 * some of the upper bits are set, but the lower bits
+	 * match a valid pfn.
+	 */
+	if (PHYS_PFN(PFN_PHYS(pfn)) != pfn)
+		return 0;
+
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	ms = __nr_to_section(pfn_to_section_nr(pfn));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-ensure-thp-availability-via-has_transparent_hugepage.patch
arm64-mm-drop-have_arch_pfn_valid.patch
mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
mm-thp-make-arch_enable_split_pmd_ptlock-dependent-on-pgtable_levels-2.patch
mm-define-default-value-for-first_user_address.patch

