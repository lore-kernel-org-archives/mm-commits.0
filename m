From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:46:11 -0700
Message-ID: <55f08c83.k2r9MKUBD00oYFLK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbbIITqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: expose hugetlb fault mutex for use by fallocate
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: expose hugetlb fault mutex for use by fallocate

hugetlb page faults are currently synchronized by the table of mutexes
(htlb_fault_mutex_table).  fallocate code will need to synchronize with
the page fault code when it allocates or deletes pages.  Expose interfaces
so that fallocate operations can be synchronized with page faults.  Minor
name changes to be more consistent with other global hugetlb symbols.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |   20 ++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate
+++ a/include/linux/hugetlb.h
@@ -88,6 +88,11 @@ int dequeue_hwpoisoned_huge_page(struct
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 void free_huge_page(struct page *page);
+extern struct mutex *hugetlb_fault_mutex_table;
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
+				struct vm_area_struct *vma,
+				struct address_space *mapping,
+				pgoff_t idx, unsigned long address);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
diff -puN mm/hugetlb.c~mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate
+++ a/mm/hugetlb.c
@@ -64,7 +64,7 @@ DEFINE_SPINLOCK(hugetlb_lock);
  * prevent spurious OOMs when the hugepage pool is fully utilized.
  */
 static int num_fault_mutexes;
-static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
+struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
@@ -2482,7 +2482,7 @@ static void __exit hugetlb_exit(void)
 	}
 
 	kobject_put(hugepages_kobj);
-	kfree(htlb_fault_mutex_table);
+	kfree(hugetlb_fault_mutex_table);
 }
 module_exit(hugetlb_exit);
 
@@ -2515,12 +2515,12 @@ static int __init hugetlb_init(void)
 #else
 	num_fault_mutexes = 1;
 #endif
-	htlb_fault_mutex_table =
+	hugetlb_fault_mutex_table =
 		kmalloc(sizeof(struct mutex) * num_fault_mutexes, GFP_KERNEL);
-	BUG_ON(!htlb_fault_mutex_table);
+	BUG_ON(!hugetlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
-		mutex_init(&htlb_fault_mutex_table[i]);
+		mutex_init(&hugetlb_fault_mutex_table[i]);
 	return 0;
 }
 module_init(hugetlb_init);
@@ -3454,7 +3454,7 @@ backout_unlocked:
 }
 
 #ifdef CONFIG_SMP
-static u32 fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
 			    struct vm_area_struct *vma,
 			    struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
@@ -3479,7 +3479,7 @@ static u32 fault_mutex_hash(struct hstat
  * For uniprocesor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
-static u32 fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
 			    struct vm_area_struct *vma,
 			    struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
@@ -3527,8 +3527,8 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = fault_mutex_hash(h, mm, vma, mapping, idx, address);
-	mutex_lock(&htlb_fault_mutex_table[hash]);
+	hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping, idx, address);
+	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
@@ -3613,7 +3613,7 @@ out_ptl:
 		put_page(pagecache_page);
 	}
 out_mutex:
-	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
 	 * here we just wait to defer the next page fault to avoid busy loop and
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


