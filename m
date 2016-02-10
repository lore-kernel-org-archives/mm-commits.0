From: akpm@linux-foundation.org
Subject: [merged]
 mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch removed
 from -mm tree
Date: Wed, 10 Feb 2016 11:35:59 -0800
Message-ID: <56bb911f.UvFf/NKIvzQEDnOH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbcBJTgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, aarcange@redhat.com, dvyukov@google.com, kirill.shutemov@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace vma_lock_anon_vma with anon_vma_lock_read/write
has been removed from the -mm tree.  Its filename was
     mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: replace vma_lock_anon_vma with anon_vma_lock_read/write

Sequence vma_lock_anon_vma() - vma_unlock_anon_vma() isn't safe if
anon_vma appeared between lock and unlock.  We have to check anon_vma
first or call anon_vma_prepare() to be sure that it's here.  There are
only few users of these legacy helpers.  Let's get rid of them.

This patch fixes anon_vma lock imbalance in validate_mm().  Write lock
isn't required here, read lock is enough.

And reorders expand_downwards/expand_upwards: security_mmap_addr() and
wrapping-around check don't have to be under anon vma lock.

Link: https://lkml.kernel.org/r/CACT4Y+Y908EjM2z=706dv4rV6dWtxTLK9nFg9_7DhRMLppBo2g@mail.gmail.com
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   14 ----------
 mm/mmap.c            |   55 ++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 44 deletions(-)

diff -puN include/linux/rmap.h~mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write include/linux/rmap.h
--- a/include/linux/rmap.h~mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write
+++ a/include/linux/rmap.h
@@ -109,20 +109,6 @@ static inline void put_anon_vma(struct a
 		__put_anon_vma(anon_vma);
 }
 
-static inline void vma_lock_anon_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma *anon_vma = vma->anon_vma;
-	if (anon_vma)
-		down_write(&anon_vma->root->rwsem);
-}
-
-static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma *anon_vma = vma->anon_vma;
-	if (anon_vma)
-		up_write(&anon_vma->root->rwsem);
-}
-
 static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
 	down_write(&anon_vma->root->rwsem);
diff -puN mm/mmap.c~mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write mm/mmap.c
--- a/mm/mmap.c~mm-replace-vma_lock_anon_vma-with-anon_vma_lock_read-write
+++ a/mm/mmap.c
@@ -459,12 +459,16 @@ static void validate_mm(struct mm_struct
 	struct vm_area_struct *vma = mm->mmap;
 
 	while (vma) {
+		struct anon_vma *anon_vma = vma->anon_vma;
 		struct anon_vma_chain *avc;
 
-		vma_lock_anon_vma(vma);
-		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-			anon_vma_interval_tree_verify(avc);
-		vma_unlock_anon_vma(vma);
+		if (anon_vma) {
+			anon_vma_lock_read(anon_vma);
+			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+				anon_vma_interval_tree_verify(avc);
+			anon_vma_unlock_read(anon_vma);
+		}
+
 		highest_address = vma->vm_end;
 		vma = vma->vm_next;
 		i++;
@@ -2145,32 +2149,27 @@ static int acct_stack_growth(struct vm_a
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int error;
+	int error = 0;
 
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
 
-	/*
-	 * We must make sure the anon_vma is allocated
-	 * so that the anon_vma locking is not a noop.
-	 */
+	/* Guard against wrapping around to address 0. */
+	if (address < PAGE_ALIGN(address+4))
+		address = PAGE_ALIGN(address+4);
+	else
+		return -ENOMEM;
+
+	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
-	vma_lock_anon_vma(vma);
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
-	 * Also guard against wrapping around to address 0.
 	 */
-	if (address < PAGE_ALIGN(address+4))
-		address = PAGE_ALIGN(address+4);
-	else {
-		vma_unlock_anon_vma(vma);
-		return -ENOMEM;
-	}
-	error = 0;
+	anon_vma_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
@@ -2188,7 +2187,7 @@ int expand_upwards(struct vm_area_struct
 				 * updates, but we only hold a shared mmap_sem
 				 * lock here, so we need to protect against
 				 * concurrent vma expansions.
-				 * vma_lock_anon_vma() doesn't help here, as
+				 * anon_vma_lock_write() doesn't help here, as
 				 * we don't guarantee that all growable vmas
 				 * in a mm share the same root anon vma.
 				 * So, we reuse mm->page_table_lock to guard
@@ -2211,7 +2210,7 @@ int expand_upwards(struct vm_area_struct
 			}
 		}
 	}
-	vma_unlock_anon_vma(vma);
+	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(mm);
 	return error;
@@ -2227,25 +2226,21 @@ int expand_downwards(struct vm_area_stru
 	struct mm_struct *mm = vma->vm_mm;
 	int error;
 
-	/*
-	 * We must make sure the anon_vma is allocated
-	 * so that the anon_vma locking is not a noop.
-	 */
-	if (unlikely(anon_vma_prepare(vma)))
-		return -ENOMEM;
-
 	address &= PAGE_MASK;
 	error = security_mmap_addr(address);
 	if (error)
 		return error;
 
-	vma_lock_anon_vma(vma);
+	/* We must make sure the anon_vma is allocated. */
+	if (unlikely(anon_vma_prepare(vma)))
+		return -ENOMEM;
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
 	 */
+	anon_vma_lock_write(vma->anon_vma);
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
@@ -2263,7 +2258,7 @@ int expand_downwards(struct vm_area_stru
 				 * updates, but we only hold a shared mmap_sem
 				 * lock here, so we need to protect against
 				 * concurrent vma expansions.
-				 * vma_lock_anon_vma() doesn't help here, as
+				 * anon_vma_lock_write() doesn't help here, as
 				 * we don't guarantee that all growable vmas
 				 * in a mm share the same root anon vma.
 				 * So, we reuse mm->page_table_lock to guard
@@ -2284,7 +2279,7 @@ int expand_downwards(struct vm_area_stru
 			}
 		}
 	}
-	vma_unlock_anon_vma(vma);
+	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(mm);
 	return error;
_

Patches currently in -mm which might be from koct9i@gmail.com are

tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch
radix-tree-tests-add-regression3-test.patch

