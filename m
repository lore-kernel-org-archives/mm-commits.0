From: akpm@linux-foundation.org
Subject: [merged]
 mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:55 -0800
Message-ID: <569e9903.c5Ivk0ikiSaTW6m7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, emunson@akamai.com, heiko.carstens@de.ibm.com, jjherne@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, pbonzini@redhat.com, rientjes@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bring in additional flag for fixup_user_fault to signal unlock
has been removed from the -mm tree.  Its filename was
     mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: mm: bring in additional flag for fixup_user_fault to signal unlock

During Jason's work with postcopy migration support for s390 a problem
regarding gmap faults was discovered.

The gmap code will call fixup_user_fault which will end up always in
handle_mm_fault.  Till now we never cared about retries, but as the
userfaultfd code kind of relies on it.  this needs some fix.

This patchset does not take care of the futex code.  I will now look
closer at this.


This patch (of 2):

With the introduction of userfaultfd, kvm on s390 needs fixup_user_fault
to pass in FAULT_FLAG_ALLOW_RETRY and give feedback if during the faulting
we ever unlocked mmap_sem.

This patch brings in the logic to handle retries as well as it cleans up
the current documentation.  fixup_user_fault was not having the same
semantics as filemap_fault.  It never indicated if a retry happened and so
a caller wasn't able to handle that case.  So we now changed the behaviour
to always retry a locked mmap_sem.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |    8 +++++---
 include/linux/mm.h     |    5 +++--
 kernel/futex.c         |    2 +-
 mm/gup.c               |   30 +++++++++++++++++++++++++-----
 4 files changed, 34 insertions(+), 11 deletions(-)

diff -puN arch/s390/mm/pgtable.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock
+++ a/arch/s390/mm/pgtable.c
@@ -585,7 +585,7 @@ int gmap_fault(struct gmap *gmap, unsign
 		rc = vmaddr;
 		goto out_up;
 	}
-	if (fixup_user_fault(current, gmap->mm, vmaddr, fault_flags)) {
+	if (fixup_user_fault(current, gmap->mm, vmaddr, fault_flags, NULL)) {
 		rc = -EFAULT;
 		goto out_up;
 	}
@@ -727,7 +727,8 @@ int gmap_ipte_notify(struct gmap *gmap,
 			break;
 		}
 		/* Get the page mapped */
-		if (fixup_user_fault(current, gmap->mm, addr, FAULT_FLAG_WRITE)) {
+		if (fixup_user_fault(current, gmap->mm, addr, FAULT_FLAG_WRITE,
+				     NULL)) {
 			rc = -EFAULT;
 			break;
 		}
@@ -802,7 +803,8 @@ retry:
 	if (!(pte_val(*ptep) & _PAGE_INVALID) &&
 	     (pte_val(*ptep) & _PAGE_PROTECT)) {
 		pte_unmap_unlock(ptep, ptl);
-		if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE)) {
+		if (fixup_user_fault(current, mm, addr, FAULT_FLAG_WRITE,
+				     NULL)) {
 			up_read(&mm->mmap_sem);
 			return -EFAULT;
 		}
diff -puN include/linux/mm.h~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock include/linux/mm.h
--- a/include/linux/mm.h~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock
+++ a/include/linux/mm.h
@@ -1194,7 +1194,8 @@ int invalidate_inode_page(struct page *p
 extern int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
 extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
-			    unsigned long address, unsigned int fault_flags);
+			    unsigned long address, unsigned int fault_flags,
+			    bool *unlocked);
 #else
 static inline int handle_mm_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
@@ -1206,7 +1207,7 @@ static inline int handle_mm_fault(struct
 }
 static inline int fixup_user_fault(struct task_struct *tsk,
 		struct mm_struct *mm, unsigned long address,
-		unsigned int fault_flags)
+		unsigned int fault_flags, bool *unlocked)
 {
 	/* should never happen if there's no MMU */
 	BUG();
diff -puN kernel/futex.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock kernel/futex.c
--- a/kernel/futex.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock
+++ a/kernel/futex.c
@@ -604,7 +604,7 @@ static int fault_in_user_writeable(u32 _
 
 	down_read(&mm->mmap_sem);
 	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
-			       FAULT_FLAG_WRITE);
+			       FAULT_FLAG_WRITE, NULL);
 	up_read(&mm->mmap_sem);
 
 	return ret < 0 ? ret : 0;
diff -puN mm/gup.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock mm/gup.c
--- a/mm/gup.c~mm-bring-in-additional-flag-for-fixup_user_fault-to-signal-unlock
+++ a/mm/gup.c
@@ -618,6 +618,8 @@ EXPORT_SYMBOL(__get_user_pages);
  * @mm:		mm_struct of target mm
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
+ * @unlocked:	did we unlock the mmap_sem while retrying, maybe NULL if caller
+ *		does not allow retry
  *
  * This is meant to be called in the specific scenario where for locking reasons
  * we try to access user memory in atomic context (within a pagefault_disable()
@@ -629,22 +631,28 @@ EXPORT_SYMBOL(__get_user_pages);
  * The main difference with get_user_pages() is that this function will
  * unconditionally call handle_mm_fault() which will in turn perform all the
  * necessary SW fixup of the dirty and young bits in the PTE, while
- * handle_mm_fault() only guarantees to update these in the struct page.
+ * get_user_pages() only guarantees to update these in the struct page.
  *
  * This is important for some architectures where those bits also gate the
  * access permission to the page because they are maintained in software.  On
  * such architectures, gup() will not be enough to make a subsequent access
  * succeed.
  *
- * This has the same semantics wrt the @mm->mmap_sem as does filemap_fault().
+ * This function will not return with an unlocked mmap_sem. So it has not the
+ * same semantics wrt the @mm->mmap_sem as does filemap_fault().
  */
 int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long address, unsigned int fault_flags)
+		     unsigned long address, unsigned int fault_flags,
+		     bool *unlocked)
 {
 	struct vm_area_struct *vma;
 	vm_flags_t vm_flags;
-	int ret;
+	int ret, major = 0;
 
+	if (unlocked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+
+retry:
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
@@ -654,6 +662,7 @@ int fixup_user_fault(struct task_struct
 		return -EFAULT;
 
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
 			return -ENOMEM;
@@ -663,8 +672,19 @@ int fixup_user_fault(struct task_struct
 			return -EFAULT;
 		BUG();
 	}
+
+	if (ret & VM_FAULT_RETRY) {
+		down_read(&mm->mmap_sem);
+		if (!(fault_flags & FAULT_FLAG_TRIED)) {
+			*unlocked = true;
+			fault_flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			fault_flags |= FAULT_FLAG_TRIED;
+			goto retry;
+		}
+	}
+
 	if (tsk) {
-		if (ret & VM_FAULT_MAJOR)
+		if (major)
 			tsk->maj_flt++;
 		else
 			tsk->min_flt++;
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are


