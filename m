From: akpm@linux-foundation.org
Subject: +
 mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch added to -mm tree
Date: Mon, 26 Jun 2017 15:54:58 -0700
Message-ID: <595190c2./RneWxe/jV1WEFLA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdFZWy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 18:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, mgorman@suse.de, neilb@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix
has been added to the -mm tree.  Its filename is
     mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch

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
Subject:  mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix

- GFP_KERNEL - both background and direct reclaim are allowed and the
  _default_ page allocator behavior is used. That means that !costly
  allocation requests are basically nofail but there is no guarantee
  of that behavior so failures have to be checked properly by callers
  (e.g. OOM killer victim is allowed to fail currently).

Link: http://lkml.kernel.org/r/20170626123847.GM11534@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2
+++ a/include/linux/gfp.h
@@ -25,7 +25,7 @@ struct vm_area_struct;
 #define ___GFP_FS		0x80u
 #define ___GFP_COLD		0x100u
 #define ___GFP_NOWARN		0x200u
-#define ___GFP_RETRY_MAYFAIL		0x400u
+#define ___GFP_RETRY_MAYFAIL	0x400u
 #define ___GFP_NOFAIL		0x800u
 #define ___GFP_NORETRY		0x1000u
 #define ___GFP_MEMALLOC		0x2000u
@@ -139,10 +139,11 @@ struct vm_area_struct;
  * The default allocator behavior depends on the request size. We have a concept
  * of so called costly allocations (with order > PAGE_ALLOC_COSTLY_ORDER).
  * !costly allocations are too essential to fail so they are implicitly
- * non-failing (with some exceptions like OOM victims might fail) by default while
- * costly requests try to be not disruptive and back off even without invoking
- * the OOM killer. The following three modifiers might be used to override some of
- * these implicit rules
+ * non-failing by default (with some exceptions like OOM victims might fail so
+ * the caller still has to check for failures) while costly requests try to be
+ * not disruptive and back off even without invoking the OOM killer.
+ * The following three modifiers might be used to override some of these
+ * implicit rules
  *
  * __GFP_NORETRY: The VM implementation will try only very lightweight
  *   memory direct reclaim to get some memory under memory pressure (thus
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
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

