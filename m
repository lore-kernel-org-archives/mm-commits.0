From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-fix-sparse-warnings.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:04 -0800
Message-ID: <200902241933.n1OJX4j1004488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbZBXTdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/proc/task_mmu.c: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

