Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A5E7081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620246; cv=none; b=jj/Ld29NLmtNrFlxjsg7cQM/3DB2GAmD+Ma9jp9hdCukVyqfUbEwLrlLCVdOsG+xmDK5zNJUGYhPTpMDfI9s1kyzCnXqNtgxYU1J644ZNijFt2dwB2giLMftAut7TjVXybsIyuoSFaDL7GnI4pG9laT1Mg2qLOTm0uhFLjyV3yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620246; c=relaxed/simple;
	bh=TfFgRbdfTpdjTbr77Qyah+CGqyEOzTrJCGnjiCLYrSw=;
	h=Date:To:From:Subject:Message-Id; b=OjFQf0YOCHq2NHv4o7MwUyE6MjiDqAtx6qyQ1/CX26XmIPndM00EDVmjUBRG9hSYce2o+1AlI7TAfeHnhE1pFwZYlmjsjUgXcvywHRvFepX9CueuHOFj1RndmuVsSx+SYrjqNrnOYWyZzZRapoPbCoGB7HCo8MXexkwEFw98ckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZqfjJoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZqfjJoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD05C4CEDD;
	Sat, 22 Mar 2025 05:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620246;
	bh=TfFgRbdfTpdjTbr77Qyah+CGqyEOzTrJCGnjiCLYrSw=;
	h=Date:To:From:Subject:From;
	b=xZqfjJohl2nGc4RATJ716YCm+NnpSkM3sCRmil3cisKLSGxb3Yj6NoGX4JD+/rcpT
	 ugLqCrRA6vuFtHJrBqyezt/OpzASDOrIa/4Rb1NbyfvPLzAeoj+K5u1bgJeb4U2ApS
	 6l0sbZIzb2UbVJggaJpOKwfL3Jv0MV1tyIJ7+MhM=
Date: Fri, 21 Mar 2025 22:10:46 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,mingo@redhat.com,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,joel.granados@kernel.org,ioworker0@gmail.com,boqun.feng@gmail.com,anna.schumaker@oracle.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] samples-add-hung_task-detector-mutex-blocking-sample.patch removed from -mm tree
Message-Id: <20250322051046.8BD05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: add hung_task detector mutex blocking sample
has been removed from the -mm tree.  Its filename was
     samples-add-hung_task-detector-mutex-blocking-sample.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: samples: add hung_task detector mutex blocking sample
Date: Tue, 25 Feb 2025 16:02:43 +0900

Add a hung_task detector mutex blocking test sample code.

This module will create a dummy file on the debugfs.  That file will cause
the read process to sleep for enough long time (256 seconds) while holding
a mutex.  As a result, the second process will wait on the mutex for a
prolonged duration and be detected by the hung_task detector.

Usage is;

 > cd /sys/kernel/debug/hung_task
 > cat mutex & cat mutex

and wait for hung_task message.

[akpm@linux-foundation.org: make `hung_task_dir' static]
  Closes: https://lore.kernel.org/oe-kbuild-all/202503180827.4StpuFrD-lkp@intel.com/
Link: https://lkml.kernel.org/r/174046696281.2194069.4567490148001547311.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig                     |    9 +++
 samples/Makefile                    |    1 
 samples/hung_task/Makefile          |    2 
 samples/hung_task/hung_task_mutex.c |   66 ++++++++++++++++++++++++++
 4 files changed, 78 insertions(+)

diff --git a/samples/hung_task/hung_task_mutex.c a/samples/hung_task/hung_task_mutex.c
new file mode 100644
--- /dev/null
+++ a/samples/hung_task/hung_task_mutex.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * hung_task_mutex.c - Sample code which causes hung task by mutex
+ *
+ * Usage: load this module and read `<debugfs>/hung_task/mutex`
+ *        by 2 or more processes.
+ *
+ * This is for testing kernel hung_task error message.
+ * Note that this will make your system freeze and maybe
+ * cause panic. So do not use this except for the test.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+
+#define HUNG_TASK_DIR   "hung_task"
+#define HUNG_TASK_FILE  "mutex"
+#define SLEEP_SECOND 256
+
+static const char dummy_string[] = "This is a dummy string.";
+static DEFINE_MUTEX(dummy_mutex);
+static struct dentry *hung_task_dir;
+
+static ssize_t read_dummy(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	/* If the second task waits on the lock, it is uninterruptible sleep. */
+	guard(mutex)(&dummy_mutex);
+
+	/* When the first task sleep here, it is interruptible. */
+	msleep_interruptible(SLEEP_SECOND * 1000);
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				dummy_string, sizeof(dummy_string));
+}
+
+static const struct file_operations hung_task_fops = {
+	.read = read_dummy,
+};
+
+static int __init hung_task_sample_init(void)
+{
+	hung_task_dir = debugfs_create_dir(HUNG_TASK_DIR, NULL);
+	if (IS_ERR(hung_task_dir))
+		return PTR_ERR(hung_task_dir);
+
+	debugfs_create_file(HUNG_TASK_FILE, 0400, hung_task_dir,
+			    NULL, &hung_task_fops);
+
+	return 0;
+}
+
+static void __exit hung_task_sample_exit(void)
+{
+	debugfs_remove_recursive(hung_task_dir);
+}
+
+module_init(hung_task_sample_init);
+module_exit(hung_task_sample_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Masami Hiramatsu");
+MODULE_DESCRIPTION("Simple sleep under mutex file for testing hung task");
diff --git a/samples/hung_task/Makefile a/samples/hung_task/Makefile
new file mode 100644
--- /dev/null
+++ a/samples/hung_task/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
--- a/samples/Kconfig~samples-add-hung_task-detector-mutex-blocking-sample
+++ a/samples/Kconfig
@@ -300,6 +300,15 @@ config SAMPLE_CHECK_EXEC
 	  demonstrate how they should be used with execveat(2) +
 	  AT_EXECVE_CHECK.
 
+config SAMPLE_HUNG_TASK
+	tristate "Hung task detector test code"
+	depends on DETECT_HUNG_TASK && DEBUG_FS
+	help
+	  Build a module which provide a simple debugfs file. If user reads
+	  the file, it will sleep long time (256 seconds) with holding a
+	  mutex. Thus if there are 2 or more processes read this file, it
+	  will be detected by the hung_task watchdog.
+
 source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
--- a/samples/Makefile~samples-add-hung_task-detector-mutex-blocking-sample
+++ a/samples/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
 obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
+obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
_

Patches currently in -mm which might be from mhiramat@kernel.org are


