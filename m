From: akpm@linux-foundation.org
Subject: + mlock_vma_pages_range-only-return-success-or-failure.patch added to -mm tree
Date: Mon, 04 Jan 2010 16:42:15 -0800
Message-ID: <201001050042.o050gGef028281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab0AEAnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 19:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk, kamewzawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: mlock_vma_pages_range() only return success or failure
has been added to the -mm tree.  Its filename is
     mlock_vma_pages_range-only-return-success-or-failure.patch

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

linux-next.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

