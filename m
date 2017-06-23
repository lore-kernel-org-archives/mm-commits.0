From: akpm@linux-foundation.org
Subject: + drm-i915-use-__gfp_retry_mayfail.patch added to -mm tree
Date: Fri, 23 Jun 2017 13:54:35 -0700
Message-ID: <594d800b.cQAgnqn9p6FKJqhT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbdFWUyg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 16:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: use __GFP_RETRY_MAYFAIL
has been added to the -mm tree.  Its filename is
     drm-i915-use-__gfp_retry_mayfail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-i915-use-__gfp_retry_mayfail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-use-__gfp_retry_mayfail.patch

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
Subject: drm/i915: use __GFP_RETRY_MAYFAIL

24f8e00a8a2e ("drm/i915: Prefer to report ENOMEM rather than incur the oom
for gfx allocations") has tried to remove disruptive OOM killer because
the userspace should be able to cope with allocation failures.  At the
time only __GFP_NORETRY could achieve that and it turned out that this
would fail the allocations just too easily.  So "drm/i915: Remove
__GFP_NORETRY from our buffer allocator" removed it and hoped for a better
solution.  __GFP_RETRY_MAYFAIL is that solution.  It will keep retrying
the allocation until there is no more progress and we would go OOM. 
Instead we fail the allocation and let the caller to deal with it.

Link: http://lkml.kernel.org/r/20170623085345.11304-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-__gfp_retry_mayfail drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-use-__gfp_retry_mayfail
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2434,8 +2434,9 @@ rebuild_st:
 				 * again with !__GFP_NORETRY. However, we still
 				 * want to fail this allocation rather than
 				 * trigger the out-of-memory killer and for
-				 * this we want the future __GFP_MAYFAIL.
+				 * this we want __GFP_RETRY_MAYFAIL.
 				 */
+				gfp |= __GFP_RETRY_MAYFAIL;
 			}
 		} while (1);
 
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
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

