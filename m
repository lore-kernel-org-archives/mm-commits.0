From: akpm@linux-foundation.org
Subject: [merged] mlock_vma_pages_range-only-return-success-or-failure.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:14 -0800
Message-ID: <201003091903.o29J3E4U030946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0CITDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk, kamewzawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: mlock_vma_pages_range() only return success or failure
has been removed from the -mm tree.  Its filename was
     mlock_vma_pages_range-only-return-success-or-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: mlock_vma_pages_range() only return success or failure
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, mlock_vma_pages_range() only return len or 0.  then current
error handling of mmap_region() is meaningless complex.

This patch makes simplify and makes consist with brk() code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamewzawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mlock_vma_pages_range-only-return-success-or-failure mm/mmap.c
--- a/mm/mmap.c~mlock_vma_pages_range-only-return-success-or-failure
+++ a/mm/mmap.c
@@ -1265,8 +1265,8 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+		if (!mlock_vma_pages_range(vma, addr, addr + len))
+			mm->locked_vm += (len >> PAGE_SHIFT);
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

