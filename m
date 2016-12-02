From: akpm@linux-foundation.org
Subject: [failures] proc-mm-export-pte-sizes-directly-in-smaps-v3.patch
 removed from -mm tree
Date: Fri, 02 Dec 2016 15:54:36 -0800
Message-ID: <584209bc.+ZTvURTn3+kvah+5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbcLBXyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:54:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, andy.shevchenko@gmail.com, dan.j.williams@intel.com, hch@lst.de, khandual@linux.vnet.ibm.com, linux@roeck-us.net, sfr@canb.auug.org.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-mm-export-pte-sizes-directly-in-smaps-v3
has been removed from the -mm tree.  Its filename was
     proc-mm-export-pte-sizes-directly-in-smaps-v3.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: proc-mm-export-pte-sizes-directly-in-smaps-v3

Changes from v2:
 * Do not assume (wrongly) that smaps_hugetlb_range() always uses
   PUDs.  (Thanks for pointing this out, Vlastimil).  Also handle
   hstates that are not exactly at PMD/PUD sizes.

Link: http://lkml.kernel.org/r/20161129201703.CE9D5054@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   27 ++++++++++++++++++++++++++-
 mm/hugetlb.c       |   11 +++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-mm-export-pte-sizes-directly-in-smaps-v3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-mm-export-pte-sizes-directly-in-smaps-v3
+++ a/fs/proc/task_mmu.c
@@ -689,6 +689,30 @@ static void show_smap_vma_flags(struct s
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
+/*
+ * Most architectures have a 1:1 mapping of PTEs to hugetlb page
+ * sizes, but there are some outliers like arm64 that use
+ * multiple hardware PTEs to make a hugetlb "page".  Do not
+ * assume that all 'hpage_size's are not exactly at a page table
+ * size boundary.  Instead, accept arbitrary 'hpage_size's and
+ * assume they are made up of the next-smallest size.  We do not
+ * handle PGD-sized hpages and hugetlb_add_hstate() will WARN()
+ * if it sees one.
+ *
+ * Note also that the page walker code only calls us once per
+ * huge 'struct page', *not* once per PTE in the page tables.
+ */
+static void smaps_hugetlb_present_hpage(struct mem_size_stats *mss,
+					unsigned long hpage_size)
+{
+	if (hpage_size >= PUD_SIZE)
+		mss->rss_pud += hpage_size;
+	else if (hpage_size >= PMD_SIZE)
+		mss->rss_pmd += hpage_size;
+	else
+		mss->rss_pte += hpage_size;
+}
+
 static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 				 unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
@@ -709,7 +733,8 @@ static int smaps_hugetlb_range(pte_t *pt
 		int mapcount = page_mapcount(page);
 		unsigned long hpage_size = huge_page_size(hstate_vma(vma));
 
-		mss->rss_pud += hpage_size;
+		smaps_hugetlb_present_hpage(mss, hpage_size);
+
 		if (mapcount >= 2)
 			mss->shared_hugetlb += hpage_size;
 		else
diff -puN mm/hugetlb.c~proc-mm-export-pte-sizes-directly-in-smaps-v3 mm/hugetlb.c
--- a/mm/hugetlb.c~proc-mm-export-pte-sizes-directly-in-smaps-v3
+++ a/mm/hugetlb.c
@@ -2905,6 +2905,17 @@ void __init hugetlb_add_hstate(unsigned
 					huge_page_size(h)/1024);
 
 	parsed_hstate = h;
+
+	/*
+	 * PGD_SIZE isn't widely made available by architecures,
+	 * so use PUD_SIZE*PTRS_PER_PUD as a substitute.
+	 *
+	 * Check for sizes that might be mapped by a PGD.  There
+	 * are none of these known today, but be on the lookout.
+	 * If this trips, we will need to update the mss->rss_*
+	 * code in fs/proc/task_mmu.c.
+	 */
+	WARN_ON_ONCE((PAGE_SIZE << order) >= PUD_SIZE * PTRS_PER_PUD);
 }
 
 static int __init hugetlb_nrpages_setup(char *s)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


