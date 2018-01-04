From: akpm@linux-foundation.org
Subject: + hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch added
 to -mm tree
Date: Wed, 03 Jan 2018 16:05:11 -0800
Message-ID: <5a4d6fb7.m5nwCK06mHo87xCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbeADAFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 19:05:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb, mempolicy: fix the mbind hugetlb migration
has been added to the -mm tree.  Its filename is
     hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

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
Subject: hugetlb, mempolicy: fix the mbind hugetlb migration

do_mbind migration code relies on alloc_huge_page_noerr for hugetlb pages.
alloc_huge_page_noerr uses alloc_huge_page which is a highlevel
allocation function which has to take care of reserves, overcommit or
hugetlb cgroup accounting.  None of that is really required for the page
migration because the new page is only temporal and either will replace
the original page or it will be dropped.  This is essentially as for other
migration call paths and there shouldn't be any reason to handle mbind in
a special way.

The current implementation is even suboptimal because the migration might
fail just because the hugetlb cgroup limit is reached, or the overcommit
is saturated.

Fix this by making mbind like other hugetlb migration paths.  Add a new
migration helper alloc_huge_page_vma as a wrapper around
alloc_huge_page_nodemask with additional mempolicy handling.

alloc_huge_page_noerr has no more users and it can go.

Link: http://lkml.kernel.org/r/20180103093213.26329-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++---
 mm/hugetlb.c            |   33 +++++++++++++++++++--------------
 mm/mempolicy.c          |    3 +--
 3 files changed, 22 insertions(+), 19 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration
+++ a/include/linux/hugetlb.h
@@ -356,10 +356,9 @@ struct huge_bootmem_page {
 struct page *alloc_huge_page(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
-struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
-				unsigned long addr, int avoid_reserve);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask);
+struct page *alloc_huge_page_vma(struct vm_area_struct *vma, unsigned long address);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -537,7 +536,7 @@ struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_huge_page_nodemask(h, preferred_nid, nmask) NULL
-#define alloc_huge_page_noerr(v, a, r) NULL
+#define alloc_huge_page_vma(vma, address) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_sizelog(s) NULL
diff -puN mm/hugetlb.c~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration
+++ a/mm/hugetlb.c
@@ -1674,6 +1674,25 @@ struct page *alloc_huge_page_nodemask(st
 	return alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
+/* mempolicy aware migration callback */
+struct page *alloc_huge_page_vma(struct vm_area_struct *vma, unsigned long address)
+{
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	struct page *page;
+	struct hstate *h;
+	gfp_t gfp_mask;
+	int node;
+
+	h = hstate_vma(vma);
+	gfp_mask = htlb_alloc_mask(h);
+	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	page = alloc_huge_page_nodemask(h, node, nodemask);
+	mpol_cond_put(mpol);
+
+	return page;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2079,20 +2098,6 @@ out_subpool_put:
 	return ERR_PTR(-ENOSPC);
 }
 
-/*
- * alloc_huge_page()'s wrapper which simply returns the page if allocation
- * succeeds, otherwise NULL. This function is called from new_vma_page(),
- * where no ERR_VALUE is expected to be returned.
- */
-struct page *alloc_huge_page_noerr(struct vm_area_struct *vma,
-				unsigned long addr, int avoid_reserve)
-{
-	struct page *page = alloc_huge_page(vma, addr, avoid_reserve);
-	if (IS_ERR(page))
-		page = NULL;
-	return page;
-}
-
 int alloc_bootmem_huge_page(struct hstate *h)
 	__attribute__ ((weak, alias("__alloc_bootmem_huge_page")));
 int __alloc_bootmem_huge_page(struct hstate *h)
diff -puN mm/mempolicy.c~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration mm/mempolicy.c
--- a/mm/mempolicy.c~hugetlb-mempolicy-fix-the-mbind-hugetlb-migration
+++ a/mm/mempolicy.c
@@ -1097,8 +1097,7 @@ static struct page *new_page(struct page
 	}
 
 	if (PageHuge(page)) {
-		BUG_ON(!vma);
-		return alloc_huge_page_noerr(vma, address, 1);
+		return alloc_huge_page_vma(vma, address);
 	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

