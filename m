From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 095/166] proc: speed up /proc/*/statm
Date: Mon, 06 Apr 2020 20:09:05 -0700
Message-ID: <20200407030905.mtqs9G2wj%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgDGDJG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:09:06 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
