From: akpm@linux-foundation.org
Subject: + mips-do-not-use-__gfp_repeat-for-order-0-request.patch added to -mm tree
Date: Fri, 23 Jun 2017 13:54:23 -0700
Message-ID: <594d7fff.KVkEwHUm0lOhTyRB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755051AbdFWUyZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 16:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, alex.belits@cavium.com, chris@chris-wilson.co.uk, darrick.wong@oracle.com, david.daney@cavium.com, hannes@cmpxchg.org, hch@infradead.org, mgorman@suse.de, neilb@suse.com, ralf@linux-mips.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: do not use __GFP_REPEAT for order-0 request
has been added to the -mm tree.  Its filename is
     mips-do-not-use-__gfp_repeat-for-order-0-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-do-not-use-__gfp_repeat-for-order-0-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-do-not-use-__gfp_repeat-for-order-0-request.patch

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
Subject: MIPS: do not use __GFP_REPEAT for order-0 request

Patch series "mm: give __GFP_REPEAT a better semantic".

The main motivation for the change is that the current implementation of
__GFP_REPEAT is not very much useful.  

The documentation says:
 * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
 *   _might_ fail.  This depends upon the particular VM implementation.

It just fails to mention that this is true only for large (costly) high
order which has been the case since the flag was introduced.  A similar
semantic would be really helpful for smal orders as well, though, because
we have places where a failure with a specific fallback error handling is
preferred to a potential endless loop inside the page allocator.

The earlier cleanup dropped __GFP_REPEAT usage for low (!costly) order
users so only those which might use larger orders have stayed.  One new
user added in the meantime is addressed in patch 1.

Let's rename the flag to something more verbose and use it for existing
users.  Semantic for those will not change.  Then implement low (!costly)
orders failure path which is hit after the page allocator is about to
invoke the oom killer.  With that we have a good counterpart for
__GFP_NORETRY and finally can tell try as hard as possible without the OOM
killer.

Xfs code already has an existing annotation for allocations which are
allowed to fail and we can trivially map them to the new gfp flag because
it will provide the semantic KM_MAYFAIL wants.  Christoph didn't consider
the new flag really necessary but didn't respond to the OOM killer aspect
of the change so I have kept the patch.  If this is still seen as not
really needed I can drop the patch.

kvmalloc will allow also !costly high order allocations to retry hard
before falling back to the vmalloc.

drm/i915 asked for the new semantic explicitly.

Memory migration code, especially for the memory hotplug, should back off
rather than invoking the OOM killer as well.


This patch (of 6):

3377e227af44 ("MIPS: Add 48-bit VA space (and 4-level page tables) for 4K
pages.") has added a new __GFP_REPEAT user but using this flag doesn't
really make any sense for order-0 request which is the case here because
PUD_ORDER is 0.  __GFP_REPEAT has historically effect only on allocation
requests with order > PAGE_ALLOC_COSTLY_ORDER.

This doesn't introduce any functional change.  This is a preparatory patch
for later work which renames the flag and redefines its semantic.

Link: http://lkml.kernel.org/r/20170623085345.11304-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Alex Belits <alex.belits@cavium.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/pgalloc.h~mips-do-not-use-__gfp_repeat-for-order-0-request arch/mips/include/asm/pgalloc.h
--- a/arch/mips/include/asm/pgalloc.h~mips-do-not-use-__gfp_repeat-for-order-0-request
+++ a/arch/mips/include/asm/pgalloc.h
@@ -116,7 +116,7 @@ static inline pud_t *pud_alloc_one(struc
 {
 	pud_t *pud;
 
-	pud = (pud_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, PUD_ORDER);
+	pud = (pud_t *) __get_free_pages(GFP_KERNEL, PUD_ORDER);
 	if (pud)
 		pud_init((unsigned long)pud, (unsigned long)invalid_pmd_table);
 	return pud;
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

