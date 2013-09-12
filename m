From: akpm@linux-foundation.org
Subject: [merged] mm-mbind-add-hugepage-migration-code-to-mbind.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:19 -0700
Message-ID: <52321993.CqfHGEnhOL+DbjXp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-mbind-add-hugepage-migration-code-to-mbind.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:19 -0700


The patch titled
     Subject: mm: mbind: add hugepage migration code to mbind()
has been removed from the -mm tree.  Its filename was
     mm-mbind-add-hugepage-migration-code-to-mbind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1192,6 +1192,8 @@ static struct page *new_vma_page(struct
 		vma = vma->vm_next;
 	}
 
+	if (PageHuge(page))
+		return alloc_huge_page_noerr(vma, address, 1);
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
 	 */
@@ -1302,7 +1304,7 @@ static long do_mbind(unsigned long start
 					(unsigned long)vma,
 					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
-				putback_lru_pages(&pagelist);
+				putback_movable_pages(&pagelist);
 		}
 
 		if (nr_failed && (flags & MPOL_MF_STRICT))
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

