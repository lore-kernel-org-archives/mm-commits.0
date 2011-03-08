From: akpm@linux-foundation.org
Subject: + procfs-fix-some-wrong-error-code-usage.patch added to -mm tree
Date: Mon, 07 Mar 2011 16:24:43 -0800
Message-ID: <201103080024.p280OhDm004496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab1CHAYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 19:24:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bookjovi@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     procfs: fix some wrong error code usage
has been added to the -mm tree.  Its filename is
     procfs-fix-some-wrong-error-code-usage.patch

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

linux-next.patch
procfs-fix-some-wrong-error-code-usage.patch

