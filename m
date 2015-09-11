From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-vm_lockonfault-v7.patch removed from -mm tree
Date: Fri, 11 Sep 2015 15:00:03 -0700
Message-ID: <55f34ee3.oZQcSP4DkXVdqTQ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbIKWAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-vm_lockonfault-v7
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_lockonfault-v7.patch

This patch was dropped because it was folded into mm-introduce-vm_lockonfault.patch

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm-introduce-vm_lockonfault-v7

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 +
 fs/proc/task_mmu.c                 |    2 +-
 include/linux/mm.h                 |    2 +-
 kernel/fork.c                      |    4 ++--
 mm/gup.c                           |    6 +++---
 mm/hugetlb.c                       |    4 ++--
 mm/rmap.c                          |    6 ++++--
 7 files changed, 14 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-introduce-vm_lockonfault-v7 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-introduce-vm_lockonfault-v7
+++ a/Documentation/filesystems/proc.txt
@@ -471,6 +471,7 @@ manner. The codes are the following:
     rr  - random read advise provided
     dc  - do not copy area on fork
     de  - do not expand area on remapping
+    lf  - mark area to lock pages when faulted in, do not pre-populate
     ac  - area is accountable
     nr  - swap space is not reserved for the area
     ht  - area uses huge tlb pages
diff -puN fs/proc/task_mmu.c~mm-introduce-vm_lockonfault-v7 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-introduce-vm_lockonfault-v7
+++ a/fs/proc/task_mmu.c
@@ -592,13 +592,13 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_X86_INTEL_MPX
 		[ilog2(VM_MPX)]		= "mp",
 #endif
-		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
 		[ilog2(VM_RAND_READ)]	= "rr",
 		[ilog2(VM_DONTCOPY)]	= "dc",
 		[ilog2(VM_DONTEXPAND)]	= "de",
+		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_ACCOUNT)]	= "ac",
 		[ilog2(VM_NORESERVE)]	= "nr",
 		[ilog2(VM_HUGETLB)]	= "ht",
diff -puN include/linux/mm.h~mm-introduce-vm_lockonfault-v7 include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vm_lockonfault-v7
+++ a/include/linux/mm.h
@@ -129,7 +129,6 @@ extern unsigned int kobjsize(const void
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
-#define VM_LOCKONFAULT	0x00001000	/* Lock the pages covered when they are faulted in */
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
@@ -139,6 +138,7 @@ extern unsigned int kobjsize(const void
 
 #define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
 #define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
diff -puN kernel/fork.c~mm-introduce-vm_lockonfault-v7 kernel/fork.c
--- a/kernel/fork.c~mm-introduce-vm_lockonfault-v7
+++ a/kernel/fork.c
@@ -454,8 +454,8 @@ static int dup_mmap(struct mm_struct *mm
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT |
-				   VM_UFFD_MISSING | VM_UFFD_WP);
+		tmp->vm_flags &= ~(VM_LOCKED | VM_UFFD_MISSING | VM_UFFD_WP |
+					VM_LOCKONFAULT);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
diff -puN mm/gup.c~mm-introduce-vm_lockonfault-v7 mm/gup.c
--- a/mm/gup.c~mm-introduce-vm_lockonfault-v7
+++ a/mm/gup.c
@@ -893,9 +893,9 @@ long populate_vma_page_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
-	if ((vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) == VM_LOCKED)
-		gup_flags |= FOLL_POPULATE;
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
+	if (vma->vm_flags & VM_LOCKONFAULT)
+		gup_flags &= ~FOLL_POPULATE;
 
 	/*
 	 * We want to touch writable mappings with a write fault in order
diff -puN mm/hugetlb.c~mm-introduce-vm_lockonfault-v7 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-introduce-vm_lockonfault-v7
+++ a/mm/hugetlb.c
@@ -4020,8 +4020,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
-	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED|VM_LOCKONFAULT);
+	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED|VM_LOCKONFAULT);
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN mm/rmap.c~mm-introduce-vm_lockonfault-v7 mm/rmap.c
--- a/mm/rmap.c~mm-introduce-vm_lockonfault-v7
+++ a/mm/rmap.c
@@ -848,7 +848,8 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			spin_unlock(ptl);
-			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |=
+				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -869,7 +870,8 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |=
+				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage-v7.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

