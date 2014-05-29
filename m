From: akpm@linux-foundation.org
Subject: [to-be-updated]
 page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4.patch
 removed from -mm tree
Date: Thu, 29 May 2014 16:12:33 -0700
Message-ID: <5387bee1.xCN2DFqk3d0sGIY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE2XMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 19:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mgorman@suse.de, lizefan@huawei.com, laijs@cn.fujitsu.com, cl@linux.com, mtosatti@redhat.com

Subject: [to-be-updated] page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4.patch removed from -mm tree
To: mtosatti@redhat.com,cl@linux.com,laijs@cn.fujitsu.com,lizefan@huawei.com,mgorman@suse.de,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 16:12:33 -0700


The patch titled
     Subject: mm/page_alloc.c: skip cpuset enforcement for lower zone allocations
has been removed from the -mm tree.  Its filename was
     page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm/page_alloc.c: skip cpuset enforcement for lower zone allocations

Zone specific allocations, such as GFP_DMA32, should not be restricted to
cpusets allowed node list: the zones which such allocations demand might
be contained in particular nodes outside the cpuset node list.

Necessary for the following usecase:

- driver which requires zone specific memory (such as KVM, which
  requires root pagetable at paddr < 4GB).

- user wants to limit allocations of application to nodeX, and nodeX has
  no memory < 4GB.

[akpm@linux-foundation.org: add comments]
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   10 ++++++++++
 mm/page_alloc.c |   10 ++++++++++
 2 files changed, 20 insertions(+)

diff -puN kernel/cpuset.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4 kernel/cpuset.c
--- a/kernel/cpuset.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4
+++ a/kernel/cpuset.c
@@ -2368,6 +2368,7 @@ static struct cpuset *nearest_hardwall_a
  * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
  * in alloc_flags.  That logic and the checks below have the combined
  * affect that:
+ *	gfp_zone(mask) < policy_zone - any node ok
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	TIF_MEMDIE   - any node ok
@@ -2386,6 +2387,15 @@ int __cpuset_node_allowed_softwall(int n
 
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
+#ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
+	if (gfp_zone(gfp_mask) < policy_zone)
+		return 1;
+#endif
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
diff -puN mm/page_alloc.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4 mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4
+++ a/mm/page_alloc.c
@@ -2741,6 +2741,16 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
+#ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
+	if (gfp_zone(gfp_mask) < policy_zone)
+		nodemask = &node_states[N_ONLINE];
+#endif
+
 	/* The preferred zone is used for statistics later */
 	preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
 				nodemask ? : &cpuset_current_mems_allowed,
_

Patches currently in -mm which might be from mtosatti@redhat.com are

origin.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
linux-next.patch

