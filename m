Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8E6C43460
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC4161002
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhDVETm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229754AbhDVET1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C860B60698;
        Thu, 22 Apr 2021 04:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065112;
        bh=imuE3f0b8V0ZICwAchZVl7B3OGPW6bOTgMYwzsxDyOg=;
        h=Date:From:To:Subject:From;
        b=Zv7zCcXMLTaM+PZDsvpxUL3adrYUo9HY5tUsUN2GnNTBv3jtr4aeVR+IvYg9iOWYX
         j562S5nYgqxOCE/4Zw8pMB0gDfCmTqyNydBvLUobXHWk5K/r8Jl+hHUoQgVIO5+a6m
         gAkkuKPN8zUCSA9/E2BtN4o4hUuMV8mybb7MGsuU=
Date:   Wed, 21 Apr 2021 21:18:31 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [to-be-updated]
 acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch removed
 from -mm tree
Message-ID: <20210422041831.Ev4UV2POF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi,memhotplug: anable MHP_MEMMAP_ON_MEMORY when supported
has been removed from the -mm tree.  Its filename was
     acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: acpi,memhotplug: anable MHP_MEMMAP_ON_MEMORY when supported

Let the caller check whether it can pass MHP_MEMMAP_ON_MEMORY by checking
 mhp_supports_memmap_on_memory().  MHP_MEMMAP_ON_MEMORY can only be set in
 case ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE is enabled, the architecture
 supports altmap, and the range to be added spans a single memory block.

Link: https://lkml.kernel.org/r/20210416112411.9826-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_memhotplug.c~acpimemhotplug-enable-mhp_memmap_on_memory-when-supported
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -171,6 +171,7 @@ static int acpi_memory_enable_device(str
 	acpi_handle handle = mem_device->device->handle;
 	int result, num_enabled = 0;
 	struct acpi_memory_info *info;
+	mhp_t mhp_flags = MHP_NONE;
 	int node;
 
 	node = acpi_get_node(handle);
@@ -194,8 +195,10 @@ static int acpi_memory_enable_device(str
 		if (node < 0)
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
+		if (mhp_supports_memmap_on_memory(info->length))
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
 		result = __add_memory(node, info->start_addr, info->length,
-				      MHP_NONE);
+				      mhp_flags);
 
 		/*
 		 * If the memory block has been used by the kernel, add_memory()
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
mmhugetlb-split-prep_new_huge_page-functionality.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

