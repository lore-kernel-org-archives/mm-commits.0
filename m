From: akpm@linux-foundation.org
Subject: [merged] mlock_vma_pages_range-never-return-negative-value.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:11 -0800
Message-ID: <201003091903.o29J3B0i030936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab0CITDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk, kamewzawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: mlock_vma_pages_range() never return negative value
has been removed from the -mm tree.  Its filename was
     mlock_vma_pages_range-never-return-negative-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: mlock_vma_pages_range() never return negative value
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mlock_vma_pages_range() never return negative value.  Then, we
can remove some worthless error check.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamewzawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mlock_vma_pages_range-never-return-negative-value mm/mmap.c
--- a/mm/mmap.c~mlock_vma_pages_range-never-return-negative-value
+++ a/mm/mmap.c
@@ -1265,12 +1265,7 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		/*
-		 * makes pages present; downgrades, drops, reacquires mmap_sem
-		 */
 		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		if (nr_pages < 0)
-			return nr_pages;	/* vma gone! */
 		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
@@ -1754,8 +1749,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
-		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
-			return NULL;	/* vma gone! */
+		mlock_vma_pages_range(prev, addr, prev->vm_end);
 	}
 	return prev;
 }
@@ -1783,8 +1777,7 @@ find_extend_vma(struct mm_struct * mm, u
 	if (expand_stack(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED) {
-		if (mlock_vma_pages_range(vma, addr, start) < 0)
-			return NULL;	/* vma gone! */
+		mlock_vma_pages_range(vma, addr, start);
 	}
 	return vma;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

