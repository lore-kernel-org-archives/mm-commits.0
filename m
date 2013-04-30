From: akpm@linux-foundation.org
Subject: [merged] mm-madvise-complete-input-validation-before-taking-lock.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:25 -0700
Message-ID: <20130430184925.7930F31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:33707 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3St0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:26 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86656qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise: complete input validation before taking lock
has been removed from the -mm tree.  Its filename was
     mm-madvise-complete-input-validation-before-taking-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: madvise: complete input validation before taking lock

In madvise(), there doesn't seem to be any reason for taking the
&current->mm->mmap_sem before start and len_in have been validated. 
Incidentally, this removes the need for the out: label.

[akpm@linux-foundation.org: s/out_plug/out/, per David]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/madvise.c~mm-madvise-complete-input-validation-before-taking-lock mm/madvise.c
--- a/mm/madvise.c~mm-madvise-complete-input-validation-before-taking-lock
+++ a/mm/madvise.c
@@ -473,27 +473,27 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	if (!madvise_behavior_valid(behavior))
 		return error;
 
-	write = madvise_need_mmap_write(behavior);
-	if (write)
-		down_write(&current->mm->mmap_sem);
-	else
-		down_read(&current->mm->mmap_sem);
-
 	if (start & ~PAGE_MASK)
-		goto out;
+		return error;
 	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
 
 	/* Check to see whether len was rounded up from small -ve to zero */
 	if (len_in && !len)
-		goto out;
+		return error;
 
 	end = start + len;
 	if (end < start)
-		goto out;
+		return error;
 
 	error = 0;
 	if (end == start)
-		goto out;
+		return error;
+
+	write = madvise_need_mmap_write(behavior);
+	if (write)
+		down_write(&current->mm->mmap_sem);
+	else
+		down_read(&current->mm->mmap_sem);
 
 	/*
 	 * If the interval [start,end) covers some unmapped address
@@ -509,14 +509,14 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 		/* Still start < end. */
 		error = -ENOMEM;
 		if (!vma)
-			goto out_plug;
+			goto out;
 
 		/* Here start < (end|vma->vm_end). */
 		if (start < vma->vm_start) {
 			unmapped_error = -ENOMEM;
 			start = vma->vm_start;
 			if (start >= end)
-				goto out_plug;
+				goto out;
 		}
 
 		/* Here vma->vm_start <= start < (end|vma->vm_end) */
@@ -527,21 +527,20 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
 		error = madvise_vma(vma, &prev, start, tmp, behavior);
 		if (error)
-			goto out_plug;
+			goto out;
 		start = tmp;
 		if (prev && start < prev->vm_end)
 			start = prev->vm_end;
 		error = unmapped_error;
 		if (start >= end)
-			goto out_plug;
+			goto out;
 		if (prev)
 			vma = prev->vm_next;
 		else	/* madvise_remove dropped mmap_sem */
 			vma = find_vma(current->mm, start);
 	}
-out_plug:
-	blk_finish_plug(&plug);
 out:
+	blk_finish_plug(&plug);
 	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch

