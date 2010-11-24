From: akpm@linux-foundation.org
Subject: + mlock-avoid-dirtying-pages-and-triggering-writeback.patch added to -mm tree
Date: Wed, 24 Nov 2010 15:22:02 -0800
Message-ID: <201011242322.oAONM2Ox010084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab0KXXWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 18:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, david@fromorbit.com, hch@infradead.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, suleiman@google.com, tytso@google.com


The patch titled
     mlock: avoid dirtying pages and triggering writeback
has been added to the -mm tree.  Its filename is
     mlock-avoid-dirtying-pages-and-triggering-writeback.patch

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
Subject: mlock: avoid dirtying pages and triggering writeback
From: Michel Lespinasse <walken@google.com>

When faulting in pages for mlock(), we want to break COW for anonymous or
file pages within VM_WRITABLE, non-VM_SHARED vmas.  However, there is no
need to write-fault into VM_SHARED vmas since shared file pages can be
mlocked first and dirtied later, when/if they actually get written to. 
Skipping the write fault is desirable, as we don't want to unnecessarily
cause these pages to be dirtied and queued for writeback.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Theodore Tso <tytso@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++++-
 mm/mlock.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mlock-avoid-dirtying-pages-and-triggering-writeback mm/memory.c
--- a/mm/memory.c~mlock-avoid-dirtying-pages-and-triggering-writeback
+++ a/mm/memory.c
@@ -3324,7 +3324,12 @@ int make_pages_present(unsigned long add
 	vma = find_vma(current->mm, addr);
 	if (!vma)
 		return -ENOMEM;
-	write = (vma->vm_flags & VM_WRITE) != 0;
+	/*
+	 * We want to touch writable mappings with a write fault in order
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	write = (vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
diff -puN mm/mlock.c~mlock-avoid-dirtying-pages-and-triggering-writeback mm/mlock.c
--- a/mm/mlock.c~mlock-avoid-dirtying-pages-and-triggering-writeback
+++ a/mm/mlock.c
@@ -171,7 +171,12 @@ static long __mlock_vma_pages_range(stru
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	gup_flags = FOLL_TOUCH | FOLL_GET;
-	if (vma->vm_flags & VM_WRITE)
+	/*
+	 * We want to touch writable mappings with a write fault in order
+	 * to break COW, except for shared mappings because these don't COW
+	 * and we would not want to dirty them for nothing.
+	 */
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
 	/* We don't try to access the guard page of a stack vma */
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch

