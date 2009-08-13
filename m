From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch added to -mm tree
Date: Thu, 13 Aug 2009 15:57:28 -0700
Message-ID: <200908132257.n7DMvSpk002067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZHMW6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 18:58:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca, mpm@selenic.com, rientjes@google.com, xiyou.wangcong@gmail.com


The patch titled
     fs/proc/task_mmu.c v1: fix clear_refs_write() input sanity check
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch

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
Subject: fs/proc/task_mmu.c v1: fix clear_refs_write() input sanity check
From: Vincent Li <macli@brc.ubc.ca>

Andrew Morton pointed out similar string hacking and obfuscated check for
zero-length input at the end of the function, David Rientjes suggested to
use strict_strtol to replace simple_strtol, this patch cover above
suggestions, add removing of leading and trailing whitespace from user
input.  It does not change function behavious.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check
+++ a/fs/proc/task_mmu.c
@@ -473,21 +473,20 @@ static ssize_t clear_refs_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
+	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	long type;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	type = simple_strtol(buffer, &end, 0);
+	if (strict_strtol(strstrip(buffer), 10, &type))
+		return -EINVAL;
 	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -523,9 +522,8 @@ static ssize_t clear_refs_write(struct f
 		mmput(mm);
 	}
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 const struct file_operations proc_clear_refs_operations = {
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

mm-count-only-reclaimable-lru-pages-v2.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch

