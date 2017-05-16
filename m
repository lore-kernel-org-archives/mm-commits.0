From: akpm@linux-foundation.org
Subject: +
 mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch
 added to -mm tree
Date: Tue, 16 May 2017 13:04:12 -0700
Message-ID: <591b5b3c.TDAl3ZavPbkhSX+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdEPUEN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: enable (soft|hard) offline of HugeTLB pages at PGD level
has been added to the -mm tree.  Its filename is
     mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/madvise: enable (soft|hard) offline of HugeTLB pages at PGD level

Though migrating gigantic HugeTLB pages does not sound much like real
world use case, they can be affected by memory errors.  Hence migration at
the PGD level HugeTLB pages should be supported just to enable soft and
hard offline use cases.

While allocating the new gigantic HugeTLB page, it should not matter
whether new page comes from the same node or not.  There would be very few
gigantic pages on the system afterall, we should not be bothered about
node locality when trying to save a big page from crashing.

This change renames dequeu_huge_page_node() function as dequeue_huge
_page_node_exact() preserving it's original functionality.  Now the new
dequeue_huge_page_node() function scans through all available online nodes
to allocate a huge page for the NUMA_NO_NODE case and just falls back
calling dequeu_huge_page_node_exact() for all other cases.

Link: http://lkml.kernel.org/r/20170516100509.20122-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++++-
 mm/hugetlb.c            |   18 +++++++++++++++++-
 mm/memory-failure.c     |   13 +++++++++----
 3 files changed, 32 insertions(+), 6 deletions(-)

diff -puN include/linux/hugetlb.h~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level
+++ a/include/linux/hugetlb.h
@@ -466,7 +466,11 @@ extern int dissolve_free_huge_pages(unsi
 static inline bool hugepage_migration_supported(struct hstate *h)
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
-	return huge_page_shift(h) == PMD_SHIFT;
+	if ((huge_page_shift(h) == PMD_SHIFT) ||
+		(huge_page_shift(h) == PGDIR_SHIFT))
+		return true;
+	else
+		return false;
 #else
 	return false;
 #endif
@@ -518,6 +522,7 @@ struct hstate {};
 #define vma_mmu_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
+#define hstate_is_gigantic(h) 0
 static inline unsigned int pages_per_huge_page(struct hstate *h)
 {
 	return 1;
diff -puN mm/hugetlb.c~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level mm/hugetlb.c
--- a/mm/hugetlb.c~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level
+++ a/mm/hugetlb.c
@@ -867,7 +867,7 @@ static void enqueue_huge_page(struct hst
 	h->free_huge_pages_node[nid]++;
 }
 
-static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
+static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 {
 	struct page *page;
 
@@ -887,6 +887,22 @@ static struct page *dequeue_huge_page_no
 	return page;
 }
 
+static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
+{
+	struct page *page;
+	int node;
+
+	if (nid != NUMA_NO_NODE)
+		return dequeue_huge_page_node_exact(h, nid);
+
+	for_each_online_node(node) {
+		page = dequeue_huge_page_node_exact(h, node);
+		if (page)
+			return page;
+	}
+	return NULL;
+}
+
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
diff -puN mm/memory-failure.c~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level mm/memory-failure.c
--- a/mm/memory-failure.c~mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level
+++ a/mm/memory-failure.c
@@ -1489,11 +1489,16 @@ EXPORT_SYMBOL(unpoison_memory);
 static struct page *new_page(struct page *p, unsigned long private, int **x)
 {
 	int nid = page_to_nid(p);
-	if (PageHuge(p))
-		return alloc_huge_page_node(page_hstate(compound_head(p)),
-						   nid);
-	else
+	if (PageHuge(p)) {
+		struct hstate *hstate = page_hstate(compound_head(p));
+
+		if (hstate_is_gigantic(hstate))
+			return alloc_huge_page_node(hstate, NUMA_NO_NODE);
+
+		return alloc_huge_page_node(hstate, nid);
+	} else {
 		return __alloc_pages_node(nid, GFP_HIGHUSER_MOVABLE, 0);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-vmstat-standardize-file-operations-variable-names.patch
mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch

