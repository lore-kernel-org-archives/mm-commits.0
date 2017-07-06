From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
 removed from -mm tree
Date: Thu, 06 Jul 2017 15:13:03 -0700
Message-ID: <595eb5ef.tkfjW0QQsvinkR0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdGFWNJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fold me "mm: consider zone which is not fully populated to have holes"
has been removed from the -mm tree.  Its filename was
     mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch

This patch was dropped because it was folded into mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fold me "mm: consider zone which is not fully populated to have holes"

- check valid section number in pfn_to_online_page - Vlastimil
- mark sections online after all struct pages are initialized in
  online_pages_range - Vlastimil

Link: http://lkml.kernel.org/r/20170518164210.GD18333@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 ++-
 mm/memory_hotplug.c            |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix
+++ a/include/linux/memory_hotplug.h
@@ -22,8 +22,9 @@ struct resource;
 #define pfn_to_online_page(pfn)				\
 ({							\
 	struct page *___page = NULL;			\
+	unsigned long ___nr = pfn_to_section_nr(pfn);	\
 							\
-	if (online_section_nr(pfn_to_section_nr(pfn)))	\
+	if (___nr < NR_MEM_SECTIONS && online_section_nr(___nr))\
 		___page = pfn_to_page(pfn);		\
 	___page;					\
 })
diff -puN mm/memory_hotplug.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix
+++ a/mm/memory_hotplug.c
@@ -930,8 +930,6 @@ static int online_pages_range(unsigned l
 	unsigned long onlined_pages = *(unsigned long *)arg;
 	struct page *page;
 
-	online_mem_sections(start_pfn, start_pfn + nr_pages);
-
 	if (PageReserved(pfn_to_page(start_pfn)))
 		for (i = 0; i < nr_pages; i++) {
 			page = pfn_to_page(start_pfn + i);
@@ -942,6 +940,9 @@ static int online_pages_range(unsigned l
 			(*online_page_callback)(page);
 			onlined_pages++;
 		}
+
+	online_mem_sections(start_pfn, start_pfn + nr_pages);
+
 	*(unsigned long *)arg = onlined_pages;
 	return 0;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
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
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch

