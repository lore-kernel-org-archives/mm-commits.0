From: akpm@linux-foundation.org
Subject: [merged] fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:46 -0700
Message-ID: <200909231956.n8NJuki3005581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbZIWT5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, mm-commits@vger.kernel.org


The patch titled
     fs/proc/base.c: fix proc_fault_inject_write() input sanity check
has been removed from the -mm tree.  Its filename was
     fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1187,17 +1187,16 @@ static ssize_t proc_fault_inject_write(s
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

origin.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch

