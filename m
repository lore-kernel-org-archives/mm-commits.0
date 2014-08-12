From: akpm@linux-foundation.org
Subject: [merged] proc-convert-proc-pid-auxv-to-seq_file-interface.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:58 -0700
Message-ID: <53ea6d8e.1SA1A6kuxjEskRtG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:43025 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaHLTj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:59 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1914861oac.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/auxv to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-auxv-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/auxv to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-auxv-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-auxv-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -205,22 +205,20 @@ static int proc_pid_cmdline(struct task_
 	return get_cmdline(task, buffer, PAGE_SIZE);
 }
 
-static int proc_pid_auxv(struct task_struct *task, char *buffer)
+static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
+			 struct pid *pid, struct task_struct *task)
 {
 	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
-	int res = PTR_ERR(mm);
 	if (mm && !IS_ERR(mm)) {
 		unsigned int nwords = 0;
 		do {
 			nwords += 2;
 		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
-		res = nwords * sizeof(mm->saved_auxv[0]);
-		if (res > PAGE_SIZE)
-			res = PAGE_SIZE;
-		memcpy(buffer, mm->saved_auxv, res);
+		seq_write(m, mm->saved_auxv, nwords * sizeof(mm->saved_auxv[0]));
 		mmput(mm);
-	}
-	return res;
+		return 0;
+	} else
+		return PTR_ERR(mm);
 }
 
 
@@ -2557,7 +2555,7 @@ static const struct pid_entry tgid_base_
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
-	INF("auxv",       S_IRUSR, proc_pid_auxv),
+	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
@@ -2896,7 +2894,7 @@ static const struct pid_entry tid_base_s
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
-	INF("auxv",      S_IRUSR, proc_pid_auxv),
+	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

