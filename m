From: akpm@linux-foundation.org
Subject: + mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch added to -mm tree
Date: Thu, 31 Mar 2011 11:52:30 -0700
Message-ID: <201103311852.p2VIqVSm021906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759135Ab1CaSwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     mm: nommu: fix a potential memory leak in do_mmap_private()
has been added to the -mm tree.  Its filename is
     mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch

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
Subject: mm: nommu: fix a potential memory leak in do_mmap_private()
From: Namhyung Kim <namhyung@gmail.com>

If f_op->read() fails and sysctl_nr_trim_pages > 1, there could be a
memory leak between @region->vm_end and @region->vm_top.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/nommu.c~mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private mm/nommu.c
--- a/mm/nommu.c~mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private
+++ a/mm/nommu.c
@@ -1217,7 +1217,7 @@ static int do_mmap_private(struct vm_are
 	return 0;
 
 error_free:
-	free_page_series(region->vm_start, region->vm_end);
+	free_page_series(region->vm_start, region->vm_top);
 	region->vm_start = vma->vm_start = 0;
 	region->vm_end   = vma->vm_end = 0;
 	region->vm_top   = 0;
_

Patches currently in -mm which might be from namhyung@gmail.com are

mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

