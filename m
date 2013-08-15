From: akpm@linux-foundation.org
Subject: +
 mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch added
 to -mm tree
Date: Thu, 15 Aug 2013 13:32:15 -0700
Message-ID: <520d3acf.ooBlLjzh39M6Nxj+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262Ab3HOUcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:32:15 -0700


The patch titled
     Subject: mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2
has been added to the -mm tree.  Its filename is
     mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch

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
Subject: mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2

ChangeLog v5:
 - choose GFP flags in accordance with mobility of hugepage
 - keep hugepages_treat_as_movable

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   21 +++++++++++++++++++--
 kernel/sysctl.c             |    2 +-
 mm/hugetlb.c                |   10 +---------
 3 files changed, 21 insertions(+), 12 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2
+++ a/Documentation/sysctl/vm.txt
@@ -200,8 +200,25 @@ fragmentation index is <= extfrag_thresh
 
 hugepages_treat_as_movable
 
-This parameter is obsolete and planned to be removed. The value has no effect
-on kernel's behavior.
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
 
diff -puN kernel/sysctl.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2 kernel/sysctl.c
--- a/kernel/sysctl.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2
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
diff -puN mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2
+++ a/mm/hugetlb.c
@@ -541,7 +541,7 @@ static struct page *dequeue_huge_page_no
 /* Movability of hugepages depends on migration support. */
 static inline int htlb_alloc_mask(struct hstate *h)
 {
-	if (hugepage_migration_support(h))
+	if (hugepages_treat_as_movable || hugepage_migration_support(h))
 		return GFP_HIGHUSER_MOVABLE;
 	else
 		return GFP_HIGHUSER;
@@ -2125,14 +2125,6 @@ int hugetlb_mempolicy_sysctl_handler(str
 }
 #endif /* CONFIG_NUMA */
 
-int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
-			void __user *buffer,
-			size_t *length, loff_t *ppos)
-{
-	WARN_ON_ONCE("This knob is obsolete and has no effect. It is scheduled for removal.\n");
-	return 0;
-}
-
 int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 			void __user *buffer,
 			size_t *length, loff_t *ppos)
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
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch

