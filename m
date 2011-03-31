From: akpm@linux-foundation.org
Subject: + mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch added to -mm tree
Date: Thu, 31 Mar 2011 11:52:33 -0700
Message-ID: <201103311852.p2VIqXut021909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759122Ab1CaSwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     mm: nommu: fix a compile warning in do_mmap_pgoff()
has been added to the -mm tree.  Its filename is
     mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

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
Subject: mm: nommu: fix a compile warning in do_mmap_pgoff()
From: Namhyung Kim <namhyung@gmail.com>

Because 'ret' is declared as int, not unsigned long, no need to cast the
error contants into unsigned long.  If you compile this code on a 64-bit
machine somehow, you'll see following warning:

  CC      mm/nommu.o
mm/nommu.c: In function `do_mmap_pgoff':
mm/nommu.c:1411: warning: overflow in implicit constant conversion

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff mm/nommu.c
--- a/mm/nommu.c~mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1376,15 +1376,15 @@ unsigned long do_mmap_pgoff(struct file 
 		if (capabilities & BDI_CAP_MAP_DIRECT) {
 			addr = file->f_op->get_unmapped_area(file, addr, len,
 							     pgoff, flags);
-			if (IS_ERR((void *) addr)) {
+			if (IS_ERR_VALUE(addr)) {
 				ret = addr;
-				if (ret != (unsigned long) -ENOSYS)
+				if (ret != -ENOSYS)
 					goto error_just_free;
 
 				/* the driver refused to tell us where to site
 				 * the mapping so we'll have to attempt to copy
 				 * it */
-				ret = (unsigned long) -ENODEV;
+				ret = -ENODEV;
 				if (!(capabilities & BDI_CAP_MAP_COPY))
 					goto error_just_free;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

mm-nommu-sort-mm-mmap-list-properly.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-nommu-dont-scan-the-vma-list-when-deleting.patch
mm-nommu-find-vma-using-the-sorted-vma-list.patch
mm-nommu-check-the-vma-list-when-unmapping-file-mapped-vma.patch
mm-nommu-fix-a-potential-memory-leak-in-do_mmap_private.patch
mm-nommu-fix-a-compile-warning-in-do_mmap_pgoff.patch

