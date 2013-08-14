From: akpm@linux-foundation.org
Subject: +
 mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch added to
 -mm tree
Date: Wed, 14 Aug 2013 16:41:57 -0700
Message-ID: <520c15c5.8x7UU9fMfWfVhdiO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3HNXl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:57 -0700


The patch titled
     Subject: mm: prepare to remove /proc/sys/vm/hugepages_treat_as_movable
has been added to the -mm tree.  Its filename is
     mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: prepare to remove /proc/sys/vm/hugepages_treat_as_movable

Now we have extended hugepage migration and it's opened to many users of
page migration, which is a good reason to consider hugepage as movable. 
So we can go to the direction to remove this parameter.  In order to allow
userspace to prepare for the removal, let's leave this sysctl handler as
noop for a while.

Note that hugepage migration is available only for the architectures which
implement hugepage on a pmd basis.  On the other architectures, allocating
hugepages from MOVABLE is not a good idea because it can break memory
hotremove (which expects that all pages of ZONE_MOVABLE are movable.) So
we choose GFP flags in accordance with mobility of hugepage.

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

 Documentation/sysctl/vm.txt |   13 ++-----------
 mm/hugetlb.c                |   26 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable
+++ a/Documentation/sysctl/vm.txt
@@ -200,17 +200,8 @@ fragmentation index is <= extfrag_thresh
 
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
+This parameter is obsolete and planned to be removed. The value has no effect
+on kernel's behavior.
 
 ==============================================================
 
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
+static inline int htlb_alloc_mask(struct hstate *h)
+{
+	if (hugepage_migration_support(h))
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
@@ -2121,11 +2129,7 @@ int hugetlb_treat_movable_handler(struct
 			void __user *buffer,
 			size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
-	if (hugepages_treat_as_movable)
-		htlb_alloc_mask = GFP_HIGHUSER_MOVABLE;
-	else
-		htlb_alloc_mask = GFP_HIGHUSER;
+	WARN_ON_ONCE("This knob is obsolete and has no effect. It is scheduled for removal.\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

