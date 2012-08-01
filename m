From: akpm@linux-foundation.org
Subject: + mm-change-nr_ptes-bug_on-to-warn_on.patch added to -mm tree
Date: Wed, 01 Aug 2012 14:14:02 -0700
Message-ID: <20120801211402.A46F41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:45873 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2HAVOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 17:14:04 -0400
Received: by obbwc20 with SMTP id wc20so5451407obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 14:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     Subject: mm: change nr_ptes BUG_ON to WARN_ON
has been added to the -mm tree.  Its filename is
     mm-change-nr_ptes-bug_on-to-warn_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: change nr_ptes BUG_ON to WARN_ON

Occasionally an isolated BUG_ON(mm->nr_ptes) gets reported, indicating
that not all the page tables allocated could be found and freed when
exit_mmap() tore down the user address space.

There's usually nothing we can say about it, beyond that it's probably a
sign of some bad memory or memory corruption; though it might still
indicate a bug in vma or page table management (and did recently reveal a
race in THP, fixed a few months ago).

But one overdue change we can make is from BUG_ON to WARN_ON.

It's fairly likely that the system will crash shortly afterwards in some
other way (for example, the BUG_ON(page_mapped(page)) in
__delete_from_page_cache(), once an inode mapped into the lost page tables
gets evicted); but might tell us more before that.

Change the BUG_ON(page_mapped) to WARN_ON too?  Later perhaps: I'm less
eager, since that one has several times led to fixes.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-change-nr_ptes-bug_on-to-warn_on mm/mmap.c
--- a/mm/mmap.c~mm-change-nr_ptes-bug_on-to-warn_on
+++ a/mm/mmap.c
@@ -2309,7 +2309,7 @@ void exit_mmap(struct mm_struct *mm)
 	}
 	vm_unacct_memory(nr_accounted);
 
-	BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
+	WARN_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-change-nr_ptes-bug_on-to-warn_on.patch
prio_tree-debugging-patch.patch

