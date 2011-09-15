From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:35:03 -0700
Message-ID: <201109151935.p8FJZ56o024100@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591Ab1IOTfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caspar@casparzhang.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@


The patch titled
     mm/mempolicy.c: fix pgoff in mbind vma merge
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-fix-pgoff-in-mbind-vma-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mempolicy.c: fix pgoff in mbind vma merge
From: Caspar Zhang <caspar@casparzhang.com>

commit 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") didn't really fix
the mbind vma merge problem due to wrong pgoff value passing to
vma_merge(), which made vma_merge() always return NULL.

Before the patch applied, we are getting a result like:

addr = 0x7fa58f00c000
[snip]
7fa58f00c000-7fa58f00d000 rw-p 00000000 00:00 0
7fa58f00d000-7fa58f00e000 rw-p 00000000 00:00 0
7fa58f00e000-7fa58f00f000 rw-p 00000000 00:00 0

here 7fa58f00c000->7fa58f00f000 we get 3 VMAs which are expected to be
merged described as described in commit 9d8cebd.

Re-testing the patched kernel with the reproducer provided in commit
9d8cebd, we get the correct result:

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

origin.patch

