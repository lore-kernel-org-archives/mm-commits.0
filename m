From: akpm@linux-foundation.org
Subject: [merged]
 proc-convert-proc-pid-oom_score-to-seq_file-interface.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:10 -0700
Message-ID: <53ea6d9a.9ZGS6pecdzWgyhWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:51417 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaHLTkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:10 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670049pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/oom_score to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-oom_score-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/oom_score to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-oom_score-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-oom_score-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -411,7 +411,8 @@ static const struct file_operations proc
 };
 #endif
 
-static int proc_oom_score(struct task_struct *task, char *buffer)
+static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
@@ -421,7 +422,7 @@ static int proc_oom_score(struct task_st
 		points = oom_badness(task, NULL, NULL, totalpages) *
 						1000 / totalpages;
 	read_unlock(&tasklist_lock);
-	return sprintf(buffer, "%lu\n", points);
+	return seq_printf(m, "%lu\n", points);
 }
 
 struct limit_names {
@@ -2616,7 +2617,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score",  S_IRUGO, proc_oom_score),
+	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
@@ -2954,7 +2955,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score", S_IRUGO, proc_oom_score),
+	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

