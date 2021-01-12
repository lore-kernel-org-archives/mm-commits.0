Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA46C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 00:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FC322D5B
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 00:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbhALA6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbhALA6A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 19:58:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BC6C2253A;
        Tue, 12 Jan 2021 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610413039;
        bh=69ZmsixoqD19yecwCHDneBX7vsdi+dpN70+gaVN0LL8=;
        h=Date:From:To:Subject:From;
        b=GVTRhYOXmEurZ6dmnvil/NynsoTVmLNuchmMhKIFsnAkpqfftkdDOBK3N8L5qObX0
         blmPTNuflycAM2uY8grvbwZVquCMZzCbYTC6nStwmGqyvuEMEnpQEuqnztgV8Hnq/x
         668UfYMKquNGXW9RhceAdVp5EQe03Px60BM0lF2Q=
Date:   Mon, 11 Jan 2021 16:57:18 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, bp@alien8.de, cai@lca.pw, david@redhat.com,
        hpa@zytor.com, mgorman@suse.de, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  + x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch
 added to -mm tree
Message-ID: <20210112005718.LI3FP9Dkv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/setup: don't remove E820_TYPE_RAM for pfn 0
has been added to the -mm tree.  Its filename is
     x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: x86/setup: don't remove E820_TYPE_RAM for pfn 0

Patch series "mm: fix initialization of struct page for holes in  memory layout", v3.

Commit 73a6e474cb37 ("mm: memmap_init: iterate over
memblock regions rather that check each PFN") exposed several issues with
the memory map initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported back
in April [1]. It seemed back then that the problem was fixed, but a few
weeks ago Andrea Arcangeli hit the same bug [2] and there was an additional
discussion at [3].

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org


This patch (of 2):

The first 4Kb of memory is a BIOS owned area and to avoid its allocation
for the kernel it was not listed in e820 tables as memory.  As the result,
pfn 0 was never recognised by the generic memory management and it is not
a part of neither node 0 nor ZONE_DMA.

If set_pfnblock_flags_mask() would be ever called for the pageblock
corresponding to the first 2Mbytes of memory, having pfn 0 outside of
ZONE_DMA would trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

Along with reserving the first 4Kb in e820 tables, several first pages are
reserved with memblock in several places during setup_arch().  These
reservations are enough to ensure the kernel does not touch the BIOS area
and it is not necessary to remove E820_TYPE_RAM for pfn 0.

Remove the update of e820 table that changes the type of pfn 0 and move
the comment describing why it was done to trim_low_memory_range() that
reserves the beginning of the memory.

Link: https://lkml.kernel.org/r/20210111194017.22696-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-setup-dont-remove-e820_type_ram-for-pfn-0
+++ a/arch/x86/kernel/setup.c
@@ -661,17 +661,6 @@ static void __init trim_platform_memory_
 static void __init trim_bios_range(void)
 {
 	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 *
-	 * This typically reserves additional memory (64KiB by default)
-	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_RESERVE_LOW.
-	 */
-	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
-
-	/*
 	 * special case: Some BIOSes report the PC BIOS
 	 * area (640Kb -> 1Mb) as RAM even though it is not.
 	 * take them out.
@@ -728,6 +717,15 @@ early_param("reservelow", parse_reservel
 
 static void __init trim_low_memory_range(void)
 {
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
+	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

x86-setup-dont-remove-e820_type_ram-for-pfn-0.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

