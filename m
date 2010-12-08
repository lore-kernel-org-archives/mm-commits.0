From: akpm@linux-foundation.org
Subject: + mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch added to -mm tree
Date: Wed, 08 Dec 2010 15:42:36 -0800
Message-ID: <201012082342.oB8Ngbo3016591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab0LHXnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 18:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     mm: move VM_LOCKED check to __mlock_vma_pages_range()
has been added to the -mm tree.  Its filename is
     mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch

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
Subject: mm: move VM_LOCKED check to __mlock_vma_pages_range()
From: Michel Lespinasse <walken@google.com>

Use a single code path for faulting in pages during mlock.

The reason to have it in this patch series is that I did not want to
update both code paths in a later change that releases mmap_sem when
blocking on disk.

Signed-off-by: Michel Lespinasse <walken@google.com>
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

 mm/mlock.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/mlock.c~mm-move-vm_locked-check-to-__mlock_vma_pages_range mm/mlock.c
--- a/mm/mlock.c~mm-move-vm_locked-check-to-__mlock_vma_pages_range
+++ a/mm/mlock.c
@@ -169,7 +169,7 @@ static long __mlock_vma_pages_range(stru
 	VM_BUG_ON(end   > vma->vm_end);
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
-	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
+	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
@@ -178,6 +178,9 @@ static long __mlock_vma_pages_range(stru
 	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	if (vma->vm_flags & VM_LOCKED)
+		gup_flags |= FOLL_MLOCK;
+
 	/* We don't try to access the guard page of a stack vma */
 	if (stack_guard_page(vma, start)) {
 		addr += PAGE_SIZE;
@@ -456,14 +459,11 @@ static int do_mlock_pages(unsigned long 
 		/*
 		 * Now fault in a range of pages within the first VMA.
 		 */
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = __mlock_vma_pages_range(vma, nstart, nend);
-			if (ret) {
-				ret = __mlock_posix_error_return(ret);
-				break;
-			}
-		} else
-			make_pages_present(nstart, nend);
+		ret = __mlock_vma_pages_range(vma, nstart, nend);
+		if (ret) {
+			ret = __mlock_posix_error_return(ret);
+			break;
+		}
 	}
 	up_read(&mm->mmap_sem);
 	return ret;	/* 0 or negative error code */
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
rwsem-implement-rwsem_is_contended.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
x86-rwsem-more-precise-rwsem_is_contended-implementation.patch

