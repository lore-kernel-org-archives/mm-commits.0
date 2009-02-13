From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-fix-sparse-warnings.patch added to -mm tree
Date: Fri, 13 Feb 2009 15:30:38 -0800
Message-ID: <200902132330.n1DNUc9v009894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284AbZBMXal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 18:30:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com, adobriyan@gmail.com


The patch titled
     fs/proc/task_mmu.c: fix sparse warnings
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-fix-sparse-warnings.patch

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
Subject: fs/proc/task_mmu.c: fix sparse warnings
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

linux.git/fs/proc/task_mmu.c:723:26: error: subtraction of different types can't work (different address spaces)
linux.git/fs/proc/task_mmu.c:725:24: error: subtraction of different types can't work (different address spaces)

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-fix-sparse-warnings fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-fix-sparse-warnings
+++ a/fs/proc/task_mmu.c
@@ -721,9 +721,9 @@ static ssize_t pagemap_read(struct file 
 	if (ret == PM_END_OF_BUFFER)
 		ret = 0;
 	/* don't need mmap_sem for these, but this looks cleaner */
-	*ppos += (char *)pm.out - buf;
+	*ppos += (char __user *)pm.out - buf;
 	if (!ret)
-		ret = (char *)pm.out - buf;
+		ret = (char __user *)pm.out - buf;
 
 out_pages:
 	for (; pagecount; pagecount--) {
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

fs-proc-task_mmuc-fix-sparse-warnings.patch

