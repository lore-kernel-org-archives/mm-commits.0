From: akpm@linux-foundation.org
Subject: + task-io-accounting-correctly-account-threads-io-statistics.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:38:25 -0700
Message-ID: <200807261938.m6QJcP37016050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYGZTii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, oleg@tv-sign.ru


The patch titled
     task IO accounting: correctly account threads IO statistics
has been added to the -mm tree.  Its filename is
     task-io-accounting-correctly-account-threads-io-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task IO accounting: correctly account threads IO statistics
From: Andrea Righi <righi.andrea@gmail.com>

Oleg Nesterov points out that we should check that the task is still alive
before we iterate over the threads.  This patch includes a fixup for this.

Also simplify do_io_accounting() implementation.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   56 ++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff -puN fs/proc/base.c~task-io-accounting-correctly-account-threads-io-statistics fs/proc/base.c
--- a/fs/proc/base.c~task-io-accounting-correctly-account-threads-io-statistics
+++ a/fs/proc/base.c
@@ -2406,35 +2406,18 @@ static int do_io_accounting(struct task_
 	u64 rchar, wchar, syscr, syscw;
 	struct task_io_accounting ioac;
 
-	if (!whole) {
-		rchar = task->rchar;
-		wchar = task->wchar;
-		syscr = task->syscr;
-		syscw = task->syscw;
-		memcpy(&ioac, &task->ioac, sizeof(ioac));
-	} else {
-		unsigned long flags;
-		struct task_struct *t = task;
-		rchar = wchar = syscr = syscw = 0;
-		memset(&ioac, 0, sizeof(ioac));
-
-		rcu_read_lock();
-		do {
-			rchar += t->rchar;
-			wchar += t->wchar;
-			syscr += t->syscr;
-			syscw += t->syscw;
+	rchar = task->rchar;
+	wchar = task->wchar;
+	syscr = task->syscr;
+	syscw = task->syscw;
+	memcpy(&ioac, &task->ioac, sizeof(ioac));
 
-			ioac.read_bytes += t->ioac.read_bytes;
-			ioac.write_bytes += t->ioac.write_bytes;
-			ioac.cancelled_write_bytes +=
-					t->ioac.cancelled_write_bytes;
-			t = next_thread(t);
-		} while (t != task);
-		rcu_read_unlock();
+	if (whole) {
+		unsigned long flags;
 
 		if (lock_task_sighand(task, &flags)) {
 			struct signal_struct *sig = task->signal;
+			struct task_struct *t = task;
 
 			rchar += sig->rchar;
 			wchar += sig->wchar;
@@ -2445,11 +2428,20 @@ static int do_io_accounting(struct task_
 			ioac.write_bytes += sig->ioac.write_bytes;
 			ioac.cancelled_write_bytes +=
 					sig->ioac.cancelled_write_bytes;
-
+			while_each_thread(task, t) {
+				rchar += t->rchar;
+				wchar += t->wchar;
+				syscr += t->syscr;
+				syscw += t->syscw;
+
+				ioac.read_bytes += t->ioac.read_bytes;
+				ioac.write_bytes += t->ioac.write_bytes;
+				ioac.cancelled_write_bytes +=
+					t->ioac.cancelled_write_bytes;
+			}
 			unlock_task_sighand(task, &flags);
 		}
 	}
-
 	return sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
@@ -2458,13 +2450,9 @@ static int do_io_accounting(struct task_
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			(unsigned long long)rchar,
-			(unsigned long long)wchar,
-			(unsigned long long)syscr,
-			(unsigned long long)syscw,
-			(unsigned long long)ioac.read_bytes,
-			(unsigned long long)ioac.write_bytes,
-			(unsigned long long)ioac.cancelled_write_bytes);
+			rchar, wchar, syscr, syscw,
+			ioac.read_bytes, ioac.write_bytes,
+			ioac.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch
task-io-accounting-correctly-account-threads-io-statistics.patch

