From: akpm@linux-foundation.org
Subject: [patch 016/114] proc: don't use READ_ONCE/WRITE_ONCE for
 /proc/*/fail-nth
Date: Tue, 06 Feb 2018 15:36:55 -0800
Message-ID: <20180206233655.GsuqH6QAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54324 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbeBFXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
