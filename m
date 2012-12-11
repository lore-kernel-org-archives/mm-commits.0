From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:50:52 -0800
Message-ID: <20121211235052.CF4DA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59619 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2LKXux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:50:53 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so11582qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:50:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aquini@redhat.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce a common interface for balloon pages mobility fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch

This patch was dropped because it was folded into mm-introduce-a-common-interface-for-balloon-pages-mobility.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: introduce a common interface for balloon pages mobility fix

It's useful to keep memory defragmented so that all high-order page
allocations have a chance to succeed, not simply transparent hugepages. 
Thus, allow balloon compaction for any system with memory compaction
enabled, which is the defconfig.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix mm/Kconfig
--- a/mm/Kconfig~mm-introduce-a-common-interface-for-balloon-pages-mobility-fix
+++ a/mm/Kconfig
@@ -192,7 +192,7 @@ config SPLIT_PTLOCK_CPUS
 config BALLOON_COMPACTION
 	bool "Allow for balloon memory compaction/migration"
 	def_bool y
-	depends on TRANSPARENT_HUGEPAGE && VIRTIO_BALLOON
+	depends on COMPACTION && VIRTIO_BALLOON
 	help
 	  Memory fragmentation introduced by ballooning might reduce
 	  significantly the number of 2MB contiguous memory blocks that can be
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcg-make-mem_cgroup_out_of_memory-static.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-clean-up-__collapse_huge_page_isolate.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-oom-allow-exiting-threads-to-have-access-to-memory-reserves.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
mm-mempolicy-remove-duplicate-code.patch
mm-cleanup-register_node.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch

