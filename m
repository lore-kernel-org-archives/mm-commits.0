From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-improve-page-fault-scalability.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:10 -0700
Message-ID: <533f087e.WaBdwYnvf6vN/igO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaDDTbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, davidlohr@hp.com

Subject: [merged] mm-hugetlb-improve-page-fault-scalability.patch removed from -mm tree
To: davidlohr@hp.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:10 -0700


The patch titled
     Subject: mm, hugetlb: improve page-fault scalability
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-improve-page-fault-scalability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm, hugetlb: improve page-fault scalability

The kernel can currently only handle a single hugetlb page fault at a
time.  This is due to a single mutex that serializes the entire path. 
This lock protects from spurious OOM errors under conditions of low
availability of free hugepages.  This problem is specific to hugepages,
because it is normal to want to use every single hugepage in the system -
with normal pages we simply assume there will always be a few spare pages
which can be used temporarily until the race is resolved.

Address this problem by using a table of mutexes, allowing a better chance
of parallelization, where each hugepage is individually serialized.  The
hash key is selected depending on the mapping type.  For shared ones it
consists of the address space and file offset being faulted; while for
private ones the mm and virtual address are used.  The size of the table
is selected based on a compromise of collisions and memory footprint of a
series of database workloads.

Large database workloads that make heavy use of hugepages can be
particularly exposed to this issue, causing start-up times to be painfully
slow.  This patch reduces the startup time of a 10 Gb Oracle DB (with
~5000 faults) from 37.5 secs to 25.7 secs.  Larger workloads will
naturally benefit even more.

NOTE:
The only downside to this patch, detected by Joonsoo Kim, is that a small race
is possible in private mappings: A child process (with its own mm, after cow)
can instantiate a page that is already being handled by the parent in a cow
fault. When low on pages, can trigger spurious OOMs. I have not been able to
think of a efficient way of handling this... but do we really care about such
a tiny window? We already maintain another theoretical race with normal pages.
If not, one possible way to is to maintain the single hash for private mappings
-- any workloads that *really* suffer from this scaling problem should already
use shared mappings.

[akpm@linux-foundation.org: remove stray + characters, go BUG if hugetlb_init() kmalloc fails]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   84 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 71 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability
+++ a/mm/hugetlb.c
@@ -22,6 +22,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/page-isolation.h>
+#include <linux/jhash.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -53,6 +54,13 @@ static unsigned long __initdata default_
  */
 DEFINE_SPINLOCK(hugetlb_lock);
 
+/*
+ * Serializes faults on the same logical page.  This is used to
+ * prevent spurious OOMs when the hugepage pool is fully utilized.
+ */
+static int num_fault_mutexes;
+static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
+
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
 	bool free = (spool->count == 0) && (spool->used_hpages == 0);
@@ -1961,11 +1969,14 @@ static void __exit hugetlb_exit(void)
 	}
 
 	kobject_put(hugepages_kobj);
+	kfree(htlb_fault_mutex_table);
 }
 module_exit(hugetlb_exit);
 
 static int __init hugetlb_init(void)
 {
+	int i;
+
 	/* Some platform decide whether they support huge pages at boot
 	 * time. On these, such as powerpc, HPAGE_SHIFT is set to 0 when
 	 * there is no such support
@@ -1990,6 +2001,17 @@ static int __init hugetlb_init(void)
 	hugetlb_register_all_nodes();
 	hugetlb_cgroup_file_init();
 
+#ifdef CONFIG_SMP
+	num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus());
+#else
+	num_fault_mutexes = 1;
+#endif
+	htlb_fault_mutex_table =
+		kmalloc(sizeof(struct mutex) * num_fault_mutexes, GFP_KERNEL);
+	BUG_ON(!htlb_fault_mutex_table);
+
+	for (i = 0; i < num_fault_mutexes; i++)
+		mutex_init(&htlb_fault_mutex_table[i]);
 	return 0;
 }
 module_init(hugetlb_init);
@@ -2767,15 +2789,14 @@ static bool hugetlbfs_pagecache_present(
 }
 
 static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep, unsigned int flags)
+			   struct address_space *mapping, pgoff_t idx,
+			   unsigned long address, pte_t *ptep, unsigned int flags)
 {
 	struct hstate *h = hstate_vma(vma);
 	int ret = VM_FAULT_SIGBUS;
 	int anon_rmap = 0;
-	pgoff_t idx;
 	unsigned long size;
 	struct page *page;
-	struct address_space *mapping;
 	pte_t new_pte;
 	spinlock_t *ptl;
 
@@ -2790,9 +2811,6 @@ static int hugetlb_no_page(struct mm_str
 		return ret;
 	}
 
-	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
-
 	/*
 	 * Use page lock to guard against racing truncation
 	 * before we get page_table_lock.
@@ -2902,17 +2920,53 @@ backout_unlocked:
 	goto out;
 }
 
+#ifdef CONFIG_SMP
+static u32 fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
+			    struct vm_area_struct *vma,
+			    struct address_space *mapping,
+			    pgoff_t idx, unsigned long address)
+{
+	unsigned long key[2];
+	u32 hash;
+
+	if (vma->vm_flags & VM_SHARED) {
+		key[0] = (unsigned long) mapping;
+		key[1] = idx;
+	} else {
+		key[0] = (unsigned long) mm;
+		key[1] = address >> huge_page_shift(h);
+	}
+
+	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
+
+	return hash & (num_fault_mutexes - 1);
+}
+#else
+/*
+ * For uniprocesor systems we always use a single mutex, so just
+ * return 0 and avoid the hashing overhead.
+ */
+static u32 fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
+			    struct vm_area_struct *vma,
+			    struct address_space *mapping,
+			    pgoff_t idx, unsigned long address)
+{
+	return 0;
+}
+#endif
+
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags)
 {
-	pte_t *ptep;
-	pte_t entry;
+	pte_t *ptep, entry;
 	spinlock_t *ptl;
 	int ret;
+	u32 hash;
+	pgoff_t idx;
 	struct page *page = NULL;
 	struct page *pagecache_page = NULL;
-	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
+	struct address_space *mapping;
 
 	address &= huge_page_mask(h);
 
@@ -2931,15 +2985,20 @@ int hugetlb_fault(struct mm_struct *mm,
 	if (!ptep)
 		return VM_FAULT_OOM;
 
+	mapping = vma->vm_file->f_mapping;
+	idx = vma_hugecache_offset(h, vma, address);
+
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	mutex_lock(&hugetlb_instantiation_mutex);
+	hash = fault_mutex_hash(h, mm, vma, mapping, idx, address);
+	mutex_lock(&htlb_fault_mutex_table[hash]);
+
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, address, ptep, flags);
+		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
 		goto out_mutex;
 	}
 
@@ -3008,8 +3067,7 @@ out_ptl:
 	put_page(page);
 
 out_mutex:
-	mutex_unlock(&hugetlb_instantiation_mutex);
