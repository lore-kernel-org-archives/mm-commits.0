From: akpm@linux-foundation.org
Subject: [merged]
 proc-convert-proc-pid-hardwall-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:14 -0700
Message-ID: <53ea6d9e.y0ASYhKiDe3P2Igh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:64400 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaHLTkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:15 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1068157igd.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/hardwall to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-hardwall-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/hardwall to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/hardwall.h |    2 +-
 arch/tile/kernel/hardwall.c      |    6 +++---
 fs/proc/base.c                   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/tile/include/asm/hardwall.h~proc-convert-proc-pid-hardwall-to-seq_file-interface arch/tile/include/asm/hardwall.h
--- a/arch/tile/include/asm/hardwall.h~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/arch/tile/include/asm/hardwall.h
@@ -23,7 +23,7 @@
 struct proc_dir_entry;
 #ifdef CONFIG_HARDWALL
 void proc_tile_hardwall_init(struct proc_dir_entry *root);
-int proc_pid_hardwall(struct task_struct *task, char *buffer);
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 #else
 static inline void proc_tile_hardwall_init(struct proc_dir_entry *root) {}
 #endif
diff -puN arch/tile/kernel/hardwall.c~proc-convert-proc-pid-hardwall-to-seq_file-interface arch/tile/kernel/hardwall.c
--- a/arch/tile/kernel/hardwall.c~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/arch/tile/kernel/hardwall.c
@@ -947,15 +947,15 @@ static void hardwall_remove_proc(struct
 	remove_proc_entry(buf, info->type->proc_dir);
 }
 
-int proc_pid_hardwall(struct task_struct *task, char *buffer)
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns,
+		      struct pid *pid, struct task_struct *task)
 {
 	int i;
 	int n = 0;
 	for (i = 0; i < HARDWALL_TYPES; ++i) {
 		struct hardwall_info *info = task->thread.hardwall[i].info;
 		if (info)
-			n += sprintf(&buffer[n], "%s: %d\n",
-				     info->type->name, info->id);
+			seq_printf(m, "%s: %d\n", info->type->name, info->id);
 	}
 	return n;
 }
diff -puN fs/proc/base.c~proc-convert-proc-pid-hardwall-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -2636,7 +2636,7 @@ static const struct pid_entry tgid_base_
 	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
@@ -2971,7 +2971,7 @@ static const struct pid_entry tid_base_s
 	ONE("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

