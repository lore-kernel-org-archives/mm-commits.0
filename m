From: akpm@linux-foundation.org
Subject: + mm-fix-anon_vma_clone-error-treatment.patch added to -mm tree
Date: Wed, 26 Nov 2014 14:35:16 -0800
Message-ID: <547655a4.JgF0Dhnt58j+haZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZWfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 17:35:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.forrest@ssec.wisc.edu, aarcange@redhat.com, hughd@google.com, koct9i@gmail.com, riel@redhat.com, tim@edgecast.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix anon_vma_clone() error treatment
has been added to the -mm tree.  Its filename is
     mm-fix-anon_vma_clone-error-treatment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-anon_vma_clone-error-treatment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-anon_vma_clone-error-treatment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Subject: mm: fix anon_vma_clone() error treatment

Andrew Morton noticed that the error return from anon_vma_clone() was
being dropped and replaced with -ENOMEM (which is not itself a bug because
the only error return value from anon_vma_clone() is -ENOMEM).

I did an audit of callers of anon_vma_clone() and discovered an actual bug
where the error return was being lost.  In __split_vma(), between Linux
3.11 and 3.12 the code was changed so the err variable is used before the
call to anon_vma_clone() and the default initial value of -ENOMEM is
overwritten.  So a failure of anon_vma_clone() will return success since
err at this point is now zero.

Below is a patch which fixes this bug and also propagates the error return
value from anon_vma_clone() in all cases.

Signed-off-by: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tim Hartrick <tim@edgecast.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++++---
 mm/rmap.c |    6 ++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mm-fix-anon_vma_clone-error-treatment mm/mmap.c
--- a/mm/mmap.c~mm-fix-anon_vma_clone-error-treatment
+++ a/mm/mmap.c
@@ -776,8 +776,11 @@ again:			remove_next = 1 + (end > next->
 		 * shrinking vma had, to cover any anon pages imported.
 		 */
 		if (exporter && exporter->anon_vma && !importer->anon_vma) {
-			if (anon_vma_clone(importer, exporter))
-				return -ENOMEM;
+			int error;
+
+			error = anon_vma_clone(importer, exporter);
+			if (error)
+				return error;
 			importer->anon_vma = exporter->anon_vma;
 		}
 	}
@@ -2471,7 +2474,8 @@ static int __split_vma(struct mm_struct
 	if (err)
 		goto out_free_vma;
 
-	if (anon_vma_clone(new, vma))
+	err = anon_vma_clone(new, vma);
+	if (err)
 		goto out_free_mpol;
 
 	if (new->vm_file)
diff -puN mm/rmap.c~mm-fix-anon_vma_clone-error-treatment mm/rmap.c
--- a/mm/rmap.c~mm-fix-anon_vma_clone-error-treatment
+++ a/mm/rmap.c
@@ -274,6 +274,7 @@ int anon_vma_fork(struct vm_area_struct
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
+	int error;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -283,8 +284,9 @@ int anon_vma_fork(struct vm_area_struct
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	if (anon_vma_clone(vma, pvma))
-		return -ENOMEM;
+	error = anon_vma_clone(vma, pvma);
+	if (error)
+		return error;
 
 	/* Then add our own anon_vma. */
 	anon_vma = anon_vma_alloc();
_

Patches currently in -mm which might be from dan.forrest@ssec.wisc.edu are

mm-fix-anon_vma_clone-error-treatment.patch

