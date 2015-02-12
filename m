From: akpm@linux-foundation.org
Subject: [merged] mm-gup-kvm-use-get_user_pages_unlocked.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:38:02 -0800
Message-ID: <54dd011a.ejXt+wx56KFyjLM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbbBLTiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, pfeiner@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: kvm use get_user_pages_unlocked
has been removed from the -mm tree.  Its filename was
     mm-gup-kvm-use-get_user_pages_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: gup: kvm use get_user_pages_unlocked

Use the more generic get_user_pages_unlocked which has the additional
benefit of passing FAULT_FLAG_ALLOW_RETRY at the very first page fault
(which allows the first page fault in an unmapped area to be always able
to block indefinitely by being allowed to release the mmap_sem).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Feiner <pfeiner@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kvm_host.h |   11 --------
 virt/kvm/async_pf.c      |    2 -
 virt/kvm/kvm_main.c      |   50 ++-----------------------------------
 3 files changed, 5 insertions(+), 58 deletions(-)

diff -puN include/linux/kvm_host.h~mm-gup-kvm-use-get_user_pages_unlocked include/linux/kvm_host.h
--- a/include/linux/kvm_host.h~mm-gup-kvm-use-get_user_pages_unlocked
+++ a/include/linux/kvm_host.h
@@ -200,17 +200,6 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
-/*
- * Carry out a gup that requires IO. Allow the mm to relinquish the mmap
- * semaphore if the filemap/swap has to wait on a page lock. pagep == NULL
- * controls whether we retry the gup one more time to completion in that case.
- * Typically this is called after a FAULT_FLAG_RETRY_NOWAIT in the main tdp
- * handler.
- */
-int kvm_get_user_page_io(struct task_struct *tsk, struct mm_struct *mm,
-			 unsigned long addr, bool write_fault,
-			 struct page **pagep);
-
 enum {
 	OUTSIDE_GUEST_MODE,
 	IN_GUEST_MODE,
diff -puN virt/kvm/async_pf.c~mm-gup-kvm-use-get_user_pages_unlocked virt/kvm/async_pf.c
--- a/virt/kvm/async_pf.c~mm-gup-kvm-use-get_user_pages_unlocked
+++ a/virt/kvm/async_pf.c
@@ -80,7 +80,7 @@ static void async_pf_execute(struct work
 
 	might_sleep();
 
-	kvm_get_user_page_io(NULL, mm, addr, 1, NULL);
+	get_user_pages_unlocked(NULL, mm, addr, 1, 1, 0, NULL);
 	kvm_async_page_present_sync(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
diff -puN virt/kvm/kvm_main.c~mm-gup-kvm-use-get_user_pages_unlocked virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-gup-kvm-use-get_user_pages_unlocked
+++ a/virt/kvm/kvm_main.c
@@ -1128,43 +1128,6 @@ static int get_user_page_nowait(struct t
 	return __get_user_pages(tsk, mm, start, 1, flags, page, NULL, NULL);
 }
 
-int kvm_get_user_page_io(struct task_struct *tsk, struct mm_struct *mm,
-			 unsigned long addr, bool write_fault,
-			 struct page **pagep)
-{
-	int npages;
-	int locked = 1;
-	int flags = FOLL_TOUCH | FOLL_HWPOISON |
-		    (pagep ? FOLL_GET : 0) |
-		    (write_fault ? FOLL_WRITE : 0);
-
-	/*
-	 * If retrying the fault, we get here *not* having allowed the filemap
-	 * to wait on the page lock. We should now allow waiting on the IO with
-	 * the mmap semaphore released.
-	 */
-	down_read(&mm->mmap_sem);
-	npages = __get_user_pages(tsk, mm, addr, 1, flags, pagep, NULL,
-				  &locked);
-	if (!locked) {
-		VM_BUG_ON(npages);
-
-		if (!pagep)
-			return 0;
-
-		/*
-		 * The previous call has now waited on the IO. Now we can
-		 * retry and complete. Pass TRIED to ensure we do not re
-		 * schedule async IO (see e.g. filemap_fault).
-		 */
-		down_read(&mm->mmap_sem);
-		npages = __get_user_pages(tsk, mm, addr, 1, flags | FOLL_TRIED,
-					  pagep, NULL, NULL);
-	}
-	up_read(&mm->mmap_sem);
-	return npages;
-}
-
 static inline int check_user_page_hwpoison(unsigned long addr)
 {
 	int rc, flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_WRITE;
@@ -1227,15 +1190,10 @@ static int hva_to_pfn_slow(unsigned long
 		npages = get_user_page_nowait(current, current->mm,
 					      addr, write_fault, page);
 		up_read(&current->mm->mmap_sem);
-	} else {
-		/*
-		 * By now we have tried gup_fast, and possibly async_pf, and we
-		 * are certainly not atomic. Time to retry the gup, allowing
-		 * mmap semaphore to be relinquished in the case of IO.
-		 */
-		npages = kvm_get_user_page_io(current, current->mm, addr,
-					      write_fault, page);
-	}
+	} else
+		npages = __get_user_pages_unlocked(current, current->mm, addr, 1,
+						   write_fault, 0, page,
+						   FOLL_TOUCH|FOLL_HWPOISON);
 	if (npages != 1)
 		return npages;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
linux-next.patch

