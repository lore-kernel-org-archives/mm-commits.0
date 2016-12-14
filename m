From: akpm@linux-foundation.org
Subject: [patch 067/114] mm: allow full handling of COW faults in ->fault
 handlers
Date: Wed, 14 Dec 2016 15:07:18 -0800
Message-ID: <5851d0a6.kcjHBiNkbIMB+hEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbcLNXH2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com

From: Jan Kara <jack@suse.cz>
Subject: mm: allow full handling of COW faults in ->fault handlers

Patch series "dax: Clear dirty bits after flushing caches", v5.

Patchset to clear dirty bits from radix tree of DAX inodes when caches for
corresponding pfns have been flushed.  In principle, these patches enable
handlers to easily update PTEs and do other work necessary to finish the
fault without duplicating the functionality present in the generic code. 
I'd like to thank Kirill and Ross for reviews of the series!



This patch (of 20):

To allow full handling of COW faults add memcg field to struct vm_fault
and a return value of ->fault() handler meaning that COW fault is fully
handled and memcg charge must not be canceled.  This will allow us to
remove knowledge about special DAX locking from the generic fault code.

Link: http://lkml.kernel.org/r/1479460644-25076-9-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++-
 mm/memory.c        |   14 +++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-allow-full-handling-of-cow-faults-in-fault-handlers include/linux/mm.h
--- a/include/linux/mm.h~mm-allow-full-handling-of-cow-faults-in-fault-handlers
+++ a/include/linux/mm.h
@@ -301,7 +301,8 @@ struct vm_fault {
 					 * the 'address' */
 	pte_t orig_pte;			/* Value of PTE at the time of fault */
 
-	struct page *cow_page;		/* Handler may choose to COW */
+	struct page *cow_page;		/* Page handler may use for COW fault */
+	struct mem_cgroup *memcg;	/* Cgroup cow_page belongs to */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -1103,6 +1104,7 @@ static inline void clear_page_pfmemalloc
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DAX_LOCKED 0x1000	/* ->fault has locked DAX entry */
+#define VM_FAULT_DONE_COW   0x2000	/* ->fault has fully handled COW */
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
diff -puN mm/memory.c~mm-allow-full-handling-of-cow-faults-in-fault-handlers mm/memory.c
--- a/mm/memory.c~mm-allow-full-handling-of-cow-faults-in-fault-handlers
+++ a/mm/memory.c
@@ -2844,9 +2844,8 @@ static int __do_fault(struct vm_fault *v
 	int ret;
 
 	ret = vma->vm_ops->fault(vma, vmf);
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
-		return ret;
-	if (ret & VM_FAULT_DAX_LOCKED)
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
+			    VM_FAULT_DAX_LOCKED | VM_FAULT_DONE_COW)))
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
@@ -3226,7 +3225,6 @@ static int do_read_fault(struct vm_fault
 static int do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct mem_cgroup *memcg;
 	int ret;
 
 	if (unlikely(anon_vma_prepare(vma)))
@@ -3237,7 +3235,7 @@ static int do_cow_fault(struct vm_fault
 		return VM_FAULT_OOM;
 
 	if (mem_cgroup_try_charge(vmf->cow_page, vma->vm_mm, GFP_KERNEL,
-				&memcg, false)) {
+				&vmf->memcg, false)) {
 		put_page(vmf->cow_page);
 		return VM_FAULT_OOM;
 	}
@@ -3245,12 +3243,14 @@ static int do_cow_fault(struct vm_fault
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
+	if (ret & VM_FAULT_DONE_COW)
+		return ret;
 
 	if (!(ret & VM_FAULT_DAX_LOCKED))
 		copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
 	__SetPageUptodate(vmf->cow_page);
 
-	ret |= alloc_set_pte(vmf, memcg, vmf->cow_page);
+	ret |= alloc_set_pte(vmf, vmf->memcg, vmf->cow_page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	if (!(ret & VM_FAULT_DAX_LOCKED)) {
@@ -3263,7 +3263,7 @@ static int do_cow_fault(struct vm_fault
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	mem_cgroup_cancel_charge(vmf->cow_page, memcg, false);
+	mem_cgroup_cancel_charge(vmf->cow_page, vmf->memcg, false);
 	put_page(vmf->cow_page);
 	return ret;
 }
_
