From: akpm@linux-foundation.org
Subject: + mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch added to -mm tree
Date: Fri, 11 Sep 2009 15:46:36 -0700
Message-ID: <200909112246.n8BMkaU9031070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbZIKWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 18:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, minchan.kim@gmail.com


The patch titled
     mmap: save some cycles for the shared anonymous mapping
has been added to the -mm tree.  Its filename is
     mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch

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
Subject: mmap: save some cycles for the shared anonymous mapping
From: Huang Shijie <shijie8@gmail.com>

shmem_zero_setup() does not change vm_start, pgoff or vm_flags, only some
drivers change them (such as /driver/video/bfin-t350mcqb-fb.c).

Move these codes to a more proper place to save cycles for shared
anonymous mapping.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mmap-save-some-cycles-for-the-shared-anonymous-mapping mm/mmap.c
--- a/mm/mmap.c~mmap-save-some-cycles-for-the-shared-anonymous-mapping
+++ a/mm/mmap.c
@@ -1210,21 +1210,21 @@ munmap_back:
 			goto unmap_and_free_vma;
 		if (vm_flags & VM_EXECUTABLE)
 			added_exe_file_vma(mm);
+
+		/* Can addr have changed??
+		 *
+		 * Answer: Yes, several device drivers can do it in their
+		 *         f_op->mmap method. -DaveM
+		 */
+		addr = vma->vm_start;
+		pgoff = vma->vm_pgoff;
+		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
 			goto free_vma;
 	}
 
-	/* Can addr have changed??
-	 *
-	 * Answer: Yes, several device drivers can do it in their
-	 *         f_op->mmap method. -DaveM
-	 */
-	addr = vma->vm_start;
-	pgoff = vma->vm_pgoff;
-	vm_flags = vma->vm_flags;
