From: akpm@linux-foundation.org
Subject: + nommu-fix-error-handling-in-do_mmap_pgoff.patch added to -mm tree
Date: Wed, 02 Sep 2009 14:48:22 -0700
Message-ID: <200909022148.n82LmM00011438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbZIBVtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 17:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gerg@snapgear.com, lethal@linux-sh.org, mel@csn.ul.ie, penberg@cs.helsinki.fi


The patch titled
     nommu: fix error handling in do_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     nommu-fix-error-handling-in-do_mmap_pgoff.patch

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
Subject: nommu: fix error handling in do_mmap_pgoff()
From: David Howells <dhowells@redhat.com>

Fix the error handling in do_mmap_pgoff().  If do_mmap_shared_file() or
do_mmap_private() fail, we jump to the error_put_region label at which
point we cann __put_nommu_region() on the region - but we haven't yet
added the region to the tree, and so __put_nommu_region() may BUG
because the region tree is empty or it may corrupt the region tree.

To get around this, we can afford to add the region to the region tree
before calling do_mmap_shared_file() or do_mmap_private() as we keep
nommu_region_sem write-locked, so no-one can race with us by seeing a
transient region.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/nommu.c~nommu-fix-error-handling-in-do_mmap_pgoff mm/nommu.c
--- a/mm/nommu.c~nommu-fix-error-handling-in-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1352,6 +1352,7 @@ unsigned long do_mmap_pgoff(struct file 
 	}
 
 	vma->vm_region = region;
+	add_nommu_region(region);
 
 	/* set up the mapping */
 	if (file && vma->vm_flags & VM_SHARED)
@@ -1361,8 +1362,6 @@ unsigned long do_mmap_pgoff(struct file 
 	if (ret < 0)
 		goto error_put_region;
 
-	add_nommu_region(region);
