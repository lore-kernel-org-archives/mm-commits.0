From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-some-wrong-error-code-usage.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:41 -0700
Message-ID: <201103250725.p2P7PZ0b026038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933717Ab1CYHZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     procfs: fix some wrong error code usage
has been removed from the -mm tree.  Its filename was
     procfs-fix-some-wrong-error-code-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: fix some wrong error code usage
From: Jovi Zhang <bookjovi@gmail.com>

[root@wei 1]# cat /proc/1/mem
cat: /proc/1/mem: No such process

error code -ESRCH is wrong in this situation.  Return -EPERM instead.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-fix-some-wrong-error-code-usage fs/proc/base.c
--- a/fs/proc/base.c~procfs-fix-some-wrong-error-code-usage
+++ a/fs/proc/base.c
@@ -775,7 +775,8 @@ static ssize_t mem_read(struct file * fi
 	if (!task)
 		goto out_no_task;
 
-	if (check_mem_permission(task))
+	ret = check_mem_permission(task);
+	if (ret)
 		goto out;
 
 	ret = -ENOMEM;
@@ -849,7 +850,8 @@ static ssize_t mem_write(struct file * f
 	if (!task)
 		goto out_no_task;
 
-	if (check_mem_permission(task))
+	copied = check_mem_permission(task);
+	if (copied)
 		goto out;
 
 	copied = -ENOMEM;
@@ -921,6 +923,7 @@ static ssize_t environ_read(struct file 
 	if (!task)
 		goto out_no_task;
 
+	ret = -EPERM;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out;
 
_

Patches currently in -mm which might be from bookjovi@gmail.com are

origin.patch
linux-next.patch

