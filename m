Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420791487E1
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 21:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744666706; cv=none; b=LqlEXn3Ru4Tzkh6/TDfFHsS0wsJ0kl0KIc1k4tI22x1YS2/8ICqxeGEAgjnJPR1wd9nnZ9AOiSZHOnH6dbOdmeGnT7Qh8J03w9VhQAOXTKx0zRr57mnQDrPeHHusLhkEJz8zfZTh7nJYZrbD2vShlpmqnYT0xg+Ud/GbY5JYEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744666706; c=relaxed/simple;
	bh=1qieS0h7bz7L+yLs+zKocQx+TKIve7e2B96Xj2fI9xI=;
	h=Date:To:From:Subject:Message-Id; b=eEmLnhXFL7c2D/XbKusndq+ADfCdgq4B8ZRR8TDdeuQWVGSL4zAYVhxqCbRmWqtL6rWKocQE1rnUwaU7Mvw/03ke70WI7qLUjgcCyuvS+IpW8bBRl2YEcR9OrhmJoCpp58ulVShLzTSm1dGel7IyS7FDruY8z3/n0vHf+KkcRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aeXt6FaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aeXt6FaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96229C4CEE2;
	Mon, 14 Apr 2025 21:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744666705;
	bh=1qieS0h7bz7L+yLs+zKocQx+TKIve7e2B96Xj2fI9xI=;
	h=Date:To:From:Subject:From;
	b=aeXt6FaUcffAbHRr2R5KpF1Lme1h23Jyn1aDa3SCaiFhhCFJWJ/RA6WLQja9Ez+0J
	 yG6XE7rDNX5s/MEHdZG5+FonTD7FKJryD5g79oPGleaL6CprWeVfmlbC0jCw62dsbR
	 S88s8d5WR5Dg2qBr5rw1PZCbC61KbhNuSJvXJN6E=
Date: Mon, 14 Apr 2025 14:38:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,ioworker0@gmail.com,boqun.feng@gmail.com,anna.schumaker@oracle.com,amaindex@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-extend-hung_task-detector-test-with-semaphore-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250414213825.96229C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: extend hung_task detector test with semaphore support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-extend-hung_task-detector-test-with-semaphore-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-extend-hung_task-detector-test-with-semaphore-support.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Li <amaindex@outlook.com>
Subject: samples: extend hung_task detector test with semaphore support
Date: Mon, 14 Apr 2025 22:59:45 +0800

Extend the existing hung_task detector test module to support multiple
lock types, including mutex and semaphore, with room for future additions
(e.g., spinlock, etc.).  This module creates dummy files under
<debugfs>/hung_task, such as 'mutex' and 'semaphore'.  The read process on
any of these files will sleep for enough long time (256 seconds) while
holding the respective lock.  As a result, the second process will wait on
the lock for a prolonged duration and be detected by the hung_task
detector.

This change unifies the previous mutex-only sample into a single,
extensible hung_task_tests module, reducing code duplication and improving
maintainability.

Usage is:

	> cd /sys/kernel/debug/hung_task
	> cat mutex & cat mutex          # Test mutex blocking
	> cat semaphore & cat semaphore  # Test semaphore blocking

Update the Kconfig description to reflect multiple debugfs files support.

Link: https://lkml.kernel.org/r/20250414145945.84916-4-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Zi Li <amaindex@outlook.com>
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig                     |    9 +-
 samples/hung_task/Makefile          |    2 
 samples/hung_task/hung_task_mutex.c |   66 -----------------
 samples/hung_task/hung_task_tests.c |   97 ++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 71 deletions(-)

diff --git a/samples/hung_task/hung_task_mutex.c a/samples/hung_task/hung_task_mutex.c
deleted file mode 100644
--- a/samples/hung_task/hung_task_mutex.c
+++ /dev/null
@@ -1,66 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * hung_task_mutex.c - Sample code which causes hung task by mutex
- *
- * Usage: load this module and read `<debugfs>/hung_task/mutex`
- *        by 2 or more processes.
- *
- * This is for testing kernel hung_task error message.
- * Note that this will make your system freeze and maybe
- * cause panic. So do not use this except for the test.
- */
-
-#include <linux/debugfs.h>
-#include <linux/delay.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-
-#define HUNG_TASK_DIR   "hung_task"
-#define HUNG_TASK_FILE  "mutex"
-#define SLEEP_SECOND 256
-
-static const char dummy_string[] = "This is a dummy string.";
-static DEFINE_MUTEX(dummy_mutex);
-static struct dentry *hung_task_dir;
-
-static ssize_t read_dummy(struct file *file, char __user *user_buf,
-			  size_t count, loff_t *ppos)
-{
-	/* If the second task waits on the lock, it is uninterruptible sleep. */
-	guard(mutex)(&dummy_mutex);
-
-	/* When the first task sleep here, it is interruptible. */
-	msleep_interruptible(SLEEP_SECOND * 1000);
-
-	return simple_read_from_buffer(user_buf, count, ppos,
-				dummy_string, sizeof(dummy_string));
-}
-
-static const struct file_operations hung_task_fops = {
-	.read = read_dummy,
-};
-
-static int __init hung_task_sample_init(void)
-{
-	hung_task_dir = debugfs_create_dir(HUNG_TASK_DIR, NULL);
-	if (IS_ERR(hung_task_dir))
-		return PTR_ERR(hung_task_dir);
-
-	debugfs_create_file(HUNG_TASK_FILE, 0400, hung_task_dir,
-			    NULL, &hung_task_fops);
-
-	return 0;
-}
-
-static void __exit hung_task_sample_exit(void)
-{
-	debugfs_remove_recursive(hung_task_dir);
-}
-
-module_init(hung_task_sample_init);
-module_exit(hung_task_sample_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Masami Hiramatsu");
-MODULE_DESCRIPTION("Simple sleep under mutex file for testing hung task");
diff --git a/samples/hung_task/hung_task_tests.c a/samples/hung_task/hung_task_tests.c
new file mode 100644
--- /dev/null
+++ a/samples/hung_task/hung_task_tests.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * hung_task_tests.c - Sample code for testing hung tasks with mutex,
+ * semaphore, etc.
+ *
+ * Usage: Load this module and read `<debugfs>/hung_task/mutex`,
+ *        `<debugfs>/hung_task/semaphore`, etc., with 2 or more processes.
+ *
+ * This is for testing kernel hung_task error messages with various locking
+ * mechanisms (e.g., mutex, semaphore, etc.). Note that this may freeze
+ * your system or cause a panic. Use only for testing purposes.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/semaphore.h>
+
+#define HUNG_TASK_DIR		"hung_task"
+#define HUNG_TASK_MUTEX_FILE	"mutex"
+#define HUNG_TASK_SEM_FILE	"semaphore"
+#define SLEEP_SECOND		256
+
+static const char dummy_string[] = "This is a dummy string.";
+static DEFINE_MUTEX(dummy_mutex);
+static DEFINE_SEMAPHORE(dummy_sem, 1);
+static struct dentry *hung_task_dir;
+
+/* Mutex-based read function */
+static ssize_t read_dummy_mutex(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	/* Second task waits on mutex, entering uninterruptible sleep */
+	guard(mutex)(&dummy_mutex);
+
+	/* First task sleeps here, interruptible */
+	msleep_interruptible(SLEEP_SECOND * 1000);
+
+	return simple_read_from_buffer(user_buf, count, ppos, dummy_string,
+				       sizeof(dummy_string));
+}
+
+/* Semaphore-based read function */
+static ssize_t read_dummy_semaphore(struct file *file, char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	/* Second task waits on semaphore, entering uninterruptible sleep */
+	down(&dummy_sem);
+
+	/* First task sleeps here, interruptible */
+	msleep_interruptible(SLEEP_SECOND * 1000);
+
+	up(&dummy_sem);
+
+	return simple_read_from_buffer(user_buf, count, ppos, dummy_string,
+				       sizeof(dummy_string));
+}
+
+/* File operations for mutex */
+static const struct file_operations hung_task_mutex_fops = {
+	.read = read_dummy_mutex,
+};
+
+/* File operations for semaphore */
+static const struct file_operations hung_task_sem_fops = {
+	.read = read_dummy_semaphore,
+};
+
+static int __init hung_task_tests_init(void)
+{
+	hung_task_dir = debugfs_create_dir(HUNG_TASK_DIR, NULL);
+	if (IS_ERR(hung_task_dir))
+		return PTR_ERR(hung_task_dir);
+
+	/* Create debugfs files for mutex and semaphore tests */
+	debugfs_create_file(HUNG_TASK_MUTEX_FILE, 0400, hung_task_dir, NULL,
+			    &hung_task_mutex_fops);
+	debugfs_create_file(HUNG_TASK_SEM_FILE, 0400, hung_task_dir, NULL,
+			    &hung_task_sem_fops);
+
+	return 0;
+}
+
+static void __exit hung_task_tests_exit(void)
+{
+	debugfs_remove_recursive(hung_task_dir);
+}
+
+module_init(hung_task_tests_init);
+module_exit(hung_task_tests_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Masami Hiramatsu <mhiramat@kernel.org>");
+MODULE_AUTHOR("Zi Li <amaindex@outlook.com>");
+MODULE_DESCRIPTION("Simple sleep under lock files for testing hung task");
--- a/samples/hung_task/Makefile~samples-extend-hung_task-detector-test-with-semaphore-support
+++ a/samples/hung_task/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
+obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_tests.o
--- a/samples/Kconfig~samples-extend-hung_task-detector-test-with-semaphore-support
+++ a/samples/Kconfig
@@ -304,10 +304,11 @@ config SAMPLE_HUNG_TASK
 	tristate "Hung task detector test code"
 	depends on DETECT_HUNG_TASK && DEBUG_FS
 	help
-	  Build a module which provide a simple debugfs file. If user reads
-	  the file, it will sleep long time (256 seconds) with holding a
-	  mutex. Thus if there are 2 or more processes read this file, it
-	  will be detected by the hung_task watchdog.
+	  Build a module that provides debugfs files (e.g., mutex, semaphore,
+	  etc.) under <debugfs>/hung_task. If user reads one of these files,
+	  it will sleep long time (256 seconds) with holding a lock. Thus,
+	  if 2 or more processes read the same file concurrently, it will
+	  be detected by the hung_task watchdog.
 
 source "samples/rust/Kconfig"
 
_

Patches currently in -mm which might be from amaindex@outlook.com are

samples-extend-hung_task-detector-test-with-semaphore-support.patch

