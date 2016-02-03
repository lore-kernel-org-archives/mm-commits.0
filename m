From: akpm@linux-foundation.org
Subject: [merged]
 mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch removed from
 -mm tree
Date: Wed, 03 Feb 2016 13:53:35 -0800
Message-ID: <56b276df.nJ361Gh/zEEkHNQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@codemonkey.org.uk, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: retire GUP WARN_ON_ONCE that outlived its usefulness
has been removed from the -mm tree.  Its filename was
     mm-retire-gup-warn_on_once-that-outlived-its-usefulness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


