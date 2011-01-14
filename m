From: akpm@linux-foundation.org
Subject: [merged] mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:33 -0800
Message-ID: <201101142248.p0EMmNFQ005196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1ANWsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@


The patch titled
     mm: move VM_LOCKED check to __mlock_vma_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/mlock.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

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
@@ -456,18 +459,15 @@ static int do_mlock_pages(unsigned long 
 		/*
 		 * Now fault in a range of pages within the first VMA.
 		 */
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = __mlock_vma_pages_range(vma, nstart, nend);
-			if (ret < 0 && ignore_errors) {
-				ret = 0;
-				continue;	/* continue at next VMA */
-			}
-			if (ret) {
-				ret = __mlock_posix_error_return(ret);
-				break;
-			}
-		} else
-			make_pages_present(nstart, nend);
+		ret = __mlock_vma_pages_range(vma, nstart, nend);
+		if (ret < 0 && ignore_errors) {
+			ret = 0;
+			continue;	/* continue at next VMA */
+		}
+		if (ret) {
+			ret = __mlock_posix_error_return(ret);
+			break;
+		}
 	}
 	up_read(&mm->mmap_sem);
 	return ret;	/* 0 or negative error code */
_

Patches currently in -mm which might be from walken@google.com are

origin.patch

