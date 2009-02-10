From: akpm@linux-foundation.org
Subject: + mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap.patch added to -mm tree
Date: Tue, 10 Feb 2009 13:29:58 -0800
Message-ID: <200902102129.n1ALTxFd014435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513AbZBJVa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 16:30:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, alex.williamson@hp.com, christophe@saout.de, jeremy.fitzhardinge@citrix.com, keir.fraser@eu.citrix.com, lee.schermerhorn@hp.com, stable@kernel.org


The patch titled
     mm: rearrange exit_mmap() to unlock before arch_exit_mmap
has been added to the -mm tree.  Its filename is
     mm-rearrange-exit_mmap-to-unlock-before-arch_exit_mmap.patch

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
@@ -2082,12 +2082,8 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long end;
 
 	/* mm's last user has gone, and its about to be pulled down */
-	arch_exit_mmap(mm);
 	mmu_notifier_release(mm);
 
-	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
-		return;
