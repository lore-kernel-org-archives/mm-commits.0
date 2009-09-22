From: akpm@linux-foundation.org
Subject: [merged] mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:26 -0700
Message-ID: <200909222043.n8MKhQuu011618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103AbZIVUn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, hugh.dickins@tiscali.co.uk, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mmap: save some cycles for the shared anonymous mapping
has been removed from the -mm tree.  Its filename was
     mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mmap-save-some-cycles-for-the-shared-anonymous-mapping mm/mmap.c
--- a/mm/mmap.c~mmap-save-some-cycles-for-the-shared-anonymous-mapping
+++ a/mm/mmap.c
@@ -1191,21 +1191,21 @@ munmap_back:
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
