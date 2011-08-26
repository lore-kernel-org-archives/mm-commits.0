From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch added to -mm tree
Date: Fri, 26 Aug 2011 14:23:44 -0700
Message-ID: <201108262123.p7QLNi4j012866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab1HZVYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 17:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caspar@casparzhang.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm/mempolicy.c: fix pgoff in mbind vma merge
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch

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
Subject: mm/mempolicy.c: fix pgoff in mbind vma merge
From: Caspar Zhang <caspar@casparzhang.com>

commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") didn't really fix
the mbind vma merge problem due to wrong pgoff value passing to
vma_merge(), which made vma_merge() always return NULL.

Re-tested the patched kernel with the reproducer provided in commit
9d8cebd, got correct result like below:

addr = 0x7ffa5aaa2000
[snip]
7ffa5aaa2000-7ffa5aaa6000 rw-p 00000000 00:00 0
7fffd556f000-7fffd5584000 rw-p 00000000 00:00 0                          [stack]

Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-fix-pgoff-in-mbind-vma-merge mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-fix-pgoff-in-mbind-vma-merge
+++ a/mm/mempolicy.c
@@ -636,7 +636,6 @@ static int mbind_range(struct mm_struct 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
-	pgoff_t pgoff;
 	unsigned long vmstart;
 	unsigned long vmend;
 
@@ -649,9 +648,9 @@ static int mbind_range(struct mm_struct 
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
-		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
+				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
+				  new_pol);
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
_

Patches currently in -mm which might be from caspar@casparzhang.com are

mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch

