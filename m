From: akpm@linux-foundation.org
Subject: + rmap-fix-walk-during-fork.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:19:22 -0700
Message-ID: <201009151919.o8FJJMYR010623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651Ab0IOTTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, riel@redhat.com


The patch titled
     rmap: fix walk during fork
has been added to the -mm tree.  Its filename is
     rmap-fix-walk-during-fork.patch

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
Subject: rmap: fix walk during fork
From: Andrea Arcangeli <aarcange@redhat.com>

The below bug in fork led to the rmap walk finding the parent huge-pmd
twice instead of just once, because the anon_vma_chain objects of the
child vma still point to the vma->vm_mm of the parent.

The patch fixes it by making the rmap walk accurate during fork.  It's not
a big deal normally but it worth being accurate considering the cost is
the same.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~rmap-fix-walk-during-fork kernel/fork.c
--- a/kernel/fork.c~rmap-fix-walk-during-fork
+++ a/kernel/fork.c
@@ -356,10 +356,10 @@ static int dup_mmap(struct mm_struct *mm
 		if (IS_ERR(pol))
 			goto fail_nomem_policy;
 		vma_set_policy(tmp, pol);
+		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~VM_LOCKED;
-		tmp->vm_mm = mm;
 		tmp->vm_next = tmp->vm_prev = NULL;
 		file = tmp->vm_file;
 		if (file) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
rmap-fix-walk-during-fork.patch
define-madv_hugepage.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

