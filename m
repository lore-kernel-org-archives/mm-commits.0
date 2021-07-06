Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41C9C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB38C61C97
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhGFTWC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231909AbhGFTWB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A41861C7A;
        Tue,  6 Jul 2021 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599162;
        bh=g++46CcAyPhJ6bMk8AmEd1t74sqg314zvYPg+az1VG0=;
        h=Date:From:To:Subject:From;
        b=XMJ0bO/qhvTHtotJkiE5E4lfdWlAIh0wObGSPgTHgGh+2Q7VVIzi3j8gfWrtvbv0I
         2VjJBdBI3czRtwYACKM7UgMqQjQVMiJDeGLnWRc/Teu1xakIDpjcnR3TDfpMPJEhX2
         YvmyYtJdvGqgG/bti146VnkuA2wofns5URO46i+4=
Date:   Tue, 06 Jul 2021 12:19:22 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, catalin.marinas@arm.com,
        david@redhat.com, mm-commits@vger.kernel.org, rppt@kernel.org,
        rppt@linux.ibm.com, will@kernel.org
Subject:  [merged] arm64-mm-drop-have_arch_pfn_valid.patch removed
 from -mm tree
Message-ID: <20210706191922.tOIuCD3FY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: drop HAVE_ARCH_PFN_VALID
has been removed from the -mm tree.  Its filename was
     arm64-mm-drop-have_arch_pfn_valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch

