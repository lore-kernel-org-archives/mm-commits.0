From: akpm@linux-foundation.org
Subject: + fault-inject-make-fail-nth-read-write-interface-symmetric.patch added to -mm tree
Date: Thu, 06 Apr 2017 15:56:42 -0700
Message-ID: <58e6c7aa.N8+Im8gcaEGtlnLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdDFW4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 18:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: make fail-nth read/write interface symmetric
has been added to the -mm tree.  Its filename is
     fault-inject-make-fail-nth-read-write-interface-symmetric.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-make-fail-nth-read-write-interface-symmetric.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-make-fail-nth-read-write-interface-symmetric.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: fault-inject: make fail-nth read/write interface symmetric

The read interface for fail-nth looks a bit odd.  Read from this file
returns "NYYYY..." or "YYYYY..." (this makes me surprise when cat this
file).  Because there is no EOF condition.  The first character indicates
current->fail_nth is zero or not, and then current->fail_nth is reset to
zero.

Just returning task->fail_nth value is more natural to understand.

Link: http://lkml.kernel.org/r/1491490561-10485-4-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fault-injection/fault-injection.txt |   13 ++++++-----
 fs/proc/base.c                                    |   14 +++++-------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN Documentation/fault-injection/fault-injection.txt~fault-inject-make-fail-nth-read-write-interface-symmetric Documentation/fault-injection/fault-injection.txt
--- a/Documentation/fault-injection/fault-injection.txt~fault-inject-make-fail-nth-read-write-interface-symmetric
+++ a/Documentation/fault-injection/fault-injection.txt
@@ -139,9 +139,9 @@ o proc entries
 - /proc/self/task/<current-tid>/fail-nth:
 
 	Write to this file of integer N makes N-th call in the task fail.
-	Read from this file returns a single char 'Y' or 'N'
-	that says if the fault setup with a previous write to this file was
-	injected or not, and disables the fault if it wasn't yet injected.
+	Read from this file returns a integer value. A value of '0' indicates
+	that the fault setup with a previous write to this file was injected.
+	A positive integer N indicates that the fault wasn't yet injected.
 	Note that this file enables all types of faults (slab, futex, etc).
 	This setting takes precedence over all other generic debugfs settings
 	like probability, interval, times, etc. But per-capability settings
@@ -325,13 +325,14 @@ int main()
 		write(fail_nth, buf, strlen(buf));
 		res = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
 		err = errno;
-		read(fail_nth, buf, 1);
+		pread(fail_nth, buf, sizeof(buf), 0);
 		if (res == 0) {
 			close(fds[0]);
 			close(fds[1]);
 		}
-		printf("%d-th fault %c: res=%d/%d\n", i, buf[0], res, err);
-		if (buf[0] != 'Y')
+		printf("%d-th fault %c: res=%d/%d\n", i, atoi(buf) ? 'N' : 'Y',
+			res, err);
+		if (atoi(buf))
 			break;
 	}
 	return 0;
diff -puN fs/proc/base.c~fault-inject-make-fail-nth-read-write-interface-symmetric fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-make-fail-nth-read-write-interface-symmetric
+++ a/fs/proc/base.c
@@ -1383,7 +1383,8 @@ static ssize_t proc_fail_nth_read(struct
 				  size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	int err;
+	char numbuf[PROC_NUMBUF];
+	ssize_t len;
 
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -1391,13 +1392,10 @@ static ssize_t proc_fail_nth_read(struct
 	put_task_struct(task);
 	if (task != current)
 		return -EPERM;
-	if (count < 1)
-		return -EINVAL;
-	err = put_user((char)(current->fail_nth ? 'N' : 'Y'), buf);
-	if (err)
-		return err;
-	current->fail_nth = 0;
-	return 1;
+	len = snprintf(numbuf, sizeof(numbuf), "%u\n", task->fail_nth);
+	len = simple_read_from_buffer(buf, count, ppos, numbuf, len);
+
+	return len;
 }
 
 static const struct file_operations proc_fail_nth_operations = {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
fault-inject-make-fail-nth-read-write-interface-symmetric.patch
fault-inject-simplify-access-check-for-fail-nth.patch
fault-inject-add-proc-pid-fail-nth.patch

