From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-propagate-the-full-address-in-thp-faults.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:05:00 -0700
Message-ID: <55ef234c.k4h6C2G5/x2H1Jpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: propagate the full address in THP faults
has been removed from the -mm tree.  Its filename was
     userfaultfd-propagate-the-full-address-in-thp-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: propagate the full address in THP faults

The THP faults were not propagating the original fault address.  The
latest version of the API with uffd.arg.pagefault.address is supposed to
propagate the full address through THP faults.

This was not a kernel crashing bug and it wouldn't risk to corrupt user
memory, but it would cause a SIGBUS failure because the wrong page was
being copied.

For various reasons this wasn't easily reproducible in the qemu workload,
but the strestest exposed the problem immediately.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~userfaultfd-propagate-the-full-address-in-thp-faults mm/huge_memory.c
--- a/mm/huge_memory.c~userfaultfd-propagate-the-full-address-in-thp-faults
+++ a/mm/huge_memory.c
@@ -717,13 +717,14 @@ static inline pmd_t mk_huge_pmd(struct p
 
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long haddr, pmd_t *pmd,
+					unsigned long address, pmd_t *pmd,
 					struct page *page, gfp_t gfp,
 					unsigned int flags)
 {
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
 	spinlock_t *ptl;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
@@ -765,7 +766,7 @@ static int __do_huge_pmd_anonymous_page(
 			mem_cgroup_cancel_charge(page, memcg);
 			put_page(page);
 			pte_free(mm, pgtable);
-			ret = handle_userfault(vma, haddr, flags,
+			ret = handle_userfault(vma, address, flags,
 					       VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
@@ -841,7 +842,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (pmd_none(*pmd)) {
 			if (userfaultfd_missing(vma)) {
 				spin_unlock(ptl);
-				ret = handle_userfault(vma, haddr, flags,
+				ret = handle_userfault(vma, address, flags,
 						       VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
@@ -865,7 +866,8 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page, gfp, flags);
+	return __do_huge_pmd_anonymous_page(mm, vma, address, pmd, page, gfp,
+					    flags);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

