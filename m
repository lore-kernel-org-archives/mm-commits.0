From: akpm@linux-foundation.org
Subject: + proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
 added to -mm tree
Date: Mon, 20 Nov 2017 14:18:11 -0800
Message-ID: <5a1354a3.klvgC0hS65scMa/R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdKTWSM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 17:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: don't use READ_ONCE/WRITE_ONCE for /proc/*/fail-nth
has been added to the -mm tree.  Its filename is
     proc-dont-use-read_once-write_once-for-proc-fail-nth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-dont-use-read_once-write_once-for-proc-fail-nth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1371,7 +1371,7 @@ static ssize_t proc_fail_nth_write(struc
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
-	WRITE_ONCE(task->fail_nth, n);
+	task->fail_nth = n;
 	put_task_struct(task);
 
 	return count;
@@ -1387,8 +1387,7 @@ static ssize_t proc_fail_nth_read(struct
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

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
seq_file-delete-small-value-optimization.patch

