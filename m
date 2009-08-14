From: akpm@linux-foundation.org
Subject: + fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch added to -mm tree
Date: Fri, 14 Aug 2009 15:40:06 -0700
Message-ID: <200908142240.n7EMe7ew030818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbZHNWlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 18:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca


The patch titled
     fs/proc/base.c: fix proc_fault_inject_write() input sanity check
has been added to the -mm tree.  Its filename is
     fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

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
Subject: fs/proc/base.c: fix proc_fault_inject_write() input sanity check
From: Vincent Li <macli@brc.ubc.ca>

Remove obfuscated zero-length input check and return -EINVAL instead of
-EIO error to make the error message clear to user.  Add whitespace
stripping.  No functionality changes.

The old code:

echo  1  > /proc/pid/make-it-fail (ok)
echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Input/output error)

The new code:

echo  1  > /proc/pid/make-it-fail (ok)
echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Invalid argument)

This patch is conservative in changes to not breaking existing
scripts/applications.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check
+++ a/fs/proc/base.c
@@ -1169,17 +1169,16 @@ static ssize_t proc_fault_inject_write(s
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	make_it_fail = simple_strtol(buffer, &end, 0);
-	if (*end == '\n')
-		end++;
+	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
+	if (*end)
+		return -EINVAL;
 	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 	task->make_it_fail = make_it_fail;
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_fault_inject_operations = {
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
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

