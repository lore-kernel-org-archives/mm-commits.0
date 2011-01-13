From: akpm@linux-foundation.org
Subject: [merged] proc-use-seq_puts-seq_putc-where-possible.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:33 -0800
Message-ID: <201101132011.p0DKBESd030136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933755Ab1AMUUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: use seq_puts()/seq_putc() where possible
has been removed from the -mm tree.  Its filename was
     proc-use-seq_puts-seq_putc-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: use seq_puts()/seq_putc() where possible
From: Alexey Dobriyan <adobriyan@gmail.com>

For string without format specifiers, use seq_puts().
For seq_printf("\n"), use seq_putc('\n').

   text	   data	    bss	    dec	    hex	filename
  61866	    488	    112	  62466	   f402	fs/proc/proc.o
  61729	    488	    112	  62329	   f379	fs/proc/proc.o
  ----------------------------------------------------
  			   -139

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |   22 +++++++++++-----------
 fs/proc/base.c     |    2 +-
 fs/proc/devices.c  |    4 ++--
 fs/proc/proc_tty.c |   26 +++++++++++++-------------
 fs/proc/softirqs.c |    6 +++---
 fs/proc/stat.c     |    2 +-
 6 files changed, 31 insertions(+), 31 deletions(-)

diff -puN fs/proc/array.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/array.c
--- a/fs/proc/array.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/array.c
@@ -95,7 +95,7 @@ static inline void task_name(struct seq_
 
 	get_task_comm(tcomm, p);
 
-	seq_printf(m, "Name:\t");
+	seq_puts(m, "Name:\t");
 	end = m->buf + m->size;
 	buf = m->buf + m->count;
 	name = tcomm;
@@ -122,7 +122,7 @@ static inline void task_name(struct seq_
 		buf++;
 	}
 	m->count = buf - m->buf;
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 /*
@@ -208,7 +208,7 @@ static inline void task_state(struct seq
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_cred(cred);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void render_sigset_t(struct seq_file *m, const char *header,
@@ -216,7 +216,7 @@ static void render_sigset_t(struct seq_f
 {
 	int i;
 
-	seq_printf(m, "%s", header);
+	seq_puts(m, header);
 
 	i = _NSIG;
 	do {
@@ -230,7 +230,7 @@ static void render_sigset_t(struct seq_f
 		seq_printf(m, "%x", x);
 	} while (i >= 4);
 
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
@@ -291,12 +291,12 @@ static void render_cap_t(struct seq_file
 {
 	unsigned __capi;
 
-	seq_printf(m, "%s", header);
+	seq_puts(m, header);
 	CAP_FOR_EACH_U32(__capi) {
 		seq_printf(m, "%08x",
 			   a->cap[(_KERNEL_CAPABILITY_U32S-1) - __capi]);
 	}
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
@@ -329,12 +329,12 @@ static inline void task_context_switch_c
 
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_printf(m, "Cpus_allowed:\t");
+	seq_puts(m, "Cpus_allowed:\t");
 	seq_cpumask(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
-	seq_printf(m, "Cpus_allowed_list:\t");
+	seq_putc(m, '\n');
+	seq_puts(m, "Cpus_allowed_list:\t");
 	seq_cpumask_list(m, &task->cpus_allowed);
-	seq_printf(m, "\n");
+	seq_putc(m, '\n');
 }
 
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
diff -puN fs/proc/base.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/base.c
--- a/fs/proc/base.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/base.c
@@ -386,7 +386,7 @@ static int lstats_show_proc(struct seq_f
 					break;
 				seq_printf(m, " %ps", (void *)bt);
 			}
-			seq_printf(m, "\n");
+			seq_putc(m, '\n');
 		}
 
 	}
diff -puN fs/proc/devices.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/devices.c
--- a/fs/proc/devices.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/devices.c
@@ -9,14 +9,14 @@ static int devinfo_show(struct seq_file 
 
 	if (i < CHRDEV_MAJOR_HASH_SIZE) {
 		if (i == 0)
-			seq_printf(f, "Character devices:\n");
+			seq_puts(f, "Character devices:\n");
 		chrdev_show(f, i);
 	}
 #ifdef CONFIG_BLOCK
 	else {
 		i -= CHRDEV_MAJOR_HASH_SIZE;
 		if (i == 0)
-			seq_printf(f, "\nBlock devices:\n");
+			seq_puts(f, "\nBlock devices:\n");
 		blkdev_show(f, i);
 	}
 #endif
diff -puN fs/proc/proc_tty.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/proc_tty.c
@@ -36,27 +36,27 @@ static void show_tty_range(struct seq_fi
 	}
 	switch (p->type) {
 	case TTY_DRIVER_TYPE_SYSTEM:
-		seq_printf(m, "system");
+		seq_puts(m, "system");
 		if (p->subtype == SYSTEM_TYPE_TTY)
-			seq_printf(m, ":/dev/tty");
+			seq_puts(m, ":/dev/tty");
 		else if (p->subtype == SYSTEM_TYPE_SYSCONS)
-			seq_printf(m, ":console");
+			seq_puts(m, ":console");
 		else if (p->subtype == SYSTEM_TYPE_CONSOLE)
-			seq_printf(m, ":vtmaster");
+			seq_puts(m, ":vtmaster");
 		break;
 	case TTY_DRIVER_TYPE_CONSOLE:
-		seq_printf(m, "console");
+		seq_puts(m, "console");
 		break;
 	case TTY_DRIVER_TYPE_SERIAL:
-		seq_printf(m, "serial");
+		seq_puts(m, "serial");
 		break;
 	case TTY_DRIVER_TYPE_PTY:
 		if (p->subtype == PTY_TYPE_MASTER)
-			seq_printf(m, "pty:master");
+			seq_puts(m, "pty:master");
 		else if (p->subtype == PTY_TYPE_SLAVE)
-			seq_printf(m, "pty:slave");
+			seq_puts(m, "pty:slave");
 		else
-			seq_printf(m, "pty");
+			seq_puts(m, "pty");
 		break;
 	default:
 		seq_printf(m, "type:%d.%d", p->type, p->subtype);
@@ -74,19 +74,19 @@ static int show_tty_driver(struct seq_fi
 		/* pseudo-drivers first */
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/tty", "tty");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 0);
-		seq_printf(m, "system:/dev/tty\n");
+		seq_puts(m, "system:/dev/tty\n");
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/console", "console");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 1);
-		seq_printf(m, "system:console\n");
+		seq_puts(m, "system:console\n");
 #ifdef CONFIG_UNIX98_PTYS
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/ptmx", "ptmx");
 		seq_printf(m, "%3d %7d ", TTYAUX_MAJOR, 2);
-		seq_printf(m, "system\n");
+		seq_puts(m, "system\n");
 #endif
 #ifdef CONFIG_VT
 		seq_printf(m, "%-20s /dev/%-8s ", "/dev/vc/0", "vc/0");
 		seq_printf(m, "%3d %7d ", TTY_MAJOR, 0);
-		seq_printf(m, "system:vtmaster\n");
+		seq_puts(m, "system:vtmaster\n");
 #endif
 	}
 
diff -puN fs/proc/softirqs.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/softirqs.c
--- a/fs/proc/softirqs.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/softirqs.c
@@ -10,16 +10,16 @@ static int show_softirqs(struct seq_file
 {
 	int i, j;
 
-	seq_printf(p, "                    ");
+	seq_puts(p, "                    ");
 	for_each_possible_cpu(i)
 		seq_printf(p, "CPU%-8d", i);
-	seq_printf(p, "\n");
+	seq_putc(p, '\n');
 
 	for (i = 0; i < NR_SOFTIRQS; i++) {
 		seq_printf(p, "%12s:", softirq_to_name[i]);
 		for_each_possible_cpu(j)
 			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
-		seq_printf(p, "\n");
+		seq_putc(p, '\n');
 	}
 	return 0;
 }
diff -puN fs/proc/stat.c~proc-use-seq_puts-seq_putc-where-possible fs/proc/stat.c
--- a/fs/proc/stat.c~proc-use-seq_puts-seq_putc-where-possible
+++ a/fs/proc/stat.c
@@ -126,7 +126,7 @@ static int show_stat(struct seq_file *p,
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
 		seq_printf(p, " %u", per_softirq_sums[i]);
-	seq_printf(p, "\n");
+	seq_putc(p, '\n');
 
 	return 0;
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

