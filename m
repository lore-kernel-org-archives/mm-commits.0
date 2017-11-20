From: akpm@linux-foundation.org
Subject: [merged]
 pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size.patch removed
 from -mm tree
Date: Mon, 20 Nov 2017 13:25:16 -0800
Message-ID: <20171120212516.S1Ocl5ccT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbdKTVZR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, joe.lawrence@redhat.com, jpoimboe@redhat.com, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: pipe: add proc_dopipe_max_size() to safely assign pipe_max_size
has been removed from the -mm tree.  Its filename was
     pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: pipe: add proc_dopipe_max_size() to safely assign pipe_max_size

pipe_max_size is assigned directly via procfs sysctl:

  static struct ctl_table fs_table[] = {
          ...
          {
                  .procname       = "pipe-max-size",
                  .data           = &pipe_max_size,
                  .maxlen         = sizeof(int),
                  .mode           = 0644,
                  .proc_handler   = &pipe_proc_fn,
                  .extra1         = &pipe_min_size,
          },
          ...

  int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
                   size_t *lenp, loff_t *ppos)
  {
          ...
          ret = proc_dointvec_minmax(table, write, buf, lenp, ppos)
          ...

and then later rounded in-place a few statements later:

          ...
          pipe_max_size = round_pipe_size(pipe_max_size);
          ...

This leaves a window of time between initial assignment and rounding that
may be visible to other threads.  (For example, one thread sets a
non-rounded value to pipe_max_size while another reads its value.)

Similar reads of pipe_max_size are potentially racy:

  pipe.c :: alloc_pipe_info()
  pipe.c :: pipe_set_size()

Add a new proc_dopipe_max_size() that consolidates reading the new value
from the user buffer, verifying bounds, and calling round_pipe_size() with
a single assignment to pipe_max_size.

Link: http://lkml.kernel.org/r/1507658689-11669-4-git-send-email-joe.lawrence@redhat.com
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                 |   18 ++-----------
 include/linux/pipe_fs_i.h |    1 
 include/linux/sysctl.h    |    3 ++
 kernel/sysctl.c           |   49 ++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 15 deletions(-)

diff -puN fs/pipe.c~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size fs/pipe.c
--- a/fs/pipe.c~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size
+++ a/fs/pipe.c
@@ -1020,7 +1020,7 @@ const struct file_operations pipefifo_fo
  * Currently we rely on the pipe array holding a power-of-2 number
  * of pages. Returns 0 on error.
  */
-static inline unsigned int round_pipe_size(unsigned int size)
+unsigned int round_pipe_size(unsigned int size)
 {
 	unsigned long nr_pages;
 
@@ -1125,25 +1125,13 @@ out_revert_acct:
 }
 
 /*
- * This should work even if CONFIG_PROC_FS isn't set, as proc_dointvec_minmax
+ * This should work even if CONFIG_PROC_FS isn't set, as proc_dopipe_max_size
  * will return an error.
  */
 int pipe_proc_fn(struct ctl_table *table, int write, void __user *buf,
 		 size_t *lenp, loff_t *ppos)
 {
-	unsigned int rounded_pipe_max_size;
-	int ret;
-
-	ret = proc_douintvec_minmax(table, write, buf, lenp, ppos);
-	if (ret < 0 || !write)
-		return ret;
-
-	rounded_pipe_max_size = round_pipe_size(pipe_max_size);
-	if (rounded_pipe_max_size == 0)
-		return -EINVAL;
-
-	pipe_max_size = rounded_pipe_max_size;
-	return ret;
+	return proc_dopipe_max_size(table, write, buf, lenp, ppos);
 }
 
 /*
diff -puN include/linux/pipe_fs_i.h~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size
+++ a/include/linux/pipe_fs_i.h
@@ -191,5 +191,6 @@ long pipe_fcntl(struct file *, unsigned
 struct pipe_inode_info *get_pipe_info(struct file *file);
 
 int create_pipe_files(struct file **, int);
+unsigned int round_pipe_size(unsigned int size);
 
 #endif
diff -puN include/linux/sysctl.h~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size include/linux/sysctl.h
--- a/include/linux/sysctl.h~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size
+++ a/include/linux/sysctl.h
@@ -51,6 +51,9 @@ extern int proc_dointvec_minmax(struct c
 extern int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
+extern int proc_dopipe_max_size(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-add-proc_dopipe_max_size-to-safely-assign-pipe_max_size
+++ a/kernel/sysctl.c
@@ -66,6 +66,7 @@
 #include <linux/kexec.h>
 #include <linux/bpf.h>
 #include <linux/mount.h>
+#include <linux/pipe_fs_i.h>
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
@@ -2620,6 +2621,47 @@ int proc_douintvec_minmax(struct ctl_tab
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
+struct do_proc_dopipe_max_size_conv_param {
+	unsigned int *min;
+};
+
+static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
+					unsigned int *valp,
+					int write, void *data)
+{
+	struct do_proc_dopipe_max_size_conv_param *param = data;
+
+	if (write) {
+		unsigned int val = round_pipe_size(*lvalp);
+
+		if (val == 0)
+			return -EINVAL;
+
+		if (param->min && *param->min > val)
+			return -ERANGE;
+
+		if (*lvalp > UINT_MAX)
+			return -EINVAL;
+
+		*valp = val;
+	} else {
+		unsigned int val = *valp;
+		*lvalp = (unsigned long) val;
+	}
+
+	return 0;
+}
+
+int proc_dopipe_max_size(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dopipe_max_size_conv_param param = {
+		.min = (unsigned int *) table->extra1,
+	};
+	return do_proc_douintvec(table, write, buffer, lenp, ppos,
+				 do_proc_dopipe_max_size_conv, &param);
+}
+
 static void validate_coredump_safety(void)
 {
 #ifdef CONFIG_COREDUMP
@@ -3125,6 +3167,12 @@ int proc_douintvec_minmax(struct ctl_tab
 	return -ENOSYS;
 }
 
+int proc_dopipe_max_size(struct ctl_table *table, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -3168,6 +3216,7 @@ EXPORT_SYMBOL(proc_douintvec);
 EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL_GPL(proc_douintvec_minmax);
+EXPORT_SYMBOL_GPL(proc_dopipe_max_size);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
 EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
_

Patches currently in -mm which might be from joe.lawrence@redhat.com are


