From: akpm@linux-foundation.org
Subject: [merged]
 proc-convert-proc-pid-cmdline-to-seq_file-interface.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:40:04 -0700
Message-ID: <53ea6d94.c0rhDNWop0yIOOEY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:50029 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaHLTkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:04 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2670019pab.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/cmdline to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-cmdline-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/cmdline to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-cmdline-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-cmdline-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -200,9 +200,16 @@ static int proc_root_link(struct dentry
 	return result;
 }
 
-static int proc_pid_cmdline(struct task_struct *task, char *buffer)
+static int proc_pid_cmdline(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
-	return get_cmdline(task, buffer, PAGE_SIZE);
+	/*
+	 * Rely on struct seq_operations::show() being called once
+	 * per internal buffer allocation. See single_open(), traverse().
+	 */
+	BUG_ON(m->size < PAGE_SIZE);
+	m->count += get_cmdline(task, m->buf, PAGE_SIZE);
+	return 0;
 }
 
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
@@ -2567,7 +2574,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2903,7 +2910,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

