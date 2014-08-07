From: akpm@linux-foundation.org
Subject: [merged]
 mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:03:47 -0700
Message-ID: <53e3dba3.9FIvIJDCsa/WWMxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:33044 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbaHGUDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:48 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so837530oif.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()

Use ACCESS_ONCE() in handle_pte_fault() when getting the entry or orig_pte
upon which all subsequent decisions and pte_same() tests will be made.

I have no evidence that its lack is responsible for the mm/filemap.c:202
BUG_ON(page_mapped(page)) in __delete_from_page_cache() found by trinity,
and I am not optimistic that it will fix it.  But I have found no other
explanation, and ACCESS_ONCE() here will surely not hurt.

If gcc does re-access the pte before passing it down, then that would be
disastrous for correct page fault handling, and certainly could explain
the page_mapped() BUGs seen (concurrent fault causing page to be mapped in
a second time on top of itself: mapcount 2 for a single pte).

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault mm/memory.c
--- a/mm/memory.c~mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault
+++ a/mm/memory.c
@@ -3181,7 +3181,7 @@ static int handle_pte_fault(struct mm_st
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
linux-next.patch
mm-allow-drivers-to-prevent-new-writable-mappings.patch
shm-add-sealing-api.patch
shm-add-memfd_create-syscall.patch
selftests-add-memfd_create-sealing-tests.patch
selftests-add-memfd-sealing-page-pinning-tests.patch
shm-wait-for-pins-to-be-released-when-sealing.patch
timer-provide-an-api-for-deferrable-timeout.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

