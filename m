From: akpm@linux-foundation.org
Subject: + shrink-struct-task_structoomkilladj.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:55:25 -0700
Message-ID: <200708152155.l7FLtPH0016988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbXHOVzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     Shrink struct task_struct::oomkilladj
has been added to the -mm tree.  Its filename is
     shrink-struct-task_structoomkilladj.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Shrink struct task_struct::oomkilladj
From: Alexey Dobriyan <adobriyan@gmail.com>

oomkilladj is int, but values which can be assigned to it are -17, [-16,
15], thus fitting into s8.

While patch itself doesn't help in making task_struct smaller, because of
natural alignment of ->link_count, it will make picture clearer wrt futher
task_struct reduction patches.  My plan is to move ->fpu_counter and
->oomkilladj after ->ioprio filling hole on i386 and x86_64.  But that's
for later, because bloated distro configs need looking at as well.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~shrink-struct-task_structoomkilladj include/linux/sched.h
--- a/include/linux/sched.h~shrink-struct-task_structoomkilladj
+++ a/include/linux/sched.h
@@ -1052,7 +1052,7 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
-	int oomkilladj; /* OOM kill score adjustment (bit shift). */
+	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
shrink-struct-task_structoomkilladj.patch
revert-faster-ext2_clear_inode.patch
