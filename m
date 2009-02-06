From: akpm@linux-foundation.org
Subject: [merged] seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:38:31 -0800
Message-ID: <200902061938.n16JcVtE012554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbZBFTio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, pjt@google.com, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file: move traverse so it can be used from seq_read
has been removed from the -mm tree.  Its filename was
     seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: move traverse so it can be used from seq_read
From: Eric Biederman <ebiederm@xmission.com>

In 2.6.25 some /proc files were converted to use the seq_file
infrastructure.  But seq_files do not correctly support pread(), which
broke some usersapce applications.

The patch series teaches the seq_file code to properly implement pread().


This patch:

To handle pread correctly we can't assume that f_pos is where we left it
in seq_read.  So modify traverse() so that we can use it in seq_read.

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Turner <pjt@google.com>
Cc:  Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |  114 ++++++++++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff -puN fs/seq_file.c~seq_file-move-traverse-so-it-can-be-used-from-seq_read fs/seq_file.c
--- a/fs/seq_file.c~seq_file-move-traverse-so-it-can-be-used-from-seq_read
+++ a/fs/seq_file.c
@@ -54,6 +54,63 @@ int seq_open(struct file *file, const st
 }
 EXPORT_SYMBOL(seq_open);
 
+static int traverse(struct seq_file *m, loff_t offset)
+{
+	loff_t pos = 0, index;
+	int error = 0;
+	void *p;
+
+	m->version = 0;
+	index = 0;
+	m->count = m->from = 0;
+	if (!offset) {
+		m->index = index;
+		return 0;
+	}
+	if (!m->buf) {
+		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		if (!m->buf)
+			return -ENOMEM;
+	}
+	p = m->op->start(m, &index);
+	while (p) {
+		error = PTR_ERR(p);
+		if (IS_ERR(p))
+			break;
+		error = m->op->show(m, p);
+		if (error < 0)
+			break;
+		if (unlikely(error)) {
+			error = 0;
+			m->count = 0;
+		}
+		if (m->count == m->size)
+			goto Eoverflow;
+		if (pos + m->count > offset) {
+			m->from = offset - pos;
+			m->count -= m->from;
+			m->index = index;
+			break;
+		}
+		pos += m->count;
+		m->count = 0;
+		if (pos == offset) {
+			index++;
+			m->index = index;
+			break;
+		}
+		p = m->op->next(m, p, &index);
+	}
+	m->op->stop(m, p);
+	return error;
+
+Eoverflow:
+	m->op->stop(m, p);
+	kfree(m->buf);
+	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	return !m->buf ? -ENOMEM : -EAGAIN;
+}
+
 /**
  *	seq_read -	->read() method for sequential files.
  *	@file: the file to read from
@@ -186,63 +243,6 @@ Efault:
 }
 EXPORT_SYMBOL(seq_read);
 
-static int traverse(struct seq_file *m, loff_t offset)
-{
-	loff_t pos = 0, index;
-	int error = 0;
-	void *p;
-
-	m->version = 0;
-	index = 0;
-	m->count = m->from = 0;
-	if (!offset) {
-		m->index = index;
-		return 0;
-	}
-	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
-		if (!m->buf)
-			return -ENOMEM;
-	}
-	p = m->op->start(m, &index);
-	while (p) {
-		error = PTR_ERR(p);
-		if (IS_ERR(p))
-			break;
-		error = m->op->show(m, p);
-		if (error < 0)
-			break;
-		if (unlikely(error)) {
-			error = 0;
-			m->count = 0;
-		}
-		if (m->count == m->size)
-			goto Eoverflow;
-		if (pos + m->count > offset) {
-			m->from = offset - pos;
-			m->count -= m->from;
-			m->index = index;
-			break;
-		}
-		pos += m->count;
-		m->count = 0;
-		if (pos == offset) {
-			index++;
-			m->index = index;
-			break;
-		}
-		p = m->op->next(m, p, &index);
-	}
-	m->op->stop(m, p);
-	return error;
-
-Eoverflow:
-	m->op->stop(m, p);
-	kfree(m->buf);
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
-	return !m->buf ? -ENOMEM : -EAGAIN;
-}
-
 /**
  *	seq_lseek -	->llseek() method for sequential files.
  *	@file: the file in question
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
linux-next.patch
sysctl-min-max-range-check-is-broken.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch

