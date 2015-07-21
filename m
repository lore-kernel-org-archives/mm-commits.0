From: akpm@linux-foundation.org
Subject: +
 mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch added to -mm tree
Date: Tue, 21 Jul 2015 13:55:47 -0700
Message-ID: <55aeb1d3.R6HvtwbjeYRZHVz8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbGUUzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
has been added to the -mm tree.  Its filename is
     mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4

Changes from V3:
Do extensive search for VM_LOCKED and ensure that VM_LOCKONFAULT is also handled
 where appropriate

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_vm.c |    8 +++++++-
 fs/proc/task_mmu.c       |    2 +-
 include/linux/mm.h       |    1 +
 kernel/events/uprobes.c  |    2 +-
 kernel/fork.c            |    3 ++-
 mm/debug.c               |    1 +
 mm/gup.c                 |    3 ++-
 mm/huge_memory.c         |    3 ++-
 mm/hugetlb.c             |    4 ++--
 mm/internal.h            |    5 +++--
 mm/ksm.c                 |    2 +-
 mm/madvise.c             |    4 ++--
 mm/memory.c              |    5 +++--
 mm/mlock.c               |   30 ++++++++++++++++++------------
 mm/mmap.c                |   24 +++++++++++++++---------
 mm/mremap.c              |    6 +++---
 mm/msync.c               |    2 +-
 mm/rmap.c                |   12 ++++++------
 mm/shmem.c               |    2 +-
 mm/vmscan.c              |    2 +-
 20 files changed, 73 insertions(+), 48 deletions(-)

diff -puN drivers/gpu/drm/drm_vm.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/drivers/gpu/drm/drm_vm.c
@@ -699,9 +699,15 @@ int drm_vma_info(struct seq_file *m, voi
 		   (void *)(unsigned long)virt_to_phys(high_memory));
 
 	list_for_each_entry(pt, &dev->vmalist, head) {
+		char lock_flag = '-';
+
 		vma = pt->vma;
 		if (!vma)
 			continue;
+		if (vma->vm_flags & VM_LOCKED)
+			lock_flag = 'l';
+		else if (vma->vm_flags & VM_LOCKONFAULT)
+			lock_flag = 'f';
 		seq_printf(m,
 			   "\n%5d 0x%pK-0x%pK %c%c%c%c%c%c 0x%08lx000",
 			   pt->pid,
@@ -710,7 +716,7 @@ int drm_vma_info(struct seq_file *m, voi
 			   vma->vm_flags & VM_WRITE ? 'w' : '-',
 			   vma->vm_flags & VM_EXEC ? 'x' : '-',
 			   vma->vm_flags & VM_MAYSHARE ? 's' : 'p',
-			   vma->vm_flags & VM_LOCKED ? 'l' : '-',
+			   lock_flag,
 			   vma->vm_flags & VM_IO ? 'i' : '-',
 			   vma->vm_pgoff);
 
diff -puN fs/proc/task_mmu.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/fs/proc/task_mmu.c
@@ -657,7 +657,7 @@ static int show_smap(struct seq_file *m,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10,
-		   (vma->vm_flags & VM_LOCKED) ?
+		   (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) ?
 			(unsigned long)(mss.pss >> (10 + PSS_SHIFT)) : 0);
 
 	show_smap_vma_flags(m, vma);
diff -puN include/linux/mm.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 include/linux/mm.h
--- a/include/linux/mm.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/include/linux/mm.h
@@ -1868,6 +1868,7 @@ static inline void mm_populate(unsigned
 	/* Ignore errors */
 	(void) __mm_populate(addr, len, 1);
 }
+extern int mm_lock_present(unsigned long addr, unsigned long start);
 #else
 static inline void mm_populate(unsigned long addr, unsigned long len) {}
 #endif
diff -puN kernel/events/uprobes.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/kernel/events/uprobes.c
@@ -201,7 +201,7 @@ static int __replace_page(struct vm_area
 		try_to_free_swap(page);
 	pte_unmap_unlock(ptep, ptl);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 		munlock_vma_page(page);
 	put_page(page);
 
diff -puN kernel/fork.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 kernel/fork.c
--- a/kernel/fork.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/kernel/fork.c
@@ -454,7 +454,8 @@ static int dup_mmap(struct mm_struct *mm
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED|VM_UFFD_MISSING|VM_UFFD_WP);
+		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT |
+				   VM_UFFD_MISSING | VM_UFFD_WP);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
diff -puN mm/debug.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/debug.c
--- a/mm/debug.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/debug.c
@@ -121,6 +121,7 @@ static const struct trace_print_flags vm
 	{VM_GROWSDOWN,			"growsdown"	},
 	{VM_PFNMAP,			"pfnmap"	},
 	{VM_DENYWRITE,			"denywrite"	},
+	{VM_LOCKONFAULT,		"lockonfault"	},
 	{VM_LOCKED,			"locked"	},
 	{VM_IO,				"io"		},
 	{VM_SEQ_READ,			"seqread"	},
diff -puN mm/gup.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/gup.c
--- a/mm/gup.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/gup.c
@@ -92,7 +92,8 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) &&
+	    (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
diff -puN mm/huge_memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/huge_memory.c
@@ -1265,7 +1265,8 @@ struct page *follow_trans_huge_pmd(struc
 					  pmd, _pmd,  1))
 			update_mmu_cache_pmd(vma, addr, pmd);
 	}
-	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) &&
+	    (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
diff -puN mm/hugetlb.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/hugetlb.c
@@ -3764,8 +3764,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
-	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN mm/internal.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/internal.h
--- a/mm/internal.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/internal.h
@@ -246,10 +246,11 @@ void __vma_link_list(struct mm_struct *m
 extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, vm_flags_t to_drop);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
 {
-	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
+	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end,
+				VM_LOCKED | VM_LOCKONFAULT);
 }
 
 /*
diff -puN mm/ksm.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/ksm.c
--- a/mm/ksm.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/ksm.c
@@ -1058,7 +1058,7 @@ static int try_to_merge_one_page(struct
 			err = replace_page(vma, page, kpage, orig_pte);
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
+	if ((vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) && kpage && !err) {
 		munlock_vma_page(page);
 		if (!PageMlocked(kpage)) {
 			unlock_page(page);
diff -puN mm/madvise.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/madvise.c
--- a/mm/madvise.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/madvise.c
@@ -280,7 +280,7 @@ static long madvise_dontneed(struct vm_a
 			     unsigned long start, unsigned long end)
 {
 	*prev = vma;
-	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
+	if (vma->vm_flags & (VM_LOCKED|VM_LOCKONFAULT|VM_HUGETLB|VM_PFNMAP))
 		return -EINVAL;
 
 	zap_page_range(vma, start, end - start, NULL);
@@ -301,7 +301,7 @@ static long madvise_remove(struct vm_are
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
-	if (vma->vm_flags & (VM_LOCKED | VM_HUGETLB))
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT | VM_HUGETLB))
 		return -EINVAL;
 
 	f = vma->vm_file;
diff -puN mm/memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/memory.c
--- a/mm/memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/memory.c
@@ -2166,7 +2166,7 @@ static int wp_page_copy(struct mm_struct
 		 * Don't let another task, with possibly unlocked vma,
 		 * keep the mlocked page.
 		 */
-		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
+		if (page_copied && (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
 			lock_page(old_page);	/* LRU manipulation */
 			munlock_vma_page(old_page);
 			unlock_page(old_page);
@@ -2578,7 +2578,8 @@ static int do_swap_page(struct mm_struct
 	}
 
 	swap_free(entry);
-	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
+	if (vm_swap_full() || (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) ||
+	    PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
 	if (page != swapcache) {
diff -puN mm/mlock.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/mlock.c
@@ -406,23 +406,22 @@ static unsigned long __munlock_pagevec_f
  * @vma - vma containing range to be munlock()ed.
  * @start - start address in @vma of the range
  * @end - end of range in @vma.
+ * @to_drop - the VMA flags we want to drop from the specified range
  *
- *  For mremap(), munmap() and exit().
+ *  For mremap(), munmap(), munlock(), and exit().
  *
- * Called with @vma VM_LOCKED.
- *
- * Returns with VM_LOCKED cleared.  Callers must be prepared to
+ * Returns with specified flags cleared.  Callers must be prepared to
  * deal with this.
  *
- * We don't save and restore VM_LOCKED here because pages are
+ * We don't save and restore specified flags here because pages are
  * still on lru.  In unmap path, pages might be scanned by reclaim
  * and re-mlocked by try_to_{munlock|unmap} before we unmap and
  * free them.  This will result in freeing mlocked pages.
  */
-void munlock_vma_pages_range(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end)
+void munlock_vma_pages_range(struct vm_area_struct *vma, unsigned long start,
+			     unsigned long end, vm_flags_t to_drop)
 {
-	vma->vm_flags &= ~VM_LOCKED;
+	vma->vm_flags &= ~to_drop;
 
 	while (start < end) {
 		struct page *page = NULL;
@@ -548,7 +547,11 @@ success:
 	if (lock)
 		vma->vm_flags = newflags;
 	else
-		munlock_vma_pages_range(vma, start, end);
+		/*
+		 * We need to tell which VM_LOCK* flag(s) we are clearing here
+		 */
+		munlock_vma_pages_range(vma, start, end,
+					(vma->vm_flags & ~(newflags)));
 
 out:
 	*prev = vma;
@@ -641,8 +644,11 @@ static int do_mlock(unsigned long start,
 	if (error)
 		return error;
 
-	if (flags & VM_LOCKED) {
-		error = __mm_populate(start, len, 0);
+	if (flags & (VM_LOCKED | VM_LOCKONFAULT)) {
+		if (flags & VM_LOCKED)
+			error = __mm_populate(start, len, 0);
+		else
+			error = mm_lock_present(start, len);
 		if (error)
 			return __mlock_posix_error_return(error);
 	}
@@ -683,7 +689,7 @@ static int do_munlock(unsigned long star
 
 SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
-	return do_munlock(start, len, VM_LOCKED);
+	return do_munlock(start, len, VM_LOCKED | VM_LOCKONFAULT);
 }
 
 SYSCALL_DEFINE3(munlock2, unsigned long, start, size_t, len, int, flags)
diff -puN mm/mmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/mmap.c
--- a/mm/mmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/mmap.c
@@ -1659,12 +1659,12 @@ out:
 	perf_event_mmap(vma);
 
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
-	if (vm_flags & VM_LOCKED) {
+	if (vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 		if (!((vm_flags & VM_SPECIAL) || is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 		else
-			vma->vm_flags &= ~VM_LOCKED;
+			vma->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 	}
 
 	if (file)
@@ -2117,7 +2117,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (vma->vm_flags & VM_LOCKED) {
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 		unsigned long locked;
 		unsigned long limit;
 		locked = mm->locked_vm + grow;
@@ -2141,7 +2141,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 		mm->locked_vm += grow;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, grow);
 	return 0;
@@ -2596,7 +2596,7 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (mm->locked_vm) {
 		struct vm_area_struct *tmp = vma;
 		while (tmp && tmp->vm_start < end) {
-			if (tmp->vm_flags & VM_LOCKED) {
+			if (tmp->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 				mm->locked_vm -= vma_pages(tmp);
 				munlock_vma_pages_all(tmp);
 			}
@@ -2649,6 +2649,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	unsigned long populate = 0;
 	unsigned long ret = -EINVAL;
 	struct file *file;
+	vm_flags_t drop_lock_flag = 0;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
@@ -2688,10 +2689,15 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	flags |= MAP_SHARED | MAP_FIXED | MAP_POPULATE;
 	if (vma->vm_flags & VM_LOCKED) {
 		flags |= MAP_LOCKED;
-		/* drop PG_Mlocked flag for over-mapped range */
-		munlock_vma_pages_range(vma, start, start + size);
+		drop_lock_flag = VM_LOCKED;
+	} else if (vma->vm_flags & VM_LOCKONFAULT) {
+		drop_lock_flag = VM_LOCKONFAULT;
 	}
 
+	if (drop_lock_flag)
+		/* drop PG_Mlocked flag for over-mapped range */
+		munlock_vma_pages_range(vma, start, start + size, VM_LOCKED);
+
 	file = get_file(vma->vm_file);
 	ret = do_mmap_pgoff(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate);
@@ -2794,7 +2800,7 @@ static unsigned long do_brk(unsigned lon
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
-	if (flags & VM_LOCKED)
+	if (flags & (VM_LOCKED | VM_LOCKONFAULT))
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	vma->vm_flags |= VM_SOFTDIRTY;
 	return addr;
@@ -2829,7 +2835,7 @@ void exit_mmap(struct mm_struct *mm)
 	if (mm->locked_vm) {
 		vma = mm->mmap;
 		while (vma) {
-			if (vma->vm_flags & VM_LOCKED)
+			if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 				munlock_vma_pages_all(vma);
 			vma = vma->vm_next;
 		}
diff -puN mm/mremap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/mremap.c
--- a/mm/mremap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/mremap.c
@@ -335,7 +335,7 @@ static unsigned long move_vma(struct vm_
 			vma->vm_next->vm_flags |= VM_ACCOUNT;
 	}
 
-	if (vm_flags & VM_LOCKED) {
+	if (vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
 		*locked = true;
 	}
@@ -371,7 +371,7 @@ static struct vm_area_struct *vma_to_res
 			return ERR_PTR(-EINVAL);
 	}
 
-	if (vma->vm_flags & VM_LOCKED) {
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 		unsigned long locked, lock_limit;
 		locked = mm->locked_vm << PAGE_SHIFT;
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
@@ -548,7 +548,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			}
 
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
-			if (vma->vm_flags & VM_LOCKED) {
+			if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 				mm->locked_vm += pages;
 				locked = true;
 				new_addr = addr;
diff -puN mm/msync.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/msync.c
--- a/mm/msync.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/msync.c
@@ -73,7 +73,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		}
 		/* Here vma->vm_start <= start < vma->vm_end. */
 		if ((flags & MS_INVALIDATE) &&
-				(vma->vm_flags & VM_LOCKED)) {
+				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
 			error = -EBUSY;
 			goto out_unlock;
 		}
diff -puN mm/rmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/rmap.c
--- a/mm/rmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/rmap.c
@@ -742,9 +742,9 @@ static int page_referenced_one(struct pa
 		if (!pmd)
 			return SWAP_AGAIN;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 			spin_unlock(ptl);
-			pra->vm_flags |= VM_LOCKED;
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -763,9 +763,9 @@ static int page_referenced_one(struct pa
 		if (!pte)
 			return SWAP_AGAIN;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |= VM_LOCKED;
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -1205,7 +1205,7 @@ static int try_to_unmap_one(struct page
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED)
+		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 			goto out_mlock;
 
 		if (flags & TTU_MUNLOCK)
@@ -1315,7 +1315,7 @@ out_mlock:
 	 * page is actually mlocked.
 	 */
 	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 			mlock_vma_page(page);
 			ret = SWAP_MLOCK;
 		}
diff -puN mm/shmem.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/shmem.c
--- a/mm/shmem.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/shmem.c
@@ -754,7 +754,7 @@ static int shmem_writepage(struct page *
 	index = page->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
-	if (info->flags & VM_LOCKED)
+	if (info->flags & (VM_LOCKED | VM_LOCKONFAULT))
 		goto redirty;
 	if (!total_swap_pages)
 		goto redirty;
diff -puN mm/vmscan.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4 mm/vmscan.c
--- a/mm/vmscan.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4
+++ a/mm/vmscan.c
@@ -804,7 +804,7 @@ static enum page_references page_check_r
 	 * Mlock lost the isolation race with us.  Let try_to_unmap()
 	 * move the page to the unevictable list.
 	 */
-	if (vm_flags & VM_LOCKED)
+	if (vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 		return PAGEREF_RECLAIM;
 
 	if (referenced_ptes) {
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-v4.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-gup-add-mm_lock_present.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-v4.patch

