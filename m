From: akpm@linux-foundation.org
Subject: - rework-proc-locks-via-seq_files-and-seq_list-helpers.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:59:08 -0700
Message-ID: <200710051959.l95Jx8Gs022676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763580AbXJEUBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Rework /proc/locks via seq_files and seq_list helpers
has been removed from the -mm tree.  Its filename was
     rework-proc-locks-via-seq_files-and-seq_list-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Rework /proc/locks via seq_files and seq_list helpers
From: Pavel Emelyanov <xemul@openvz.org>

Currently /proc/locks is shown with a proc_read function, but its behavior
is rather complex as it has to manually handle current offset and buffer
length.  On the other hand, files that show objects from lists can be
easily reimplemented using the sequential files and the seq_list_XXX()
helpers.

This saves (as usually) 16 lines of code and more than 200 from
the .text section.

[akpm@linux-foundation.org: no externs in C]
[akpm@linux-foundation.org: warning fixes]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/locks.c~rework-proc-locks-via-seq_files-and-seq_list-helpers fs/locks.c
--- a/fs/locks.c~rework-proc-locks-via-seq_files-and-seq_list-helpers
+++ a/fs/locks.c
@@ -2066,134 +2066,114 @@ int vfs_cancel_lock(struct file *filp, s
 
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 
-static void lock_get_status(char* out, struct file_lock *fl, int id, char *pfx)
+#ifdef CONFIG_PROC_FS
+#include <linux/seq_file.h>
+
+static void lock_get_status(struct seq_file *f, struct file_lock *fl,
+							int id, char *pfx)
 {
 	struct inode *inode = NULL;
 
 	if (fl->fl_file != NULL)
 		inode = fl->fl_file->f_path.dentry->d_inode;
 
-	out += sprintf(out, "%d:%s ", id, pfx);
+	seq_printf(f, "%d:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
-		out += sprintf(out, "%6s %s ",
+		seq_printf(f, "%6s %s ",
 			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
 			     (inode == NULL) ? "*NOINODE*" :
 			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
 	} else if (IS_FLOCK(fl)) {
 		if (fl->fl_type & LOCK_MAND) {
-			out += sprintf(out, "FLOCK  MSNFS     ");
+			seq_printf(f, "FLOCK  MSNFS     ");
 		} else {
-			out += sprintf(out, "FLOCK  ADVISORY  ");
+			seq_printf(f, "FLOCK  ADVISORY  ");
 		}
 	} else if (IS_LEASE(fl)) {
-		out += sprintf(out, "LEASE  ");
+		seq_printf(f, "LEASE  ");
 		if (fl->fl_type & F_INPROGRESS)
-			out += sprintf(out, "BREAKING  ");
+			seq_printf(f, "BREAKING  ");
 		else if (fl->fl_file)
-			out += sprintf(out, "ACTIVE    ");
+			seq_printf(f, "ACTIVE    ");
 		else
-			out += sprintf(out, "BREAKER   ");
+			seq_printf(f, "BREAKER   ");
 	} else {
-		out += sprintf(out, "UNKNOWN UNKNOWN  ");
+		seq_printf(f, "UNKNOWN UNKNOWN  ");
 	}
 	if (fl->fl_type & LOCK_MAND) {
-		out += sprintf(out, "%s ",
+		seq_printf(f, "%s ",
 			       (fl->fl_type & LOCK_READ)
 			       ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
 			       : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
 	} else {
-		out += sprintf(out, "%s ",
+		seq_printf(f, "%s ",
 			       (fl->fl_type & F_INPROGRESS)
 			       ? (fl->fl_type & F_UNLCK) ? "UNLCK" : "READ "
 			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
 	}
 	if (inode) {
 #ifdef WE_CAN_BREAK_LSLK_NOW
-		out += sprintf(out, "%d %s:%ld ", fl->fl_pid,
+		seq_printf(f, "%d %s:%ld ", fl->fl_pid,
 				inode->i_sb->s_id, inode->i_ino);
 #else
 		/* userspace relies on this representation of dev_t ;-( */
-		out += sprintf(out, "%d %02x:%02x:%ld ", fl->fl_pid,
+		seq_printf(f, "%d %02x:%02x:%ld ", fl->fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 #endif
 	} else {
-		out += sprintf(out, "%d <none>:0 ", fl->fl_pid);
+		seq_printf(f, "%d <none>:0 ", fl->fl_pid);
 	}
 	if (IS_POSIX(fl)) {
 		if (fl->fl_end == OFFSET_MAX)
-			out += sprintf(out, "%Ld EOF\n", fl->fl_start);
+			seq_printf(f, "%Ld EOF\n", fl->fl_start);
 		else
-			out += sprintf(out, "%Ld %Ld\n", fl->fl_start,
-					fl->fl_end);
+			seq_printf(f, "%Ld %Ld\n", fl->fl_start, fl->fl_end);
 	} else {
-		out += sprintf(out, "0 EOF\n");
+		seq_printf(f, "0 EOF\n");
 	}
 }
 
-static void move_lock_status(char **p, off_t* pos, off_t offset)
+static int locks_show(struct seq_file *f, void *v)
 {
-	int len;
-	len = strlen(*p);
-	if(*pos >= offset) {
-		/* the complete line is valid */
-		*p += len;
-		*pos += len;
-		return;
-	}
-	if(*pos+len > offset) {
-		/* use the second part of the line */
-		int i = offset-*pos;
-		memmove(*p,*p+i,len-i);
-		*p += len-i;
-		*pos += len;
-		return;
-	}
-	/* discard the complete line */
-	*pos += len;
-}
+	struct file_lock *fl, *bfl;
 
-/**
- *	get_locks_status	-	reports lock usage in /proc/locks
- *	@buffer: address in userspace to write into
- *	@start: ?
- *	@offset: how far we are through the buffer
- *	@length: how much to read
- */
+	fl = list_entry(v, struct file_lock, fl_link);
 
-int get_locks_status(char *buffer, char **start, off_t offset, int length)
-{
-	struct file_lock *fl;
-	char *q = buffer;
-	off_t pos = 0;
-	int i = 0;
+	lock_get_status(f, fl, (long)f->private, "");
 
-	lock_kernel();
-	list_for_each_entry(fl, &file_lock_list, fl_link) {
-		struct file_lock *bfl;
+	list_for_each_entry(bfl, &fl->fl_block, fl_block)
+		lock_get_status(f, bfl, (long)f->private, " ->");
 
-		lock_get_status(q, fl, ++i, "");
-		move_lock_status(&q, &pos, offset);
+	f->private++;
+	return 0;
+}
 
-		if(pos >= offset+length)
-			goto done;
+static void *locks_start(struct seq_file *f, loff_t *pos)
+{
+	lock_kernel();
+	f->private = (void *)1;
+	return seq_list_start(&file_lock_list, *pos);
+}
 
-		list_for_each_entry(bfl, &fl->fl_block, fl_block) {
-			lock_get_status(q, bfl, i, " ->");
-			move_lock_status(&q, &pos, offset);
+static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &file_lock_list, pos);
+}
 
-			if(pos >= offset+length)
-				goto done;
-		}
-	}
-done:
+static void locks_stop(struct seq_file *f, void *v)
+{
 	unlock_kernel();
-	*start = buffer;
-	if(q-buffer < length)
-		return (q-buffer);
-	return length;
 }
 
+struct seq_operations locks_seq_operations = {
+	.start	= locks_start,
+	.next	= locks_next,
+	.stop	= locks_stop,
+	.show	= locks_show,
+};
+#endif
+
 /**
  *	lock_may_read - checks that the region is free of locks
  *	@inode: the inode that is being read
diff -puN fs/proc/proc_misc.c~rework-proc-locks-via-seq_files-and-seq_list-helpers fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~rework-proc-locks-via-seq_files-and-seq_list-helpers
+++ a/fs/proc/proc_misc.c
@@ -68,7 +68,6 @@ extern int get_stram_list(char *);
 extern int get_filesystem_list(char *);
 extern int get_exec_domain_list(char *);
 extern int get_dma_list(char *);
-extern int get_locks_status (char *, char **, off_t, int);
 
 static int proc_calc_metrics(char *page, char **start, off_t off,
 				 int count, int *eof, int len)
@@ -630,16 +629,18 @@ static int cmdline_read_proc(char *page,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
-static int locks_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
+static int locks_open(struct inode *inode, struct file *filp)
 {
-	int len = get_locks_status(page, start, off, count);
-
-	if (len < count)
-		*eof = 1;
-	return len;
+	return seq_open(filp, &locks_seq_operations);
 }
 
+static const struct file_operations proc_locks_operations = {
+	.open		= locks_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int execdomains_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
 {
@@ -782,7 +783,6 @@ void __init proc_misc_init(void)
 #endif
 		{"filesystems",	filesystems_read_proc},
 		{"cmdline",	cmdline_read_proc},
-		{"locks",	locks_read_proc},
 		{"execdomains",	execdomains_read_proc},
 		{NULL,}
 	};
@@ -800,6 +800,7 @@ void __init proc_misc_init(void)
 			entry->proc_fops = &proc_kmsg_operations;
 	}
 #endif
+	create_seq_entry("locks", 0, &proc_locks_operations);
 	create_seq_entry("devices", 0, &proc_devinfo_operations);
 	create_seq_entry("cpuinfo", 0, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
diff -puN include/linux/fs.h~rework-proc-locks-via-seq_files-and-seq_list-helpers include/linux/fs.h
--- a/include/linux/fs.h~rework-proc-locks-via-seq_files-and-seq_list-helpers
+++ a/include/linux/fs.h
@@ -944,6 +944,7 @@ extern int vfs_setlease(struct file *, l
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+extern struct seq_operations locks_seq_operations;
 
 struct fasync_struct {
 	int	magic;
_

Patches currently in -mm which might be from xemul@openvz.org are

make-initializer-for-statically-declared-krefs.patch
git-net.patch
git-nfsd.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
