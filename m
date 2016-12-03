From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch removed from -mm tree
Date: Fri, 02 Dec 2016 16:37:22 -0800
Message-ID: <584213c2.YI+DRd+NOmttYSUG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33300 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755333AbcLCAhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:37:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add a new function to allocate a new gigantic page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: hugetlb: add a new function to allocate a new gigantic page

There are three ways we can allocate a new gigantic page:

1. When the NUMA is not enabled, use alloc_gigantic_page() to get
   the gigantic page.

2. The NUMA is enabled, but the vma is NULL.
   There is no memory policy we can refer to.
   So create a @nodes_allowed, initialize it with init_nodemask_of_mempolicy()
   or init_nodemask_of_node(). Then use alloc_fresh_gigantic_page() to get
   the gigantic page.

3. The NUMA is enabled, and the vma is valid.
   We can follow the memory policy of the @vma.

   Get @nodes_mask by huge_nodemask(), and use alloc_fresh_gigantic_page()
   to get the gigantic page.

Link: http://lkml.kernel.org/r/1479107259-2011-6-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A . Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Kaly Xin <kaly.xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page
+++ a/mm/hugetlb.c
@@ -1502,6 +1502,73 @@ int dissolve_free_huge_pages(unsigned lo
 
 /*
  * There are 3 ways this can get called:
+ *
+ * 1. When the NUMA is not enabled, use alloc_gigantic_page() to get
+ *    the gigantic page.
+ *
+ * 2. The NUMA is enabled, but the vma is NULL.
+ *    Create a @nodes_allowed, use alloc_fresh_gigantic_page() to get
+ *    the gigantic page.
+ *
+ * 3. The NUMA is enabled, and the vma is valid.
+ *    Use the @vma's memory policy.
+ *    Get @nodes_mask by huge_nodemask(), and use alloc_fresh_gigantic_page()
+ *    to get the gigantic page.
+ */
+static struct page *__hugetlb_alloc_gigantic_page(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long addr, int nid)
+{
+	struct page *page;
+	nodemask_t *nodes_mask;
+
+	/* Not NUMA */
+	if (!IS_ENABLED(CONFIG_NUMA)) {
+		if (nid == NUMA_NO_NODE)
+			nid = numa_mem_id();
+
+		page = alloc_gigantic_page(nid, huge_page_order(h));
+		if (page)
+			prep_compound_gigantic_page(page, huge_page_order(h));
+
+		return page;
+	}
+
+	/* NUMA && !vma */
+	if (!vma) {
+		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
+				GFP_KERNEL | __GFP_NORETRY);
+
+		if (nid == NUMA_NO_NODE) {
+			if (!init_nodemask_of_mempolicy(nodes_allowed)) {
+				NODEMASK_FREE(nodes_allowed);
+				nodes_allowed = &node_states[N_MEMORY];
+			}
+		} else if (nodes_allowed) {
+			init_nodemask_of_node(nodes_allowed, nid);
+		} else {
+			nodes_allowed = &node_states[N_MEMORY];
+		}
+
+		page = alloc_fresh_gigantic_page(h, nodes_allowed, true);
+
+		if (nodes_allowed != &node_states[N_MEMORY])
+			NODEMASK_FREE(nodes_allowed);
+
+		return page;
+	}
+
+	/* NUMA && vma */
+	nodes_mask = huge_nodemask(vma, addr);
+	if (nodes_mask) {
+		page = alloc_fresh_gigantic_page(h, nodes_mask, true);
+		if (page)
+			return page;
+	}
+	return NULL;
+}
+
+/*
+ * There are 3 ways this can get called:
  * 1. With vma+addr: we use the VMA's memory policy
  * 2. With !vma, but nid=NUMA_NO_NODE:  We try to allocate a huge
  *    page from any node, and let the buddy allocator itself figure
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

