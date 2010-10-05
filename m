From: akpm@linux-foundation.org
Subject: + mm-retry-page-fault-when-blocking-on-disk-transfer.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:15:25 -0700
Message-ID: <201010052015.o95KFP1G017428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718Ab0JEUWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:22:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au, riel@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yinghan@google.com


The patch titled
     mm: retry page fault when blocking on disk transfer
has been added to the -mm tree.  Its filename is
     mm-retry-page-fault-when-blocking-on-disk-transfer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: retry page fault when blocking on disk transfer
From: Michel Lespinasse <walken@google.com>

This change reduces mmap_sem hold times that are caused by waiting for
disk transfers when accessing file mapped VMAs.

It introduces the VM_FAULT_ALLOW_RETRY flag, which indicates that the call
site wants mmap_sem to be released if blocking on a pending disk transfer.
 In that case, filemap_fault() returns the VM_FAULT_RETRY status bit and
do_page_fault() will then re-acquire mmap_sem and retry the page fault.

It is expected that the retry will hit the same page which will now be
cached, and thus it will complete with a low mmap_sem hold time.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   38 ++++++++++++++++++++++++++------------
 include/linux/mm.h  |    2 ++
 mm/filemap.c        |   23 ++++++++++++++++++++++-
 mm/memory.c         |    3 ++-
 4 files changed, 52 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/fault.c~mm-retry-page-fault-when-blocking-on-disk-transfer arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~mm-retry-page-fault-when-blocking-on-disk-transfer
+++ a/arch/x86/mm/fault.c
@@ -936,8 +936,10 @@ do_page_fault(struct pt_regs *regs, unsi
 	struct task_struct *tsk;
 	unsigned long address;
 	struct mm_struct *mm;
-	int write;
 	int fault;
+	int write = error_code & PF_WRITE;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY |
+					(write ? FAULT_FLAG_WRITE : 0);
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1048,6 +1050,7 @@ do_page_fault(struct pt_regs *regs, unsi
 			bad_area_nosemaphore(regs, error_code, address);
 			return;
 		}
+retry:
 		down_read(&mm->mmap_sem);
 	} else {
 		/*
@@ -1091,8 +1094,6 @@ do_page_fault(struct pt_regs *regs, unsi
 	 * we can handle it..
 	 */
 good_area:
-	write = error_code & PF_WRITE;
-
 	if (unlikely(access_error(error_code, write, vma))) {
 		bad_area_access_error(regs, error_code, address);
 		return;
@@ -1103,21 +1104,34 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault:
 	 */
-	fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address, flags);
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		mm_fault_error(regs, error_code, address, fault);
 		return;
 	}
 
-	if (fault & VM_FAULT_MAJOR) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
-				     regs, address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
-				     regs, address);
+	/*
+	 * Major/minor page fault accounting is only done on the
+	 * initial attempt. If we go through a retry, it is extremely
+	 * likely that the page will be found in page cache at that point.
+	 */
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR) {
+			tsk->maj_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+				      regs, address);
+		} else {
+			tsk->min_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+				      regs, address);
+		}
+		if (fault & VM_FAULT_RETRY) {
+			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
+			 * of starvation. */
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			goto retry;
+		}
 	}
 
 	check_v8086_mode(regs, address, tsk);
diff -puN include/linux/mm.h~mm-retry-page-fault-when-blocking-on-disk-transfer include/linux/mm.h
--- a/include/linux/mm.h~mm-retry-page-fault-when-blocking-on-disk-transfer
+++ a/include/linux/mm.h
@@ -144,6 +144,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 #define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
+#define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
@@ -722,6 +723,7 @@ static inline int page_mapped(struct pag
 
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
+#define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_HWPOISON)
 
diff -puN mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer mm/filemap.c
--- a/mm/filemap.c~mm-retry-page-fault-when-blocking-on-disk-transfer
+++ a/mm/filemap.c
@@ -1512,6 +1512,26 @@ static void do_async_mmap_readahead(stru
 					   page, offset, ra->ra_pages);
 }
 
+/*
+ * Lock the page, unless this would block and the caller indicated that it
+ * can handle a retry.
+ */
+static int lock_page_or_retry(struct page *page,
+			      struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	if (trylock_page(page))
+		return 1;
+	if (!(vmf->flags & FAULT_FLAG_ALLOW_RETRY)) {
+		__lock_page(page);
+		return 1;
+	}
+
+	up_read(&vma->vm_mm->mmap_sem);
+	wait_on_page_locked(page);
+	page_cache_release(page);
+	return 0;
+}
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1561,7 +1581,8 @@ retry_find:
 			goto no_cached_page;
 	}
 
-	lock_page(page);
+	if (!lock_page_or_retry(page, vma, vmf))
+		return ret | VM_FAULT_RETRY;
 
 	/* Did it get truncated? */
 	if (unlikely(page->mapping != mapping)) {
diff -puN mm/memory.c~mm-retry-page-fault-when-blocking-on-disk-transfer mm/memory.c
--- a/mm/memory.c~mm-retry-page-fault-when-blocking-on-disk-transfer
+++ a/mm/memory.c
@@ -2926,7 +2926,8 @@ static int __do_fault(struct mm_struct *
 	vmf.page = NULL;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
+			    VM_FAULT_RETRY)))
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
_

Patches currently in -mm which might be from walken@google.com are

mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
x86-access_error-api-cleanup.patch

