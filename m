Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E209156237
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 22:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751668137; cv=none; b=QAt82EFNL1uZ7dYh5wNv0eWNY2S1ivxlweS+XHx8meTnTiq7loqDrwQlJUSj/WO5NxQZuC4a5GKomtzSTEoO/XSiDwWcjTIjGX/794heZ9M2hP7Z+unPhecdxvaq735zr0OaR4d2SZj9Rg3O0zalPlJz0CdOg4Z17N2CES8tUS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751668137; c=relaxed/simple;
	bh=5BczpdOyjE19ci3GSBbNBKTEFBh8vf+vpN+4pdpG+Zw=;
	h=Date:To:From:Subject:Message-Id; b=W84qwjxsL+BpaWrxe87vr8lLZ4Ti4KRpkVUc3cYxnDEnQyXIhT6gsDuKTtUhS7wo/OGf1qN6sIV50WugQBXrUGLRxD/VSYJiPgNrJvba1mlcdcWVYKbD8LIYo9cKeKteKfyxVjYgh1Ul7+gpFV79rdWkt3e7bbJoRjHrlsTBCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V44+vNxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V44+vNxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017FCC4CEE3;
	Fri,  4 Jul 2025 22:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751668137;
	bh=5BczpdOyjE19ci3GSBbNBKTEFBh8vf+vpN+4pdpG+Zw=;
	h=Date:To:From:Subject:From;
	b=V44+vNxkoccVilTuY1yMQCIspRPwR4r4JanqSc3uEXn2pJn8dRW8GVqTRB37Y6JTd
	 wh/NVh52f8epVx8eR5860ragBUS93fyMqCkBBtCLRSr2XYVrkmV1AgfFUzQBBP3Q5T
	 tdTApUu0bwaXVQhe2xYy5qMBnrdfb3nhdYRzaIjQ=
Date: Fri, 04 Jul 2025 15:28:56 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,peterz@infradead.org,mingzhe.yang@ly.com,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jstultz@google.com,joel.granados@kernel.org,boqun.feng@gmail.com,anna.schumaker@oracle.com,zi.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-enhance-hung_task-detector-test-with-read-write-semaphore-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250704222857.017FCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: enhance hung_task detector test with read-write semaphore support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-enhance-hung_task-detector-test-with-read-write-semaphore-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-enhance-hung_task-detector-test-with-read-write-semaphore-support.patch

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
From: Zi Li <zi.li@linux.dev>
Subject: samples: enhance hung_task detector test with read-write semaphore support
Date: Fri, 27 Jun 2025 15:29:24 +0800

Extend the hung_task detector test module to include read-write semaphore
support alongside existing mutex and semaphore tests.  This module now
creates additional debugfs files under <debugfs>/hung_task, namely
'rw_semaphore_read' and 'rw_semaphore_write', in addition to 'mutex' and
'semaphore'.  Reading these files with multiple processes triggers a
prolonged sleep (256 seconds) while holding the respective lock, enabling
hung_task detector testing for various locking mechanisms.

This change builds on the extensible hung_task_tests module, adding
read-write semaphore functionality to improve test coverage for kernel
locking primitives.  The implementation ensures proper lock handling and
includes checks to prevent redundant data reads.

Usage is:

        > cd /sys/kernel/debug/hung_task
        > cat mutex & cat mutex           # Test mutex blocking
        > cat semaphore & cat semaphore   # Test semaphore blocking
        > cat rw_semaphore_write \
            & cat rw_semaphore_read       # Test rwsem blocking
        > cat rw_semaphore_write \
            & cat rw_semaphore_write      # Test rwsem blocking

Update the Kconfig description to reflect the addition of read-write
semaphore debugfs files.

Link: https://lkml.kernel.org/r/20250627072924.36567-4-lance.yang@linux.dev
Signed-off-by: Zi Li <zi.li@linux.dev>
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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

 samples/Kconfig                     |    7 --
 samples/hung_task/hung_task_tests.c |   81 +++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 11 deletions(-)

--- a/samples/hung_task/hung_task_tests.c~samples-enhance-hung_task-detector-test-with-read-write-semaphore-support
+++ a/samples/hung_task/hung_task_tests.c
@@ -4,11 +4,12 @@
  * semaphore, etc.
  *
  * Usage: Load this module and read `<debugfs>/hung_task/mutex`,
- *        `<debugfs>/hung_task/semaphore`, etc., with 2 or more processes.
+ *        `<debugfs>/hung_task/semaphore`, `<debugfs>/hung_task/rw_semaphore_read`,
+ *        `<debugfs>/hung_task/rw_semaphore_write`, etc., with 2 or more processes.
  *
  * This is for testing kernel hung_task error messages with various locking
- * mechanisms (e.g., mutex, semaphore, etc.). Note that this may freeze
- * your system or cause a panic. Use only for testing purposes.
+ * mechanisms (e.g., mutex, semaphore, rw_semaphore_read, rw_semaphore_write, etc.).
+ * Note that this may freeze your system or cause a panic. Use only for testing purposes.
  */
 
 #include <linux/debugfs.h>
@@ -17,21 +18,29 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/semaphore.h>
+#include <linux/rwsem.h>
 
-#define HUNG_TASK_DIR		"hung_task"
-#define HUNG_TASK_MUTEX_FILE	"mutex"
-#define HUNG_TASK_SEM_FILE	"semaphore"
-#define SLEEP_SECOND		256
+#define HUNG_TASK_DIR			"hung_task"
+#define HUNG_TASK_MUTEX_FILE		"mutex"
+#define HUNG_TASK_SEM_FILE		"semaphore"
+#define HUNG_TASK_RWSEM_READ_FILE	"rw_semaphore_read"
+#define HUNG_TASK_RWSEM_WRITE_FILE	"rw_semaphore_write"
+#define SLEEP_SECOND			256
 
 static const char dummy_string[] = "This is a dummy string.";
 static DEFINE_MUTEX(dummy_mutex);
 static DEFINE_SEMAPHORE(dummy_sem, 1);
+static DECLARE_RWSEM(dummy_rwsem);
 static struct dentry *hung_task_dir;
 
 /* Mutex-based read function */
 static ssize_t read_dummy_mutex(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
+	/* Check if data is already read */
+	if (*ppos >= sizeof(dummy_string))
+		return 0;
+
 	/* Second task waits on mutex, entering uninterruptible sleep */
 	guard(mutex)(&dummy_mutex);
 
@@ -46,6 +55,10 @@ static ssize_t read_dummy_mutex(struct f
 static ssize_t read_dummy_semaphore(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
+	/* Check if data is already read */
+	if (*ppos >= sizeof(dummy_string))
+		return 0;
+
 	/* Second task waits on semaphore, entering uninterruptible sleep */
 	down(&dummy_sem);
 
@@ -58,6 +71,46 @@ static ssize_t read_dummy_semaphore(stru
 				       sizeof(dummy_string));
 }
 
+/* Read-write semaphore read function */
+static ssize_t read_dummy_rwsem_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	/* Check if data is already read */
+	if (*ppos >= sizeof(dummy_string))
+		return 0;
+
+	/* Acquires read lock, allowing concurrent readers but blocks if write lock is held */
+	down_read(&dummy_rwsem);
+
+	/* Sleeps here, potentially triggering hung task detection if lock is held too long */
+	msleep_interruptible(SLEEP_SECOND * 1000);
+
+	up_read(&dummy_rwsem);
+
+	return simple_read_from_buffer(user_buf, count, ppos, dummy_string,
+				       sizeof(dummy_string));
+}
+
+/* Read-write semaphore write function */
+static ssize_t read_dummy_rwsem_write(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	/* Check if data is already read */
+	if (*ppos >= sizeof(dummy_string))
+		return 0;
+
+	/* Acquires exclusive write lock, blocking all other readers and writers */
+	down_write(&dummy_rwsem);
+
+	/* Sleeps here, potentially triggering hung task detection if lock is held too long */
+	msleep_interruptible(SLEEP_SECOND * 1000);
+
+	up_write(&dummy_rwsem);
+
+	return simple_read_from_buffer(user_buf, count, ppos, dummy_string,
+				       sizeof(dummy_string));
+}
+
 /* File operations for mutex */
 static const struct file_operations hung_task_mutex_fops = {
 	.read = read_dummy_mutex,
@@ -68,6 +121,16 @@ static const struct file_operations hung
 	.read = read_dummy_semaphore,
 };
 
+/* File operations for rw_semaphore read */
+static const struct file_operations hung_task_rwsem_read_fops = {
+	.read = read_dummy_rwsem_read,
+};
+
+/* File operations for rw_semaphore write */
+static const struct file_operations hung_task_rwsem_write_fops = {
+	.read = read_dummy_rwsem_write,
+};
+
 static int __init hung_task_tests_init(void)
 {
 	hung_task_dir = debugfs_create_dir(HUNG_TASK_DIR, NULL);
@@ -79,6 +142,10 @@ static int __init hung_task_tests_init(v
 			    &hung_task_mutex_fops);
 	debugfs_create_file(HUNG_TASK_SEM_FILE, 0400, hung_task_dir, NULL,
 			    &hung_task_sem_fops);
+	debugfs_create_file(HUNG_TASK_RWSEM_READ_FILE, 0400, hung_task_dir, NULL,
+			    &hung_task_rwsem_read_fops);
+	debugfs_create_file(HUNG_TASK_RWSEM_WRITE_FILE, 0400, hung_task_dir, NULL,
+			    &hung_task_rwsem_write_fops);
 
 	return 0;
 }
--- a/samples/Kconfig~samples-enhance-hung_task-detector-test-with-read-write-semaphore-support
+++ a/samples/Kconfig
@@ -316,10 +316,9 @@ config SAMPLE_HUNG_TASK
 	depends on DETECT_HUNG_TASK && DEBUG_FS
 	help
 	  Build a module that provides debugfs files (e.g., mutex, semaphore,
-	  etc.) under <debugfs>/hung_task. If user reads one of these files,
-	  it will sleep long time (256 seconds) with holding a lock. Thus,
-	  if 2 or more processes read the same file concurrently, it will
-	  be detected by the hung_task watchdog.
+	  rw_semaphore_read, rw_semaphore_write) under <debugfs>/hung_task.
+	  Reading these files with multiple processes triggers hung task
+	  detection by holding locks for a long time (256 seconds).
 
 source "samples/rust/Kconfig"
 
_

Patches currently in -mm which might be from zi.li@linux.dev are

samples-enhance-hung_task-detector-test-with-read-write-semaphore-support.patch

