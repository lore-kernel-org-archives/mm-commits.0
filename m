From: akpm@linux-foundation.org
Subject: +
 mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch added to -mm tree
Date: Wed, 05 Jul 2017 16:01:14 -0700
Message-ID: <595d6fba.hE19dNer7CKkFs2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752157AbdGEXBP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 19:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, js1304@gmail.com, mgorman@suse.de, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disallow early_pfn_to_nid on configurations which do not implement it
has been added to the -mm tree.  Its filename is
     mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch

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
Subject: mm: disallow early_pfn_to_nid on configurations which do not implement it

early_pfn_to_nid will return node 0 if both HAVE_ARCH_EARLY_PFN_TO_NID and
HAVE_MEMBLOCK_NODE_MAP are disabled.  It seems we are safe now because all
architectures which support NUMA define one of them (with an exception of
alpha which however has CONFIG_NUMA marked as broken) so this works as
expected.  It can get silently and subtly broken too easily, though.  Make
sure we fail the compilation if NUMA is enabled and there is no proper
implementation for this function.  If that ever happens we know that
either the specific configuration is invalid and the fix should either
disable NUMA or enable one of the above configs.

Link: http://lkml.kernel.org/r/20170704075803.15979-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mmzone.h~mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it
+++ a/include/linux/mmzone.h
@@ -1055,6 +1055,7 @@ static inline struct zoneref *first_zone
 	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 {
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_NUMA));
 	return 0;
 }
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
mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
mm-document-highmem_is_dirtyable-sysctl.patch
mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

