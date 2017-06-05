From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-gfph-fix-___gfp_nolockdep-value.patch removed from -mm tree
Date: Mon, 05 Jun 2017 12:02:38 -0700
Message-ID: <20170605190238.z27446oVu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFETCj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 15:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: igor.stoppa@nokia.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value
has been removed from the -mm tree.  Its filename was
     include-linux-gfph-fix-___gfp_nolockdep-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value

Igor Stoppa has noticed that __GFP_NOLOCKDEP can use a lower bit. At the
time 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
was written we still had __GFP_OTHER_NODE but I have removed it in
41b6167e8f74 ("mm: get rid of __GFP_OTHER_NODE") and forgot to lower the
bit value. The current value is outside of __GFP_BITS_SHIFT so it cannot
be used actually.

Fixes: 7e7844226f10 ("lockdep: allow to disable reclaim lockup detection")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Igor Stoppa <igor.stoppa@nokia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-fix-___gfp_nolockdep-value
+++ a/include/linux/gfp.h
@@ -41,7 +41,7 @@ struct vm_area_struct;
 #define ___GFP_WRITE		0x800000u
 #define ___GFP_KSWAPD_RECLAIM	0x1000000u
 #ifdef CONFIG_LOCKDEP
-#define ___GFP_NOLOCKDEP	0x4000000u
+#define ___GFP_NOLOCKDEP	0x2000000u
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
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

