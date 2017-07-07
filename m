From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-page_initialized-check-from-get_nid_for_pfn.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:08:55 -0700
Message-ID: <20170707190855.Sxh91V4Rs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdGGTI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com


The patch titled
     Subject: mm: drop page_initialized check from get_nid_for_pfn
has been removed from the -mm tree.  Its filename was
     mm-drop-page_initialized-check-from-get_nid_for_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop page_initialized check from get_nid_for_pfn

c04fc586c1a4 ("mm: show node to memory section relationship with symlinks
in sysfs") has added means to export memblock<->node association into the
sysfs.  It has also introduced get_nid_for_pfn which is a rather confusing
counterpart of pfn_to_nid which checks also whether the pfn page is
already initialized (page_initialized).  This is done by checking
page::lru != NULL which doesn't make any sense at all.  Nothing in this
path really relies on the lru list being used or initialized.  Just remove
it because this will become a problem with later patches.

Thanks to Reza Arbab for testing which revealed this to be a problem
(http://lkml.kernel.org/r/20170403202337.GA12482@dhcp22.suse.cz)

Link: http://lkml.kernel.org/r/20170515085827.16474-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
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
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/base/node.c~mm-drop-page_initialized-check-from-get_nid_for_pfn drivers/base/node.c
--- a/drivers/base/node.c~mm-drop-page_initialized-check-from-get_nid_for_pfn
+++ a/drivers/base/node.c
@@ -368,21 +368,14 @@ int unregister_cpu_under_node(unsigned i
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-#define page_initialized(page)  (page->lru.next)
-
 static int __ref get_nid_for_pfn(unsigned long pfn)
 {
-	struct page *page;
-
 	if (!pfn_valid_within(pfn))
 		return -1;
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	if (system_state < SYSTEM_RUNNING)
 		return early_pfn_to_nid(pfn);
 #endif
-	page = pfn_to_page(pfn);
-	if (!page_initialized(page))
-		return -1;
 	return pfn_to_nid(pfn);
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

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

