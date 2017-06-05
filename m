From: akpm@linux-foundation.org
Subject: [merged]
 mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch removed
 from -mm tree
Date: Mon, 05 Jun 2017 12:02:43 -0700
Message-ID: <20170605190243.6t3LEiHLq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFETCo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 15:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chris-wilson.co.uk, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm: clarify why we want kmalloc before falling backto vmallock
has been removed from the -mm tree.  Its filename was
     mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: clarify why we want kmalloc before falling backto vmallock

While converting drm_[cm]alloc* helpers to kvmalloc* variants Chris Wilson
has wondered why we want to try kmalloc before vmalloc fallback even for
larger allocations requests.  Let's clarify that one larger physically
contiguous block is less likely to fragment memory than many scattered
pages which can prevent more large blocks from being created.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170517080932.21423-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock mm/util.c
--- a/mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock
+++ a/mm/util.c
@@ -357,8 +357,11 @@ void *kvmalloc_node(size_t size, gfp_t f
 	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
 
 	/*
-	 * Make sure that larger requests are not too disruptive - no OOM
-	 * killer and no allocation failure warnings as we have a fallback
+	 * We want to attempt a large physically contiguous block first because
+	 * it is less likely to fragment multiple larger blocks and therefore
+	 * contribute to a long term fragmentation less than vmalloc fallback.
+	 * However make sure that larger requests are not too disruptive - no
+	 * OOM killer and no allocation failure warnings as we have a fallback.
 	 */
 	if (size > PAGE_SIZE) {
 		kmalloc_flags |= __GFP_NOWARN;
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
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
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
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch

