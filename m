From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:24:30 -0700
Message-ID: <20200521032430.kqG_XKL4t%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgEUDYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:24:32 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: convert mmap_sem call sites missed by coccinelle
has been added to the -mm tree.  Its filename is
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: convert mmap_sem call sites missed by coccinelle

Convert the last few remaining mmap_sem rwsem calls to use the new mmap
locking API.  These were missed by coccinelle for some reason (I think
coccinelle does not support some of the preprocessor constructs in these
files ?)

Link: http://lkml.kernel.org/r/20200520052908.204642-6-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/fault.c           |   10 +++++-----
 arch/riscv/mm/pageattr.c       |    4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h |    8 ++++----
 fs/proc/base.c                 |    6 +++---
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/mips/mm/fault.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/mips/mm/fault.c
@@ -97,7 +97,7 @@ static void __kprobes __do_page_fault(st
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -190,7 +190,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 /*
@@ -198,7 +198,7 @@ good_area:
  * Fix it, but check if it's kernel or user first..
  */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
@@ -250,14 +250,14 @@ out_of_memory:
 	 * We ran out of memory, call the OOM killer, and return the userspace
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
--- a/arch/riscv/mm/pageattr.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/riscv/mm/pageattr.c
@@ -117,10 +117,10 @@ static int __set_memory(unsigned long ad
 	if (!numpages)
 		return 0;
 
-	down_read(&init_mm.mmap_sem);
+	mmap_read_lock(&init_mm);
 	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
 				     &masks);
-	up_read(&init_mm.mmap_sem);
+	mmap_read_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/x86/kvm/mmu/paging_tmpl.h
@@ -165,22 +165,22 @@ static int FNAME(cmpxchg_gpte)(struct kv
 		unsigned long pfn;
 		unsigned long paddr;
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
 		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			return -EFAULT;
 		}
 		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 		paddr = pfn << PAGE_SHIFT;
 		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
 		if (!table) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			return -EFAULT;
 		}
 		ret = CMPXCHG(&table[index], orig_pte, new_pte);
 		memunmap(table);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	}
 
 	return (ret != orig_pte);
--- a/fs/proc/base.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/fs/proc/base.c
@@ -2322,7 +2322,7 @@ proc_map_files_readdir(struct file *file
 	if (!mm)
 		goto out_put_task;
 
-	ret = down_read_killable(&mm->mmap_sem);
+	ret = mmap_read_lock_killable(mm);
 	if (ret) {
 		mmput(mm);
 		goto out_put_task;
@@ -2349,7 +2349,7 @@ proc_map_files_readdir(struct file *file
 		p = genradix_ptr_alloc(&fa, nr_files++, GFP_KERNEL);
 		if (!p) {
 			ret = -ENOMEM;
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			mmput(mm);
 			goto out_put_task;
 		}
@@ -2358,7 +2358,7 @@ proc_map_files_readdir(struct file *file
 		p->end = vma->vm_end;
 		p->mode = vma->vm_file->f_mode;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	for (i = 0; i < nr_files; i++) {
_

Patches currently in -mm which might be from walken@google.com are

mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch
mmu-notifier-use-the-new-mmap-locking-api.patch
dma-reservations-use-the-new-mmap-locking-api.patch
mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-nested-write-lock-sites.patch
mmap-locking-api-add-mmap_read_trylock_non_owner.patch
mmap-locking-api-add-mmap_lock_initializer.patch
mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
mmap-locking-api-convert-mmap_sem-api-comments.patch
mmap-locking-api-convert-mmap_sem-comments.patch
