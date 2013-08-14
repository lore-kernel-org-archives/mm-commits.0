From: akpm@linux-foundation.org
Subject: + mm-mbind-add-hugepage-migration-code-to-mbind.patch added to
 -mm tree
Date: Wed, 14 Aug 2013 16:41:50 -0700
Message-ID: <520c15be.4ort7kuiehY9AK39%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HNXlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-mbind-add-hugepage-migration-code-to-mbind.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:50 -0700


The patch titled
     Subject: mm: mbind: add hugepage migration code to mbind()
has been added to the -mm tree.  Its filename is
     mm-mbind-add-hugepage-migration-code-to-mbind.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mbind-add-hugepage-migration-code-to-mbind.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mbind-add-hugepage-migration-code-to-mbind.patch

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
Subject: mm: mbind: add hugepage migration code to mbind()

Extend do_mbind() to handle vma with VM_HUGETLB set.  We will be able to
migrate hugepage with mbind(2) after applying the enablement patch which
comes later in this series.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   14 ++++++++++++++
 mm/mempolicy.c          |    4 +++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~mm-mbind-add-hugepage-migration-code-to-mbind include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-mbind-add-hugepage-migration-code-to-mbind
+++ a/include/linux/hugetlb.h
@@ -265,6 +265,8 @@ struct huge_bootmem_page {
 };
 
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
+struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
+				unsigned long addr, int avoid_reserve);
 
 /* arch callback */
 int __init alloc_bootmem_huge_page(struct hstate *h);
@@ -378,6 +380,7 @@ static inline pgoff_t basepage_index(str
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
+#define alloc_huge_page_noerr(v, a, r) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_sizelog(s) NULL
diff -puN mm/hugetlb.c~mm-mbind-add-hugepage-migration-code-to-mbind mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mbind-add-hugepage-migration-code-to-mbind
+++ a/mm/hugetlb.c
@@ -1207,6 +1207,20 @@ static struct page *alloc_huge_page(stru
 	return page;
 }
 
+/*
+ * alloc_huge_page()'s wrapper which simply returns the page if allocation
+ * succeeds, otherwise NULL. This function is called from new_vma_page(),
+ * where no ERR_VALUE is expected to be returned.
+ */
+struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
+				unsigned long addr, int avoid_reserve)
+{
+	struct page *page = alloc_huge_page(vma, addr, avoid_reserve);
+	if (IS_ERR(page))
+		page = NULL;
+	return page;
+}
+
 int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
diff -puN mm/mempolicy.c~mm-mbind-add-hugepage-migration-code-to-mbind mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mbind-add-hugepage-migration-code-to-mbind
+++ a/mm/mempolicy.c
@@ -1190,6 +1190,8 @@ static struct page *new_vma_page(struct
 		vma = vma->vm_next;
 	}
 
+	if (PageHuge(page))
+		return alloc_huge_page_noerr(vma, address, 1);
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
 	 */
@@ -1300,7 +1302,7 @@ static long do_mbind(unsigned long start
 					(unsigned long)vma,
 					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
-				putback_lru_pages(&pagelist);
+				putback_movable_pages(&pagelist);
 		}
 
 		if (nr_failed && (flags & MPOL_MF_STRICT))
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

