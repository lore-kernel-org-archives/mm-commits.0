From: akpm@linux-foundation.org
Subject: [merged]
 proc-dont-use-read_once-write_once-for-proc-fail-nth.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:55:50 -0800
Message-ID: <20180207195550.2flII935q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbeBGTzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: don't use READ_ONCE/WRITE_ONCE for /proc/*/fail-nth
has been removed from the -mm tree.  Its filename was
     proc-dont-use-read_once-write_once-for-proc-fail-nth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: don't use READ_ONCE/WRITE_ONCE for /proc/*/fail-nth

READ_ONCE and WRITE_ONCE are useless when there is only one read/write
is being made.

Link: http://lkml.kernel.org/r/20171120204033.GA9446@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-dont-use-read_once-write_once-for-proc-fail-nth fs/proc/base.c
--- a/fs/proc/base.c~proc-dont-use-read_once-write_once-for-proc-fail-nth
+++ a/fs/proc/base.c
@@ -1370,7 +1370,7 @@ static ssize_t proc_fail_nth_write(struc
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	WRITE_ONCE(task->fail_nth, n);
+	task->fail_nth = n;
 	put_task_struct(task);
 
 	return count;
@@ -1386,8 +1386,7 @@ static ssize_t proc_fail_nth_read(struct
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	len = snprintf(numbuf, sizeof(numbuf), "%u\n",
-			READ_ONCE(task->fail_nth));
+	len = snprintf(numbuf, sizeof(numbuf), "%u\n", task->fail_nth);
 	len = simple_read_from_buffer(buf, count, ppos, numbuf, len);
 	put_task_struct(task);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

