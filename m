From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:08 -0700
Message-ID: <55ef2318.YBAGJbPrABwFuXHs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbbIHSEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: call handle_userfault() for userfaultfd_missing() faults
has been removed from the -mm tree.  Its filename was
     userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: call handle_userfault() for userfaultfd_missing() faults

This is where the page faults must be modified to call
handle_userfault() if userfaultfd_missing() is true (so if the
vma->vm_flags had VM_UFFD_MISSING set).

handle_userfault() then takes care of blocking the page fault and
delivering it to userland.

The fault flags must also be passed as parameter so the "read|write"
kind of fault can be passed to userland.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   69 ++++++++++++++++++++++++++++++---------------
 mm/memory.c      |   16 ++++++++++
 2 files changed, 63 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults mm/huge_memory.c
--- a/mm/huge_memory.c~userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults
+++ a/mm/huge_memory.c
@@ -23,6 +23,7 @@
 #include <linux/pagemap.h>
 #include <linux/migrate.h>
 #include <linux/hashtable.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -717,7 +718,8 @@ static inline pmd_t mk_huge_pmd(struct p
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long haddr, pmd_t *pmd,
-					struct page *page, gfp_t gfp)
+					struct page *page, gfp_t gfp,
+					unsigned int flags)
 {
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
@@ -725,12 +727,16 @@ static int __do_huge_pmd_anonymous_page(
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_try_charge(page, mm, gfp, &memcg))
-		return VM_FAULT_OOM;
+	if (mem_cgroup_try_charge(page, mm, gfp, &memcg)) {
+		put_page(page);
+		count_vm_event(THP_FAULT_FALLBACK);
+		return VM_FAULT_FALLBACK;
+	}
 
 	pgtable = pte_alloc_one(mm, haddr);
 	if (unlikely(!pgtable)) {
 		mem_cgroup_cancel_charge(page, memcg);
+		put_page(page);
 		return VM_FAULT_OOM;
 	}
 
@@ -750,6 +756,21 @@ static int __do_huge_pmd_anonymous_page(
 		pte_free(mm, pgtable);
 	} else {
 		pmd_t entry;
+
+		/* Deliver the page fault to userland */
+		if (userfaultfd_missing(vma)) {
+			int ret;
+
+			spin_unlock(ptl);
+			mem_cgroup_cancel_charge(page, memcg);
+			put_page(page);
+			pte_free(mm, pgtable);
+			ret = handle_userfault(vma, haddr, flags,
+					       VM_UFFD_MISSING);
+			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
+			return ret;
+		}
+
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr);
@@ -760,6 +781,7 @@ static int __do_huge_pmd_anonymous_page(
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		atomic_long_inc(&mm->nr_ptes);
 		spin_unlock(ptl);
+		count_vm_event(THP_FAULT_ALLOC);
 	}
 
 	return 0;
@@ -771,19 +793,16 @@ static inline gfp_t alloc_hugepage_gfpma
 }
 
 /* Caller must hold page table lock. */
-static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
 	pmd_t entry;
-	if (!pmd_none(*pmd))
-		return false;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	atomic_long_inc(&mm->nr_ptes);
-	return true;
 }
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -806,6 +825,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		pgtable_t pgtable;
 		struct page *zero_page;
 		bool set;
+		int ret;
 		pgtable = pte_alloc_one(mm, haddr);
 		if (unlikely(!pgtable))
 			return VM_FAULT_OOM;
@@ -816,14 +836,28 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_FALLBACK;
 		}
 		ptl = pmd_lock(mm, pmd);
-		set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
-				zero_page);
-		spin_unlock(ptl);
+		ret = 0;
+		set = false;
+		if (pmd_none(*pmd)) {
+			if (userfaultfd_missing(vma)) {
+				spin_unlock(ptl);
+				ret = handle_userfault(vma, haddr, flags,
+						       VM_UFFD_MISSING);
+				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
+			} else {
+				set_huge_zero_page(pgtable, mm, vma,
+						   haddr, pmd,
+						   zero_page);
+				spin_unlock(ptl);
+				set = true;
+			}
+		} else
+			spin_unlock(ptl);
 		if (!set) {
 			pte_free(mm, pgtable);
 			put_huge_zero_page();
 		}
-		return 0;
+		return ret;
 	}
 	gfp = alloc_hugepage_gfpmask(transparent_hugepage_defrag(vma), 0);
 	page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
@@ -831,14 +865,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page, gfp))) {
-		put_page(page);
-		count_vm_event(THP_FAULT_FALLBACK);
-		return VM_FAULT_FALLBACK;
-	}
-
-	count_vm_event(THP_FAULT_ALLOC);
-	return 0;
+	return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page, gfp, flags);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -873,16 +900,14 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		struct page *zero_page;
-		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
 		zero_page = get_huge_zero_page();
-		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_page);
-		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
 	}
diff -puN mm/memory.c~userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults mm/memory.c
--- a/mm/memory.c~userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults
+++ a/mm/memory.c
@@ -61,6 +61,7 @@
 #include <linux/string.h>
 #include <linux/dma-debug.h>
 #include <linux/debugfs.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -2685,6 +2686,12 @@ static int do_anonymous_page(struct mm_s
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
+		/* Deliver the page fault to userland, check inside PT lock */
+		if (userfaultfd_missing(vma)) {
+			pte_unmap_unlock(page_table, ptl);
+			return handle_userfault(vma, address, flags,
+						VM_UFFD_MISSING);
+		}
 		goto setpte;
 	}
 
@@ -2713,6 +2720,15 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 
+	/* Deliver the page fault to userland, check inside PT lock */
+	if (userfaultfd_missing(vma)) {
+		pte_unmap_unlock(page_table, ptl);
+		mem_cgroup_cancel_charge(page, memcg);
+		page_cache_release(page);
+		return handle_userfault(vma, address, flags,
+					VM_UFFD_MISSING);
+	}
+
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 	mem_cgroup_commit_charge(page, memcg, false);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

