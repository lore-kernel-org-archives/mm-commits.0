From: akpm@linux-foundation.org
Subject: + mm-madvise-complete-input-validation-before-taking-lock.patch added to -mm tree
Date: Wed, 10 Apr 2013 16:49:33 -0700
Message-ID: <20130410234933.80FB131C309@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:58828 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab3DJXte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 19:49:34 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so172341ief.5
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 16:49:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rasmusvillemoes.dk


The patch titled
     Subject: mm: madvise: complete input validation before taking lock
has been added to the -mm tree.  Its filename is
     mm-madvise-complete-input-validation-before-taking-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: madvise: complete input validation before taking lock

In madvise(), there doesn't seem to be any reason for taking the
&current->mm->mmap_sem before start and len_in have been validated. 
Incidentally, this removes the need for the out: label.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

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
@@ -541,7 +541,6 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	}
 out_plug:
 	blk_finish_plug(&plug);
-out:
 	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-madvise-complete-input-validation-before-taking-lock.patch

