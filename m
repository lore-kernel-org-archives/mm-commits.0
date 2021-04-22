Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B03FC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E72561450
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhDVETl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVET1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9780361002;
        Thu, 22 Apr 2021 04:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065103;
        bh=Uv1MNaTHK4ZRBY47wpQJUIpZj8CMUxnkRACoWN53gxM=;
        h=Date:From:To:Subject:From;
        b=Qpaw39/JpqanZw730E0/MA9lIj1wb64vpkx+r1GN/Voic5zQNyA6Lb50OiCkPH19x
         9BAQUHv1VWxQ/qHxAUpZzVXCyB73AFJP6fYw1RNbzrQ4LwQAa5s658G9owODQvryjw
         6+K1+3Yl/0U+E9uAnB/t3ts/LBS6HrML63quwgks=
Date:   Wed, 21 Apr 2021 21:18:23 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [to-be-updated]
 drivers-base-memory-introduce-memory_block_onlineoffline.patch removed from
 -mm tree
Message-ID: <20210422041823.hA-fD-X3E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: introduce memory_block_{online,offline}
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-introduce-memory_block_onlineoffline.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: drivers/base/memory: introduce memory_block_{online,offline}

Patch series "Allocate memmap from hotadded memory (per device)", v9.

The primary goal of this patchset is to reduce memory overhead of the
hot-added memory (at least for SPARSEMEM_VMEMMAP memory model).  The
current way we use to populate memmap (struct page array) has two main
drawbacks:

a) it consumes an additional memory until the hotadded memory itself is
   onlined and

b) memmap might end up on a different numa node which is especially
   true for movable_node configuration.

c) due to fragmentation we might end up populating memmap with base
   pages

One way to mitigate all these issues is to simply allocate memmap array
(which is the largest memory footprint of the physical memory hotplug)
from the hot-added memory itself.  SPARSEMEM_VMEMMAP memory model allows
us to map any pfn range so the memory doesn't need to be online to be
usable for the array.  See patch 4 for more details.  This feature is only
usable when CONFIG_SPARSEMEM_VMEMMAP is set.

[Overall design]:

Implementation wise we reuse vmem_altmap infrastructure to override the
default allocator used by vmemap_populate.  memory_block structure gains a
new field called nr_vmemmap_pages, which accounts for the number of
vmemmap pages used by that memory_block.  E.g: On x86_64, that is 512
vmemmap pages on small memory blocks and 4096 on large memory blocks (1GB)

We also introduce new two functions: memory_block_{online,offline}.  These
functions take care of initializing/unitializing vmemmap pages prior to
calling {online,offline}_pages, so the latter functions can remain totally
untouched.

More details can be found in the respective changelogs.


This patch (of 8):

This is a preparatory patch that introduces two new functions:
memory_block_online() and memory_block_offline().

For now, these functions will only call online_pages() and offline_pages()
respectively, but they will be later in charge of preparing the vmemmap
pages, carrying out the initialization and proper accounting of such
pages.

Since memory_block struct contains all the information, pass this struct
down the chain till the end functions.

Link: https://lkml.kernel.org/r/20210416112411.9826-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20210416112411.9826-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-introduce-memory_block_onlineoffline
+++ a/drivers/base/memory.c
@@ -169,30 +169,41 @@ int memory_notify(unsigned long val, voi
 	return blocking_notifier_call_chain(&memory_chain, val, v);
 }
 
+static int memory_block_online(struct memory_block *mem)
+{
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+
+	return online_pages(start_pfn, nr_pages, mem->online_type, mem->nid);
+}
+
+static int memory_block_offline(struct memory_block *mem)
+{
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+
+	return offline_pages(start_pfn, nr_pages);
+}
+
 /*
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
  */
 static int
-memory_block_action(unsigned long start_section_nr, unsigned long action,
-		    int online_type, int nid)
+memory_block_action(struct memory_block *mem, unsigned long action)
 {
-	unsigned long start_pfn;
-	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	int ret;
 
-	start_pfn = section_nr_to_pfn(start_section_nr);
-
 	switch (action) {
 	case MEM_ONLINE:
-		ret = online_pages(start_pfn, nr_pages, online_type, nid);
+		ret = memory_block_online(mem);
 		break;
 	case MEM_OFFLINE:
-		ret = offline_pages(start_pfn, nr_pages);
+		ret = memory_block_offline(mem);
 		break;
 	default:
 		WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
-		     "%ld\n", __func__, start_section_nr, action, action);
+		     "%ld\n", __func__, mem->start_section_nr, action, action);
 		ret = -EINVAL;
 	}
 
@@ -210,9 +221,7 @@ static int memory_block_change_state(str
 	if (to_state == MEM_OFFLINE)
 		mem->state = MEM_GOING_OFFLINE;
 
-	ret = memory_block_action(mem->start_section_nr, to_state,
-				  mem->online_type, mem->nid);
-
+	ret = memory_block_action(mem, to_state);
 	mem->state = ret ? from_state_req : to_state;
 
 	return ret;
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
mmmemory_hotplug-relax-fully-spanned-sections-check.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

