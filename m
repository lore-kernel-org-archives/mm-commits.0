From: akpm@linux-foundation.org
Subject: + mm-rename-foll_mlock-to-foll_populate.patch added to -mm tree
Date: Wed, 18 Feb 2015 12:55:50 -0800
Message-ID: <54e4fc56.gezptwkrMi39xypP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbBRUzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:55:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename FOLL_MLOCK to FOLL_POPULATE
has been added to the -mm tree.  Its filename is
     mm-rename-foll_mlock-to-foll_populate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-foll_mlock-to-foll_populate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-foll_mlock-to-foll_populate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rename FOLL_MLOCK to FOLL_POPULATE

After a1fde08c74e9 ("VM: skip the stack guard page lookup in
get_user_pages only for mlock") FOLL_MLOCK has lost its original meaning:
we don't necessarily mlock the page if the flags is set -- we also take
VM_LOCKED into consideration.

Since we use the same codepath for __mm_populate(), let's rename
FOLL_MLOCK to FOLL_POPULATE.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/gup.c           |    6 +++---
 mm/huge_memory.c   |    2 +-
 mm/mlock.c         |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-rename-foll_mlock-to-foll_populate include/linux/mm.h
--- a/include/linux/mm.h~mm-rename-foll_mlock-to-foll_populate
+++ a/include/linux/mm.h
@@ -2109,7 +2109,7 @@ static inline struct page *follow_page(s
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_MLOCK	0x40	/* mark page as mlocked */
+#define FOLL_POPULATE	0x40	/* fault in page */
 #define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
diff -puN mm/gup.c~mm-rename-foll_mlock-to-foll_populate mm/gup.c
--- a/mm/gup.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/gup.c
@@ -92,7 +92,7 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
@@ -265,8 +265,8 @@ static int faultin_page(struct task_stru
 	unsigned int fault_flags = 0;
 	int ret;
 
-	/* For mlock, just skip the stack guard page. */
-	if ((*flags & FOLL_MLOCK) &&
+	/* For mm_populate(), just skip the stack guard page. */
+	if ((*flags & FOLL_POPULATE) &&
 			(stack_guard_page_start(vma, address) ||
 			 stack_guard_page_end(vma, address + PAGE_SIZE)))
 		return -ENOENT;
diff -puN mm/huge_memory.c~mm-rename-foll_mlock-to-foll_populate mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/huge_memory.c
@@ -1231,7 +1231,7 @@ struct page *follow_trans_huge_pmd(struc
 					  pmd, _pmd,  1))
 			update_mmu_cache_pmd(vma, addr, pmd);
 	}
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
diff -puN mm/mlock.c~mm-rename-foll_mlock-to-foll_populate mm/mlock.c
--- a/mm/mlock.c~mm-rename-foll_mlock-to-foll_populate
+++ a/mm/mlock.c
@@ -237,7 +237,7 @@ long __mlock_vma_pages_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch

