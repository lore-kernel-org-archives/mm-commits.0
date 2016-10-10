From: akpm@linux-foundation.org
Subject: [merged] mm-vm_page_prot-update-with-write_once-read_once.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:46:08 -0700
Message-ID: <57fc1a30.b21eofii1GyPaUt1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcJJWqJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vm_page_prot: update with WRITE_ONCE/READ_ONCE
has been removed from the -mm tree.  Its filename was
     mm-vm_page_prot-update-with-write_once-read_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vm_page_prot: update with WRITE_ONCE/READ_ONCE

vma->vm_page_prot is read lockless from the rmap_walk, it may be updated
concurrently and this prevents the risk of reading intermediate values.

Link: http://lkml.kernel.org/r/1474660305-19222-1-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/huge_memory.c   |    2 +-
 mm/migrate.c       |    2 +-
 mm/mmap.c          |   16 +++++++++-------
 mm/mprotect.c      |    2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-vm_page_prot-update-with-write_once-read_once include/linux/mm.h
--- a/include/linux/mm.h~mm-vm_page_prot-update-with-write_once-read_once
+++ a/include/linux/mm.h
@@ -1517,7 +1517,7 @@ static inline int pte_devmap(pte_t pte)
 }
 #endif
 
-int vma_wants_writenotify(struct vm_area_struct *vma);
+int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 
 extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			       spinlock_t **ptl);
diff -puN mm/huge_memory.c~mm-vm_page_prot-update-with-write_once-read_once mm/huge_memory.c
--- a/mm/huge_memory.c~mm-vm_page_prot-update-with-write_once-read_once
+++ a/mm/huge_memory.c
@@ -1620,7 +1620,7 @@ static void __split_huge_pmd_locked(stru
 			if (soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
 		} else {
-			entry = mk_pte(page + i, vma->vm_page_prot);
+			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
 			entry = maybe_mkwrite(entry, vma);
 			if (!write)
 				entry = pte_wrprotect(entry);
diff -puN mm/migrate.c~mm-vm_page_prot-update-with-write_once-read_once mm/migrate.c
--- a/mm/migrate.c~mm-vm_page_prot-update-with-write_once-read_once
+++ a/mm/migrate.c
@@ -234,7 +234,7 @@ static int remove_migration_pte(struct p
 		goto unlock;
 
 	get_page(new);
-	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
+	pte = pte_mkold(mk_pte(new, READ_ONCE(vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(*ptep))
 		pte = pte_mksoft_dirty(pte);
 
diff -puN mm/mmap.c~mm-vm_page_prot-update-with-write_once-read_once mm/mmap.c
--- a/mm/mmap.c~mm-vm_page_prot-update-with-write_once-read_once
+++ a/mm/mmap.c
@@ -116,13 +116,15 @@ static pgprot_t vm_pgprot_modify(pgprot_
 void vma_set_page_prot(struct vm_area_struct *vma)
 {
 	unsigned long vm_flags = vma->vm_flags;
+	pgprot_t vm_page_prot;
 
-	vma->vm_page_prot = vm_pgprot_modify(vma->vm_page_prot, vm_flags);
-	if (vma_wants_writenotify(vma)) {
+	vm_page_prot = vm_pgprot_modify(vma->vm_page_prot, vm_flags);
+	if (vma_wants_writenotify(vma, vm_page_prot)) {
 		vm_flags &= ~VM_SHARED;
-		vma->vm_page_prot = vm_pgprot_modify(vma->vm_page_prot,
-						     vm_flags);
+		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
 	}
+	/* remove_protection_ptes reads vma->vm_page_prot without mmap_sem */
+	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
 /*
@@ -1386,7 +1388,7 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_ar
  * to the private version (using protection_map[] without the
  * VM_SHARED bit).
  */
-int vma_wants_writenotify(struct vm_area_struct *vma)
+int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	const struct vm_operations_struct *vm_ops = vma->vm_ops;
@@ -1401,8 +1403,8 @@ int vma_wants_writenotify(struct vm_area
 
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
-	if (pgprot_val(vma->vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vma->vm_page_prot, vm_flags)))
+	if (pgprot_val(vm_page_prot) !=
+	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
 		return 0;
 
 	/* Do we need to track softdirty? */
diff -puN mm/mprotect.c~mm-vm_page_prot-update-with-write_once-read_once mm/mprotect.c
--- a/mm/mprotect.c~mm-vm_page_prot-update-with-write_once-read_once
+++ a/mm/mprotect.c
@@ -327,7 +327,7 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	dirty_accountable = vma_wants_writenotify(vma);
+	dirty_accountable = vma_wants_writenotify(vma, vma->vm_page_prot);
 	vma_set_page_prot(vma);
 
 	change_protection(vma, start, end, vma->vm_page_prot,
_

Patches currently in -mm which might be from aarcange@redhat.com are


