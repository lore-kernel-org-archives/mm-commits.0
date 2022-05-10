Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E4FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiEJEPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbiEJEPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9066931924
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B0356173E
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C484C385A6;
        Tue, 10 May 2022 04:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155864;
        bh=dmk9GTk+KyrF6wxKACvY63aAugE/Y4zRujojtFybCTQ=;
        h=Date:To:From:Subject:From;
        b=2QH2Gywt3j/cTePgJ8XBICR7u5hnNAaIIvMheUFVZXkQrBpS7dh5nnTzVbAi1vbwy
         1U0zIcy+WDdDZNRBsyPvOFpI7VOiJykIRwirCsNnWXdZR9zKpwlyIo88YZWViPlhnS
         wgJuMs7QvrvZthiMO0+bCZ+pPsKfziLv0+/gH9Qk=
Date:   Mon, 09 May 2022 21:11:03 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, rientjes@google.com,
        osalvador@suse.de, mike.kravetz@oracle.com, mark.rutland@arm.com,
        james.morse@arm.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        catalin.marinas@arm.com, bodeddub@amazon.com, baohua@kernel.org,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch removed from -mm tree
Message-Id: <20220510041104.8C484C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: mm: hugetlb: enable HUGETLB_PAGE_FREE_VMEMMAP for arm64
has been removed from the -mm tree.  Its filename was
     arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: arm64: mm: hugetlb: enable HUGETLB_PAGE_FREE_VMEMMAP for arm64

The feature of minimizing overhead of struct page associated with each
HugeTLB page aims to free its vmemmap pages (used as struct page) to save
memory, where is ~14GB/16GB per 1TB HugeTLB pages (2MB/1GB type).  In
short, when a HugeTLB page is allocated or freed, the vmemmap array
representing the range associated with the page will need to be remapped. 
When a page is allocated, vmemmap pages are freed after remapping.  When a
page is freed, previously discarded vmemmap pages must be allocated before
remapping.  More implementations and details can be found here [1].

The infrastructure of freeing vmemmap pages associated with each HugeTLB
page is already there, we can easily enable HUGETLB_PAGE_FREE_VMEMMAP for
arm64, the only thing to be fixed is flush_dcache_page() .

flush_dcache_page() need to be adapted to operate on the head page's flags
since the tail vmemmap pages are mapped with read-only after the feature
is enabled (clear operation is not permitted).

There was some discussions about this in the thread [2], but there was no
conclusion in the end.  And I copied the concern proposed by Anshuman to
here and explain why those concern is superfluous.  It is safe to enable
it for x86_64 as well as arm64.

1st concern:
'''
But what happens when a hot remove section's vmemmap area (which is
being teared down) is nearby another vmemmap area which is either created
or being destroyed for HugeTLB alloc/free purpose. As you mentioned
HugeTLB pages inside the hot remove section might be safe. But what about
other HugeTLB areas whose vmemmap area shares page table entries with
vmemmap entries for a section being hot removed ? Massive HugeTLB alloc
/use/free test cycle using memory just adjacent to a memory hotplug area,
which is always added and removed periodically, should be able to expose
this problem.
'''

Answer: At the time memory is removed, all HugeTLB pages either have been
migrated away or dissolved.  So there is no race between memory hot remove
and free_huge_page_vmemmap().  Therefore, HugeTLB pages inside the hot
remove section is safe.  Let's talk your question "what about other
HugeTLB areas whose vmemmap area shares page table entries with vmemmap
entries for a section being hot removed ?", the question is not
established.  The minimal granularity size of hotplug memory 128MB (on
arm64, 4k base page), any HugeTLB smaller than 128MB is within a section,
then, there is no share PTE page tables between HugeTLB in this section
and ones in other sections and a HugeTLB page could not cross two
sections.  In this case, the section cannot be freed.  Any HugeTLB bigger
than 128MB (section size) whose vmemmap pages is an integer multiple of
2MB (PMD-mapped).  As long as:

  1) HugeTLBs are naturally aligned, power-of-two sizes
  2) The HugeTLB size >= the section size
  3) The HugeTLB size >= the vmemmap leaf mapping size

Then a HugeTLB will not share any leaf page table entries with *anything
else*, but will share intermediate entries.  In this case, at the time
memory is removed, all HugeTLB pages either have been migrated away or
dissolved.  So there is also no race between memory hot remove and
free_huge_page_vmemmap().

2nd concern:
'''
differently, not sure if ptdump would require any synchronization.

Dumping an wrong value is probably okay but crashing because a page table
entry is being freed after ptdump acquired the pointer is bad. On arm64,
ptdump() is protected against hotremove via [get|put]_online_mems().
'''

Answer: The ptdump should be fine since vmemmap_remap_free() only
exchanges PTEs or splits the PMD entry (which means allocating a PTE page
table).  Both operations do not free any page tables (PTE), so ptdump
cannot run into a UAF on any page tables.  The worst case is just dumping
an wrong value.

[1] https://lore.kernel.org/all/20210510030027.56044-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/all/20210518091826.36937-1-songmuchun@bytedance.com/

[songmuchun@bytedance.com: restructure the code comment inside flush_dcache_page()]
  Link: https://lkml.kernel.org/r/20220414072646.21910-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20220331065640.5777-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Barry Song <baohua@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig    |    1 +
 arch/arm64/mm/flush.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/arch/arm64/Kconfig~arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64
+++ a/arch/arm64/Kconfig
@@ -96,6 +96,7 @@ config ARM64
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
+	select ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
--- a/arch/arm64/mm/flush.c~arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64
+++ a/arch/arm64/mm/flush.c
@@ -75,6 +75,20 @@ EXPORT_SYMBOL_GPL(__sync_icache_dcache);
  */
 void flush_dcache_page(struct page *page)
 {
+	/*
+	 * Only the head page's flags of HugeTLB can be cleared since the tail
+	 * vmemmap pages associated with each HugeTLB page are mapped with
+	 * read-only when CONFIG_HUGETLB_PAGE_FREE_VMEMMAP is enabled (more
+	 * details can refer to vmemmap_remap_pte()).  Although
+	 * __sync_icache_dcache() only set PG_dcache_clean flag on the head
+	 * page struct, there is more than one page struct with PG_dcache_clean
+	 * associated with the HugeTLB page since the head vmemmap page frame
+	 * is reused (more details can refer to the comments above
+	 * page_fixed_fake_head()).
+	 */
+	if (hugetlb_free_vmemmap_enabled() && PageHuge(page))
+		page = compound_head(page);
+
 	if (test_bit(PG_dcache_clean, &page->flags))
 		clear_bit(PG_dcache_clean, &page->flags);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

