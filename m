From: akpm@linux-foundation.org
Subject: [patch 113/119] hugetlb, mbind: fall back to default
 policy if vma is NULL
Date: Wed, 31 Jan 2018 16:21:03 -0800
Message-ID: <20180201002103.s4I9dSauz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: hugetlb, mbind: fall back to default policy if vma is NULL

Dan Carpenter has noticed that mbind migration callback (new_page) can get
a NULL vma pointer and choke on it inside alloc_huge_page_vma which relies
on the VMA to get the hstate.  We used to BUG_ON this case but the BUG_+ON
has been removed recently by "hugetlb, mempolicy: fix the mbind hugetlb
migration".

The proper way to handle this is to get the hstate from the migrated page
and rely on huge_node (resp.  get_vma_policy) do the right thing with null
VMA.  We are currently falling back to the default mempolicy in that case
which is in line what THP path is doing here.

Link: http://lkml.kernel.org/r/20180110104712.GR1732@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++--
 mm/hugetlb.c            |    5 ++---
 mm/mempolicy.c          |    3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null
+++ a/include/linux/hugetlb.h
@@ -358,7 +358,8 @@ struct page *alloc_huge_page(struct vm_a
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask);
-struct page *alloc_huge_page_vma(struct vm_area_struct *vma, unsigned long address);
+struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
+				unsigned long address);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 
@@ -536,7 +537,7 @@ struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_huge_page_nodemask(h, preferred_nid, nmask) NULL
-#define alloc_huge_page_vma(vma, address) NULL
+#define alloc_huge_page_vma(h, vma, address) NULL
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_sizelog(s) NULL
diff -puN mm/hugetlb.c~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null
+++ a/mm/hugetlb.c
@@ -1675,16 +1675,15 @@ struct page *alloc_huge_page_nodemask(st
 }
 
 /* mempolicy aware migration callback */
-struct page *alloc_huge_page_vma(struct vm_area_struct *vma, unsigned long address)
+struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
+		unsigned long address)
 {
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	struct page *page;
-	struct hstate *h;
 	gfp_t gfp_mask;
 	int node;
 
-	h = hstate_vma(vma);
 	gfp_mask = htlb_alloc_mask(h);
 	node = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 	page = alloc_huge_page_nodemask(h, node, nodemask);
diff -puN mm/mempolicy.c~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null mm/mempolicy.c
--- a/mm/mempolicy.c~hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null
+++ a/mm/mempolicy.c
@@ -1121,7 +1121,8 @@ static struct page *new_page(struct page
 	}
 
 	if (PageHuge(page)) {
-		return alloc_huge_page_vma(vma, address);
+		return alloc_huge_page_vma(page_hstate(compound_head(page)),
+				vma, address);
 	} else if (thp_migration_supported() && PageTransHuge(page)) {
 		struct page *thp;
 
_
