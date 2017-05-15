From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-fix-the-section-mismatch-warning.patch added
 to -mm tree
Date: Mon, 15 May 2017 14:27:18 -0700
Message-ID: <591a1d36.7nxn/e+x3I/IhurV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758976AbdEOV1U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: fix the section mismatch warning
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-the-section-mismatch-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-the-section-mismatch-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-the-section-mismatch-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: fix the section mismatch warning

Tobias has reported following section mismatches introduced by "mm,
memory_hotplug: do not associate hotadded memory to zones until online".

WARNING: mm/built-in.o(.text+0x5a1c2): Section mismatch in reference from the function move_pfn_range_to_zone() to the function .meminit.text:memmap_init_zone()
The function move_pfn_range_to_zone() references
the function __meminit memmap_init_zone().
This is often because move_pfn_range_to_zone lacks a __meminit
annotation or the annotation of memmap_init_zone is wrong.

WARNING: mm/built-in.o(.text+0x5a25b): Section mismatch in reference from the function move_pfn_range_to_zone() to the function .meminit.text:init_currently_empty_zone()
The function move_pfn_range_to_zone() references
the function __meminit init_currently_empty_zone().
This is often because move_pfn_range_to_zone lacks a __meminit
annotation or the annotation of init_currently_empty_zone is wrong.

WARNING: vmlinux.o(.text+0x188aa2): Section mismatch in reference from the function move_pfn_range_to_zone() to the function .meminit.text:memmap_init_zone()
The function move_pfn_range_to_zone() references
the function __meminit memmap_init_zone().
This is often because move_pfn_range_to_zone lacks a __meminit
annotation or the annotation of memmap_init_zone is wrong.

WARNING: vmlinux.o(.text+0x188b3b): Section mismatch in reference from the function move_pfn_range_to_zone() to the function .meminit.text:init_currently_empty_zone()
The function move_pfn_range_to_zone() references
the function __meminit init_currently_empty_zone().
This is often because move_pfn_range_to_zone lacks a __meminit
annotation or the annotation of init_currently_empty_zone is wrong.

Both memmap_init_zone and init_currently_empty_zone are marked __meminit
but move_pfn_range_to_zone is used outside of __meminit sections (e.g.
devm_memremap_pages) so we have to hide it from the checker by __ref
annotation.

Link: http://lkml.kernel.org/r/20170515085827.16474-14-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-fix-the-section-mismatch-warning mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-the-section-mismatch-warning
+++ a/mm/memory_hotplug.c
@@ -1074,7 +1074,7 @@ static void __meminit resize_pgdat_range
 	pgdat->node_spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - pgdat->node_start_pfn;
 }
 
-void move_pfn_range_to_zone(struct zone *zone,
+void __ref move_pfn_range_to_zone(struct zone *zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

