From: akpm@linux-foundation.org
Subject: [merged] mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:59 -0800
Message-ID: <200902122025.n1CKPxHM015423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758264AbZBLUfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, alex.williamson@hp.com, christophe@saout.de, jeremy.fitzhardinge@citrix.com, keir.fraser@eu.citrix.com, lee.schermerhorn@hp.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: rearrange exit_mmap() to unlock before arch_exit_mmap
has been removed from the -mm tree.  Its filename was
     mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rearrange exit_mmap() to unlock before arch_exit_mmap
From: Jeremy Fitzhardinge <jeremy@goop.org>

Christophe Saout reported [in precursor to:
http://marc.info/?l=linux-kernel&m=123209902707347&w=4]:

> Note that I also some a different issue with CONFIG_UNEVICTABLE_LRU.
> Seems like Xen tears down current->mm early on process termination, so
> that __get_user_pages in exit_mmap causes nasty messages when the
> process had any mlocked pages.  (in fact, it somehow manages to get into
> the swapping code and produces a null pointer dereference trying to get
> a swap token)

Jeremy explained:

Yes.  In the normal case under Xen, an in-use pagetable is "pinned",
meaning that it is RO to the kernel, and all updates must go via hypercall
(or writes are trapped and emulated, which is much the same thing).  An
unpinned pagetable is not currently in use by any process, and can be
directly accessed as normal RW pages.

As an optimisation at process exit time, we unpin the pagetable as early
as possible (switching the process to init_mm), so that all the normal
pagetable teardown can happen with direct memory accesses.

This happens in exit_mmap() -> arch_exit_mmap().  The munlocking happens
a few lines below.  The obvious thing to do would be to move
arch_exit_mmap() to below the munlock code, but I think we'd want to
call it even if mm->mmap is NULL, just to be on the safe side.

Thus, this patch:

exit_mmap() needs to unlock any locked vmas before calling arch_exit_mmap,
as the latter may switch the current mm to init_mm, which would cause the
former to fail.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christophe Saout <christophe@saout.de>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>
Cc: Christophe Saout <christophe@saout.de>
Cc: Alex Williamson <alex.williamson@hp.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap mm/mmap.c
--- a/mm/mmap.c~mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap
+++ a/mm/mmap.c
@@ -2084,12 +2084,8 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
-	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
-	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
-		return;
