From: akpm@linux-foundation.org
Subject: + unlink_anon_vmas-in-__split_vma-in-case-of-error.patch added to -mm tree
Date: Wed, 15 Sep 2010 12:28:05 -0700
Message-ID: <201009151928.o8FJS5GD011026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994Ab0IOT2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 15:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mtosatti@redhat.com, riel@redhat.com, stable@kernel.org


The patch titled
     mmap: call unlink_anon_vmas() in __split_vma() in case of error
has been added to the -mm tree.  Its filename is
     unlink_anon_vmas-in-__split_vma-in-case-of-error.patch

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
Subject: mmap: call unlink_anon_vmas() in __split_vma() in case of error
From: Andrea Arcangeli <aarcange@redhat.com>

If __split_vma fails because of an out of memory condition the
anon_vma_chain isn't teardown and freed potentially leading to rmap walks
accessing freed vma information plus there's a memleak.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mmap.c~unlink_anon_vmas-in-__split_vma-in-case-of-error mm/mmap.c
--- a/mm/mmap.c~unlink_anon_vmas-in-__split_vma-in-case-of-error
+++ a/mm/mmap.c
@@ -2009,6 +2009,7 @@ static int __split_vma(struct mm_struct 
 			removed_exe_file_vma(mm);
 		fput(new->vm_file);
 	}
+	unlink_anon_vmas(new);
  out_free_mpol:
 	mpol_put(pol);
  out_free_vma:
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
rmap-fix-walk-during-fork.patch
unlink_anon_vmas-in-__split_vma-in-case-of-error.patch
define-madv_hugepage.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

