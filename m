From: akpm@linux-foundation.org
Subject: [merged]
 mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:44:27 -0700
Message-ID: <5232199b.qi/F+1aJhxa7kdDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILTo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:27 -0700


The patch titled
     Subject: mm: prepare to remove /proc/sys/vm/hugepages_treat_as_movable
has been removed from the -mm tree.  Its filename was
     mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: prepare to remove /proc/sys/vm/hugepages_treat_as_movable

Now hugepage migration is enabled, although restricted on pmd-based
hugepages for now (due to lack of testing.) So we should allocate
migratable hugepages from ZONE_MOVABLE if possible.

This patch makes GFP flags in hugepage allocation dependent on migration
support, not only the value of hugepages_treat_as_movable.  It provides no
change on the behavior for architectures which do not support hugepage
migration,

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   30 +++++++++++++++++++-----------
 kernel/sysctl.c             |    2 +-
 mm/hugetlb.c                |   32 ++++++++++++++------------------
 3 files changed, 34 insertions(+), 30 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable
+++ a/Documentation/sysctl/vm.txt
@@ -200,17 +200,25 @@ fragmentation index is <= extfrag_thresh
 
 hugepages_treat_as_movable
 
-This parameter is only useful when kernelcore= is specified at boot time to
-create ZONE_MOVABLE for pages that may be reclaimed or migrated. Huge pages
-are not movable so are not normally allocated from ZONE_MOVABLE. A non-zero
-value written to hugepages_treat_as_movable allows huge pages to be allocated
-from ZONE_MOVABLE.
-
-Once enabled, the ZONE_MOVABLE is treated as an area of memory the huge
-pages pool can easily grow or shrink within. Assuming that applications are
-not running that mlock() a lot of memory, it is likely the huge pages pool
-can grow to the size of ZONE_MOVABLE by repeatedly entering the desired value
-into nr_hugepages and triggering page reclaim.
+This parameter controls whether we can allocate hugepages from ZONE_MOVABLE
+or not. If set to non-zero, hugepages can be allocated from ZONE_MOVABLE.
+ZONE_MOVABLE is created when kernel boot parameter kernelcore= is specified,
+so this parameter has no effect if used without kernelcore=.
+
+Hugepage migration is now available in some situations which depend on the
+architecture and/or the hugepage size. If a hugepage supports migration,
+allocation from ZONE_MOVABLE is always enabled for the hugepage regardless
+of the value of this parameter.
+IOW, this parameter affects only non-migratable hugepages.
+
+Assuming that hugepages are not migratable in your system, one usecase of
+this parameter is that users can make hugepage pool more extensible by
+enabling the allocation from ZONE_MOVABLE. This is because on ZONE_MOVABLE
+page reclaim/migration/compaction work more and you can get contiguous
+memory more likely. Note that using ZONE_MOVABLE for non-migratable
+hugepages can do harm to other features like memory hotremove (because
+memory hotremove expects that memory blocks on ZONE_MOVABLE are always
+removable,) so it's a trade-off responsible for the users.
 
 ==============================================================
 
diff -puN kernel/sysctl.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable kernel/sysctl.c
--- a/kernel/sysctl.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable
+++ a/kernel/sysctl.c
@@ -1225,7 +1225,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &hugepages_treat_as_movable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= hugetlb_treat_movable_handler,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "nr_overcommit_hugepages",
diff -puN mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable mm/hugetlb.c
--- a/mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable
+++ a/mm/hugetlb.c
@@ -34,7 +34,6 @@
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
-static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
@@ -539,6 +538,15 @@ static struct page *dequeue_huge_page_no
 	return page;
 }
 
+/* Movability of hugepages depends on migration support. */
+static inline gfp_t htlb_alloc_mask(struct hstate *h)
+{
+	if (hugepages_treat_as_movable || hugepage_migration_support(h))
+		return GFP_HIGHUSER_MOVABLE;
+	else
+		return GFP_HIGHUSER;
+}
+
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve,
@@ -568,11 +576,11 @@ static struct page *dequeue_huge_page_vm
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
 	zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol, &nodemask);
+					htlb_alloc_mask(h), &mpol, &nodemask);
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
-		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
+		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask(h))) {
 			page = dequeue_huge_page_node(h, zone_to_nid(zone));
 			if (page) {
 				if (avoid_reserve)
@@ -738,7 +746,7 @@ static struct page *alloc_fresh_huge_pag
 		return NULL;
 
 	page = alloc_pages_exact_node(nid,
-		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
+		htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
 		huge_page_order(h));
 	if (page) {
@@ -965,12 +973,12 @@ static struct page *alloc_buddy_huge_pag
 	spin_unlock(&hugetlb_lock);
 
 	if (nid == NUMA_NO_NODE)
-		page = alloc_pages(htlb_alloc_mask|__GFP_COMP|
+		page = alloc_pages(htlb_alloc_mask(h)|__GFP_COMP|
 				   __GFP_REPEAT|__GFP_NOWARN,
 				   huge_page_order(h));
 	else
 		page = alloc_pages_exact_node(nid,
-			htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
+			htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 			__GFP_REPEAT|__GFP_NOWARN, huge_page_order(h));
 
 	if (page && arch_prepare_hugepage(page)) {
@@ -2117,18 +2125,6 @@ int hugetlb_mempolicy_sysctl_handler(str
 }
 #endif /* CONFIG_NUMA */
 
-int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
-			void __user *buffer,
-			size_t *length, loff_t *ppos)
-{
-	proc_dointvec(table, write, buffer, length, ppos);
-	if (hugepages_treat_as_movable)
-		htlb_alloc_mask = GFP_HIGHUSER_MOVABLE;
-	else
-		htlb_alloc_mask = GFP_HIGHUSER;
-	return 0;
-}
