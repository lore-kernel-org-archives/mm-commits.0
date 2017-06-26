From: akpm@linux-foundation.org
Subject: + mm-document-highmem_is_dirtyable-sysctl.patch added to -mm tree
Date: Mon, 26 Jun 2017 16:01:10 -0700
Message-ID: <59519236.AicQakpYS+bNs7DS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbdFZXBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2017 19:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, alkisg@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document highmem_is_dirtyable sysctl
has been added to the -mm tree.  Its filename is
     mm-document-highmem_is_dirtyable-sysctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-highmem_is_dirtyable-sysctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-highmem_is_dirtyable-sysctl.patch

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
Subject: mm: document highmem_is_dirtyable sysctl

It seems that there are still people using 32b kernels which a lot of
memory and the IO tend to suck a lot for them by default.  Mostly because
writers are throttled too when the lowmem is used.  We have
highmem_is_dirtyable to work around that issue but it seems we never
bothered to document it.  Let's do it now, finally.

Link: http://lkml.kernel.org/r/20170626093200.18958-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Alkis Georgopoulos <alkisg@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-document-highmem_is_dirtyable-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-document-highmem_is_dirtyable-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -240,6 +240,26 @@ fragmentation index is <= extfrag_thresh
 
 ==============================================================
 
+highmem_is_dirtyable
+
+Available only for systems with CONFIG_HIGHMEM enabled (32b systems).
+
+This parameter controls whether the high memory is considered for dirty
+writers throttling.  This is not the case by default which means that
+only the amount of memory directly visible/usable by the kernel can
+be dirtied. As a result, on systems with a large amount of memory and
+lowmem basically depleted writers might be throttled too early and
+streaming writes can get very slow.
+
+Changing the value to non zero would allow more memory to be dirtied
+and thus allow writers to write more data which can be flushed to the
+storage more effectively. Note this also comes with a risk of pre-mature
+OOM killer because some writers (e.g. direct block device writes) can
+only use the low memory and they can fill it up with dirty data without
+any throttling.
+
+==============================================================
+
 hugepages_treat_as_movable
 
 This parameter controls whether we can allocate hugepages from ZONE_MOVABLE
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
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

