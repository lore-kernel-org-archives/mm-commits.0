From: akpm@linux-foundation.org
Subject: [merged] proc-convert-proc-pid-wchan-to-seq_file-interface.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:06 -0700
Message-ID: <53ea6d96.94qV5w/QvWLVBUTO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39210 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaHLTkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:07 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so472509qcx.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/wchan to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-wchan-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/wchan to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-wchan-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-wchan-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -234,7 +234,8 @@ static int proc_pid_auxv(struct seq_file
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
  * Returns the resolved symbol.  If that fails, simply return the address.
  */
-static int proc_pid_wchan(struct task_struct *task, char *buffer)
+static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
@@ -245,9 +246,9 @@ static int proc_pid_wchan(struct task_st
 		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			return 0;
 		else
-			return sprintf(buffer, "%lu", wchan);
+			return seq_printf(m, "%lu", wchan);
 	else
-		return sprintf(buffer, "%s", symname);
+		return seq_printf(m, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
@@ -2597,7 +2598,7 @@ static const struct pid_entry tgid_base_
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",      S_IRUGO, proc_pid_wchan),
+	ONE("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
@@ -2935,7 +2936,7 @@ static const struct pid_entry tid_base_s
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",     S_IRUGO, proc_pid_wchan),
+	ONE("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

