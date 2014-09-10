From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch added to -mm tree
Date: Wed, 10 Sep 2014 16:13:40 -0700
Message-ID: <5410db24.7xf58TXgIAIyZFEF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaIJXNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 19:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared
has been added to the -mm tree.  Its filename is
     mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared

For VMAs that don't want write notifications, PTEs created for read faults
have their write bit set.  If the read fault happens after VM_SOFTDIRTY is
cleared, then the PTE's softdirty bit will remain clear after subsequent
writes.

Here's a simple code snippet to demonstrate the bug:

  char* m = mmap(NULL, getpagesize(), PROT_READ | PROT_WRITE,
                 MAP_ANONYMOUS | MAP_SHARED, -1, 0);
  system("echo 4 > /proc/$PPID/clear_refs"); /* clear VM_SOFTDIRTY */
  assert(*m == '\0');     /* new PTE allows write access */
  assert(!soft_dirty(x));
  *m = 'x';               /* should dirty the page */
  assert(soft_dirty(x));  /* fails */

With this patch, write notifications are enabled when VM_SOFTDIRTY is
cleared.  Furthermore, to avoid unnecessary faults, write notifications
are disabled when VM_SOFTDIRTY is set.

As a side effect of enabling and disabling write notifications with care,
this patch fixes a bug in mprotect where vm_page_prot bits set by drivers
were zapped on mprotect.  An analogous bug was fixed in mmap by
c9d0bf241451a3ab7d ("mm: uncached vma support with writenotify").

Signed-off-by: Peter Feiner <pfeiner@google.com>
Reported-by: Peter Feiner <pfeiner@google.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c            |   19 +++++++++----
 include/asm-generic/pgtable.h |   12 ++++++++
 include/linux/mm.h            |    5 +++
 mm/memory.c                   |    3 +-
 mm/mmap.c                     |   45 +++++++++++++++++++-------------
 mm/mprotect.c                 |   20 +++-----------
 6 files changed, 66 insertions(+), 38 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/fs/proc/task_mmu.c
@@ -828,8 +828,21 @@ static ssize_t clear_refs_write(struct f
 			.private = &cp,
 		};
 		down_read(&mm->mmap_sem);
-		if (type == CLEAR_REFS_SOFT_DIRTY)
+		if (type == CLEAR_REFS_SOFT_DIRTY) {
+			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+				if (!(vma->vm_flags & VM_SOFTDIRTY))
+					continue;
+				up_read(&mm->mmap_sem);
+				down_write(&mm->mmap_sem);
+				for (vma = mm->mmap; vma; vma = vma->vm_next) {
+					vma->vm_flags &= ~VM_SOFTDIRTY;
+					vma_set_page_prot(vma);
+				}
+				downgrade_write(&mm->mmap_sem);
+				break;
+			}
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
+		}
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			cp.vma = vma;
 			if (is_vm_hugetlb_page(vma))
@@ -849,10 +862,6 @@ static ssize_t clear_refs_write(struct f
 				continue;
 			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
 				continue;
-			if (type == CLEAR_REFS_SOFT_DIRTY) {
-				if (vma->vm_flags & VM_SOFTDIRTY)
-					vma->vm_flags &= ~VM_SOFTDIRTY;
-			}
 			walk_page_range(vma->vm_start, vma->vm_end,
 					&clear_refs_walk);
 		}
diff -puN include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/include/asm-generic/pgtable.h
@@ -249,6 +249,18 @@ static inline int pmd_same(pmd_t pmd_a,
 #define pgprot_writecombine pgprot_noncached
 #endif
 
+#ifndef pgprot_modify
+#define pgprot_modify pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
+		newprot = pgprot_noncached(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
+		newprot = pgprot_writecombine(newprot);
+	return newprot;
+}
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff -puN include/linux/mm.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared include/linux/mm.h
--- a/include/linux/mm.h~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/include/linux/mm.h
@@ -1964,11 +1964,16 @@ static inline struct vm_area_struct *fin
 
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
+void vma_set_page_prot(struct vm_area_struct *vma);
 #else
 static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
 	return __pgprot(0);
 }
+static inline void vma_set_page_prot(struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+}
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
diff -puN mm/memory.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared mm/memory.c
--- a/mm/memory.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/mm/memory.c
@@ -2051,7 +2051,8 @@ static int do_wp_page(struct mm_struct *
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
 		/*
-		 * VM_MIXEDMAP !pfn_valid() case
+		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
+		 * VM_PFNMAP VMA.
 		 *
 		 * We should not cow pages in a shared writeable mapping.
 		 * Just mark the pages writable as we can't do any dirty
diff -puN mm/mmap.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared mm/mmap.c
--- a/mm/mmap.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/mm/mmap.c
@@ -89,6 +89,25 @@ pgprot_t vm_get_page_prot(unsigned long
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 
+static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
+{
+	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
+}
+
+/* Update vma->vm_page_prot to reflect vma->vm_flags. */
+void vma_set_page_prot(struct vm_area_struct *vma)
+{
+	unsigned long vm_flags = vma->vm_flags;
+
+	vma->vm_page_prot = vm_pgprot_modify(vma->vm_page_prot, vm_flags);
+	if (vma_wants_writenotify(vma)) {
+		vm_flags &= ~VM_SHARED;
+		vma->vm_page_prot = vm_pgprot_modify(vma->vm_page_prot,
+						     vm_flags);
+	}
+}
+
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 unsigned long sysctl_overcommit_kbytes __read_mostly;
@@ -1474,11 +1493,16 @@ int vma_wants_writenotify(struct vm_area
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite)
 		return 1;
 
-	/* The open routine did something to the protections already? */
+	/* The open routine did something to the protections that pgprot_modify
+	 * won't preserve? */
 	if (pgprot_val(vma->vm_page_prot) !=
-	    pgprot_val(vm_get_page_prot(vm_flags)))
+	    pgprot_val(vm_pgprot_modify(vma->vm_page_prot, vm_flags)))
 		return 0;
 
+	/* Do we need to track softdirty? */
+	if (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && !(vm_flags & VM_SOFTDIRTY))
+		return 1;
+
 	/* Specialty mapping? */
 	if (vm_flags & VM_PFNMAP)
 		return 0;
@@ -1614,21 +1638,6 @@ munmap_back:
 			goto free_vma;
 	}
 
-	if (vma_wants_writenotify(vma)) {
-		pgprot_t pprot = vma->vm_page_prot;
-
-		/* Can vma->vm_page_prot have changed??
-		 *
-		 * Answer: Yes, drivers may have changed it in their
-		 *         f_op->mmap method.
-		 *
-		 * Ensures that vmas marked as uncached stay that way.
-		 */
-		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
-		if (pgprot_val(pprot) == pgprot_val(pgprot_noncached(pprot)))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	}
-
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
@@ -1662,6 +1671,8 @@ out:
 	 */
 	vma->vm_flags |= VM_SOFTDIRTY;
 
+	vma_set_page_prot(vma);
+
 	return addr;
 
 unmap_and_free_vma:
diff -puN mm/mprotect.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared mm/mprotect.c
--- a/mm/mprotect.c~mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared
+++ a/mm/mprotect.c
@@ -29,13 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#ifndef pgprot_modify
-static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
-{
-	return newprot;
-}
-#endif
-
 /*
  * For a prot_numa update we only hold mmap_sem for read so there is a
  * potential race with faulting where a pmd was temporarily none. This
@@ -93,7 +86,9 @@ static unsigned long change_pte_range(st
 				 * Avoid taking write faults for pages we
 				 * know to be dirty.
 				 */
-				if (dirty_accountable && pte_dirty(ptent))
+				if (dirty_accountable && pte_dirty(ptent) &&
+				    (pte_soft_dirty(ptent) ||
+				     !(vma->vm_flags & VM_SOFTDIRTY)))
 					ptent = pte_mkwrite(ptent);
 				ptep_modify_prot_commit(mm, addr, pte, ptent);
 				updated = true;
@@ -320,13 +315,8 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
-					  vm_get_page_prot(newflags));
