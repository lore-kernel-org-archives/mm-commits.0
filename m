From: akpm@osdl.org
Subject: + ifdef-rchar-wchar-syscr-syscw-from-task_struct.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:59:13 -0800
Message-ID: <200701310059.l0V0xDvJ003163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXAaA7Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:59:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, balbir@in.ibm.com, jlan@engr.sgi.com


The patch titled
     ifdef ->rchar, ->wchar, ->syscr, ->syscw from task_struct
has been added to the -mm tree.  Its filename is
     ifdef-rchar-wchar-syscr-syscw-from-task_struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ifdef ->rchar, ->wchar, ->syscr, ->syscw from task_struct
From: Alexey Dobriyan <adobriyan@gmail.com>

They are fat: 4x8 bytes in task_struct.
They are uncoditionally updated in every fork, read, write and sendfile.
They are used only if you have some "extended acct fields feature".

And please, please, please, read(2) knows about bytes, not characters,
why it is called "rchar"?

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c        |    4 ++++
 fs/read_write.c       |   24 ++++++++++++------------
 include/linux/sched.h |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c         |    2 ++
 4 files changed, 58 insertions(+), 12 deletions(-)

diff -puN fs/proc/base.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct fs/proc/base.c
--- a/fs/proc/base.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct
+++ a/fs/proc/base.c
@@ -1810,17 +1810,21 @@ static int proc_base_fill_cache(struct f
 static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer,
+#ifdef CONFIG_TASK_XACCT
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
 			"syscw: %llu\n"
+#endif
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
+#ifdef CONFIG_TASK_XACCT
 			(unsigned long long)task->rchar,
 			(unsigned long long)task->wchar,
 			(unsigned long long)task->syscr,
 			(unsigned long long)task->syscw,
+#endif
 			(unsigned long long)task->ioac.read_bytes,
 			(unsigned long long)task->ioac.write_bytes,
 			(unsigned long long)task->ioac.cancelled_write_bytes);
diff -puN fs/read_write.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct fs/read_write.c
--- a/fs/read_write.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct
+++ a/fs/read_write.c
@@ -274,9 +274,9 @@ ssize_t vfs_read(struct file *file, char
 				ret = do_sync_read(file, buf, count, pos);
 			if (ret > 0) {
 				fsnotify_access(file->f_path.dentry);
-				current->rchar += ret;
+				add_rchar(current, ret);
 			}
-			current->syscr++;
+			inc_syscr(current);
 		}
 	}
 
@@ -332,9 +332,9 @@ ssize_t vfs_write(struct file *file, con
 				ret = do_sync_write(file, buf, count, pos);
 			if (ret > 0) {
 				fsnotify_modify(file->f_path.dentry);
-				current->wchar += ret;
+				add_wchar(current, ret);
 			}
-			current->syscw++;
+			inc_syscw(current);
 		}
 	}
 
@@ -675,8 +675,8 @@ sys_readv(unsigned long fd, const struct
 	}
 
 	if (ret > 0)
-		current->rchar += ret;
-	current->syscr++;
+		add_rchar(current, ret);
+	inc_syscr(current);
 	return ret;
 }
 
@@ -696,8 +696,8 @@ sys_writev(unsigned long fd, const struc
 	}
 
 	if (ret > 0)
-		current->wchar += ret;
-	current->syscw++;
+		add_wchar(current, ret);
+	inc_syscw(current);
 	return ret;
 }
 
@@ -779,12 +779,12 @@ static ssize_t do_sendfile(int out_fd, i
 	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
 
 	if (retval > 0) {
-		current->rchar += retval;
-		current->wchar += retval;
+		add_rchar(current, retval);
+		add_wchar(current, retval);
 	}
-	current->syscr++;
-	current->syscw++;
 
+	inc_syscr(current);
+	inc_syscw(current);
 	if (*ppos > max)
 		retval = -EOVERFLOW;
 
diff -puN include/linux/sched.h~ifdef-rchar-wchar-syscr-syscw-from-task_struct include/linux/sched.h
--- a/include/linux/sched.h~ifdef-rchar-wchar-syscr-syscw-from-task_struct
+++ a/include/linux/sched.h
@@ -1011,8 +1011,10 @@ struct task_struct {
  * to a stack based synchronous wait) if its doing sync IO.
  */
 	wait_queue_t *io_wait;
+#ifdef CONFIG_TASK_XACCT
 /* i/o counters(bytes read/written, #syscalls */
 	u64 rchar, wchar, syscr, syscw;
+#endif
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
@@ -1647,6 +1649,44 @@ extern int sched_create_sysfs_power_savi
 
 extern void normalize_rt_tasks(void);
 
+#ifdef CONFIG_TASK_XACCT
+static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
+{
+	tsk->rchar += amt;
+}
+
+static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
+{
+	tsk->wchar += amt;
+}
+
+static inline void inc_syscr(struct task_struct *tsk)
+{
+	tsk->syscr++;
+}
+
+static inline void inc_syscw(struct task_struct *tsk)
+{
+	tsk->syscw++;
+}
+#else
+static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
+{
+}
+
+static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
+{
+}
+
+static inline void inc_syscr(struct task_struct *tsk)
+{
+}
+
+static inline void inc_syscw(struct task_struct *tsk)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
diff -puN kernel/fork.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct kernel/fork.c
--- a/kernel/fork.c~ifdef-rchar-wchar-syscr-syscw-from-task_struct
+++ a/kernel/fork.c
@@ -1034,10 +1034,12 @@ static struct task_struct *copy_process(
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
  	p->sched_time = 0;
+#ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */
 	p->wchar = 0;		/* I/O counter: bytes written */
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
+#endif
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
proc-remove-useless-and-buggy-nlink-settings.patch
seq_file-conversion-coda.patch
seq_file-conversion-toshibac.patch
move-task_xacct-task_io_accounting-up-in-menus.patch
ifdef-rchar-wchar-syscr-syscw-from-task_struct.patch
recognize-video=gx1fb-option.patch
