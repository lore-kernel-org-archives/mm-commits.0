From: akpm@linux-foundation.org
Subject: [merged] mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:27 -0800
Message-ID: <201101142248.p0EMmHb8005120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab1ANWsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, Valdis.Kletnieks@vt.edu, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org


The patch titled
     mlock: only hold mmap_sem in shared mode when faulting in pages
has been removed from the -mm tree.  Its filename was
     mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: only hold mmap_sem in shared mode when faulting in pages
From: Michel Lespinasse <walken@google.com>

Currently mlock() holds mmap_sem in exclusive mode while the pages get
faulted in.  In the case of a large mlock, this can potentially take a
very long time, during which various commands such as 'ps auxw' will
block.  This makes sysadmins unhappy:

real    14m36.232s
user    0m0.003s
sys     0m0.015s
(output from 'time ps auxw' while a 20GB file was being mlocked without
being previously preloaded into page cache)

I propose that mlock() could release mmap_sem after the VM_LOCKED bits
have been set in all appropriate VMAs.  Then a second pass could be done
to actually mlock the pages, in small batches, releasing mmap_sem when we
block on disk access or when we detect some contention.


This patch:

Before this change, mlock() holds mmap_sem in exclusive mode while the
pages get faulted in.  In the case of a large mlock, this can potentially
take a very long time.  Various things will block while mmap_sem is held,
including 'ps auxw'.  This can make sysadmins angry.

I propose that mlock() could release mmap_sem after the VM_LOCKED bits
have been set in all appropriate VMAs.  Then a second pass could be done
to actually mlock the pages with mmap_sem held for reads only.  We need to
recheck the vma flags after we re-acquire mmap_sem, but this is easy.

In the case where a vma has been munlocked before mlock completes, pages
that were already marked as PageMlocked() are handled by the munlock()
call, and mlock() is careful to not mark new page batches as PageMlocked()
after the munlock() call has cleared the VM_LOCKED vma flags.  So, the end
result will be identical to what'd happen if munlock() had executed after
the mlock() call.

In a later change, I will allow the second pass to release mmap_sem when
blocking on disk accesses or when it is otherwise contended, so that it
won't be held for long periods of time even in shared mode.

Signed-off-by: Michel Lespinasse <walken@google.com>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   81 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 17 deletions(-)

diff -puN mm/mlock.c~mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages mm/mlock.c
--- a/mm/mlock.c~mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages
+++ a/mm/mlock.c
@@ -377,18 +377,10 @@ static int mlock_fixup(struct vm_area_st
 	int ret = 0;
 	int lock = newflags & VM_LOCKED;
 
-	if (newflags == vma->vm_flags ||
-			(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
+	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current))
 		goto out;	/* don't set VM_LOCKED,  don't count */
 
-	if ((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
-			is_vm_hugetlb_page(vma) ||
-			vma == get_gate_vma(current)) {
-		if (lock)
-			make_pages_present(start, end);
-		goto out;	/* don't set VM_LOCKED,  don't count */
-	}
-
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
 			  vma->vm_file, pgoff, vma_policy(vma));
@@ -424,14 +416,10 @@ success:
 	 * set VM_LOCKED, __mlock_vma_pages_range will bring it back.
 	 */
 
-	if (lock) {
+	if (lock)
 		vma->vm_flags = newflags;
-		ret = __mlock_vma_pages_range(vma, start, end);
-		if (ret < 0)
-			ret = __mlock_posix_error_return(ret);
-	} else {
+	else
 		munlock_vma_pages_range(vma, start, end);
-	}
 
 out:
 	*prev = vma;
@@ -444,7 +432,8 @@ static int do_mlock(unsigned long start,
 	struct vm_area_struct * vma, * prev;
 	int error;
 
-	len = PAGE_ALIGN(len);
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len != PAGE_ALIGN(len));
 	end = start + len;
 	if (end < start)
 		return -EINVAL;
@@ -487,6 +476,58 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
+static int do_mlock_pages(unsigned long start, size_t len, int ignore_errors)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long end, nstart, nend;
+	struct vm_area_struct *vma = NULL;
+	int ret = 0;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(len != PAGE_ALIGN(len));
+	end = start + len;
+
+	down_read(&mm->mmap_sem);
+	for (nstart = start; nstart < end; nstart = nend) {
+		/*
+		 * We want to fault in pages for [nstart; end) address range.
+		 * Find first corresponding VMA.
+		 */
+		if (!vma)
+			vma = find_vma(mm, nstart);
+		else
+			vma = vma->vm_next;
+		if (!vma || vma->vm_start >= end)
+			break;
+		/*
+		 * Set [nstart; nend) to intersection of desired address
+		 * range with the first VMA. Also, skip undesirable VMA types.
+		 */
+		nend = min(end, vma->vm_end);
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		/*
+		 * Now fault in a range of pages within the first VMA.
+		 */
+		if (vma->vm_flags & VM_LOCKED) {
+			ret = __mlock_vma_pages_range(vma, nstart, nend);
+			if (ret < 0 && ignore_errors) {
+				ret = 0;
+				continue;	/* continue at next VMA */
+			}
+			if (ret) {
+				ret = __mlock_posix_error_return(ret);
+				break;
+			}
+		} else
+			make_pages_present(nstart, nend);
+	}
+	up_read(&mm->mmap_sem);
+	return ret;	/* 0 or negative error code */
+}
+
 SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 {
 	unsigned long locked;
@@ -512,6 +553,8 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
 		error = do_mlock(start, len, 1);
 	up_write(&current->mm->mmap_sem);
+	if (!error)
+		error = do_mlock_pages(start, len, 0);
 	return error;
 }
 
@@ -576,6 +619,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = do_mlockall(flags);
 	up_write(&current->mm->mmap_sem);
+	if (!ret && (flags & MCL_CURRENT)) {
+		/* Ignore errors */
+		do_mlock_pages(0, TASK_SIZE, 1);
+	}
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from walken@google.com are

origin.patch

