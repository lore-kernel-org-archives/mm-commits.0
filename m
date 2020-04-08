From: akpm@linux-foundation.org
Subject: [merged] proc-speed-up-proc-statm.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 19:00:13 -0700
Message-ID: <20200408020013.hi89ZJLQ_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgDHCAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: speed up /proc/*/statm
has been removed from the -mm tree.  Its filename was
     proc-speed-up-proc-statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: speed up /proc/*/statm

top(1) reads all /proc/*/statm files but kernel threads will always have
zeros.  Print those zeroes directly without going through
seq_put_decimal_ull().

Speed up reading /proc/2/statm (which is kthreadd) is like 3%.

My system has more kernel threads than normal processes after booting KDE.

Link: http://lkml.kernel.org/r/20200307154435.GA2788@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/fs/proc/array.c~proc-speed-up-proc-statm
+++ a/fs/proc/array.c
@@ -635,28 +635,35 @@ int proc_tgid_stat(struct seq_file *m, s
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
-	unsigned long size = 0, resident = 0, shared = 0, text = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
 
 	if (mm) {
+		unsigned long size;
+		unsigned long resident = 0;
+		unsigned long shared = 0;
+		unsigned long text = 0;
+		unsigned long data = 0;
+
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
-	}
-	/*
-	 * For quick read, open code by putting numbers directly
-	 * expected format is
-	 * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
-	 *               size, resident, shared, text, data);
-	 */
-	seq_put_decimal_ull(m, "", size);
-	seq_put_decimal_ull(m, " ", resident);
-	seq_put_decimal_ull(m, " ", shared);
-	seq_put_decimal_ull(m, " ", text);
-	seq_put_decimal_ull(m, " ", 0);
-	seq_put_decimal_ull(m, " ", data);
-	seq_put_decimal_ull(m, " ", 0);
-	seq_putc(m, '\n');
 
+		/*
+		 * For quick read, open code by putting numbers directly
+		 * expected format is
+		 * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+		 *               size, resident, shared, text, data);
+		 */
+		seq_put_decimal_ull(m, "", size);
+		seq_put_decimal_ull(m, " ", resident);
+		seq_put_decimal_ull(m, " ", shared);
+		seq_put_decimal_ull(m, " ", text);
+		seq_put_decimal_ull(m, " ", 0);
+		seq_put_decimal_ull(m, " ", data);
+		seq_put_decimal_ull(m, " ", 0);
+		seq_putc(m, '\n');
+	} else {
+		seq_write(m, "0 0 0 0 0 0 0\n", 14);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
