From: akpm@linux-foundation.org
Subject: + mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch
 added to -mm tree
Date: Mon, 01 Feb 2016 13:35:15 -0800
Message-ID: <56afcf93.rTPLCd+xKXhQpryd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbcBAVfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 16:35:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@codemonkey.org.uk, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: retire GUP WARN_ON_ONCE that outlived its usefulness
has been added to the -mm tree.  Its filename is
     mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch

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
Subject: mm: retire GUP WARN_ON_ONCE that outlived its usefulness

Trinity is now hitting the WARN_ON_ONCE we added in v3.15 commit
cda540ace6a1 ("mm: get_user_pages(write,force) refuse to COW in shared
areas").  The warning has served its purpose, nobody was harmed by that
change, so just remove the warning to generate less noise from Trinity.

Which reminds me of the comment I wrongly left behind with that commit
(but was spotted at the time by Kirill), which has since moved into a
separate function, and become even more obscure: delete it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Suggested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c    |    4 +---
 mm/memory.c |    5 -----
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/gup.c~mm-retire-gup-warn_on_once-that-outlived-its-usefulness mm/gup.c
--- a/mm/gup.c~mm-retire-gup-warn_on_once-that-outlived-its-usefulness
+++ a/mm/gup.c
@@ -430,10 +430,8 @@ static int check_vma_flags(struct vm_are
 			 * Anon pages in shared mappings are surprising: now
 			 * just reject it.
 			 */
-			if (!is_cow_mapping(vm_flags)) {
-				WARN_ON_ONCE(vm_flags & VM_MAYWRITE);
+			if (!is_cow_mapping(vm_flags))
 				return -EFAULT;
-			}
 		}
 	} else if (!(vm_flags & VM_READ)) {
 		if (!(gup_flags & FOLL_FORCE))
diff -puN mm/memory.c~mm-retire-gup-warn_on_once-that-outlived-its-usefulness mm/memory.c
--- a/mm/memory.c~mm-retire-gup-warn_on_once-that-outlived-its-usefulness
+++ a/mm/memory.c
@@ -2237,11 +2237,6 @@ static int wp_page_shared(struct mm_stru
 
 	page_cache_get(old_page);
 
-	/*
-	 * Only catch write-faults on shared writable pages,
-	 * read-only shared pages can get COWed by
-	 * get_user_pages(.write=1, .force=1).
-	 */
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		int tmp;
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch

