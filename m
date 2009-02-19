From: akpm@linux-foundation.org
Subject: [merged] seq_file-properly-cope-with-pread.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:29 -0800
Message-ID: <200902191916.n1JJGTca016255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbZBSTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, pjt@google.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file: properly cope with pread
has been removed from the -mm tree.  Its filename was
     seq_file-properly-cope-with-pread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: properly cope with pread
From: Eric Biederman <ebiederm@xmission.com>

Currently seq_read assumes that the offset passed to it is always the
offset it passed to user space.  In the case pread this assumption is
broken and we do the wrong thing when presented with pread.

To solve this I introduce an offset cache inside of struct seq_file so we
know where our logical file position is.  Then in seq_read if we try to
read from another offset we reset our data structures and attempt to go to
the offset user space wanted.

[akpm@linux-foundation.org: restore FMODE_PWRITE]
[pjt@google.com: seq_open needs its fmode opened up to take advantage of this]
Signed-off-by: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   36 ++++++++++++++++++++++++++++++++----
 include/linux/seq_file.h |    1 +
 2 files changed, 33 insertions(+), 4 deletions(-)

diff -puN fs/seq_file.c~seq_file-properly-cope-with-pread fs/seq_file.c
--- a/fs/seq_file.c~seq_file-properly-cope-with-pread
+++ a/fs/seq_file.c
@@ -48,8 +48,16 @@ int seq_open(struct file *file, const st
 	 */
 	file->f_version = 0;
 
-	/* SEQ files support lseek, but not pread/pwrite */
-	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
+	/*
+	 * seq_files support lseek() and pread().  They do not implement
+	 * write() at all, but we clear FMODE_PWRITE here for historical
+	 * reasons.
+	 *
+	 * If a client of seq_files a) implements file.write() and b) wishes to
+	 * support pwrite() then that client will need to implement its own
+	 * file.open() which calls seq_open() and then sets FMODE_PWRITE.
+	 */
+	file->f_mode &= ~FMODE_PWRITE;
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
@@ -131,6 +139,22 @@ ssize_t seq_read(struct file *file, char
 	int err = 0;
 
 	mutex_lock(&m->lock);
+
+	/* Don't assume *ppos is where we left it */
+	if (unlikely(*ppos != m->read_pos)) {
+		m->read_pos = *ppos;
+		while ((err = traverse(m, *ppos)) == -EAGAIN)
+			;
+		if (err) {
+			/* With prejudice... */
+			m->read_pos = 0;
+			m->version = 0;
+			m->index = 0;
+			m->count = 0;
+			goto Done;
+		}
+	}
+
 	/*
 	 * seq_file->op->..m_start/m_stop/m_next may do special actions
 	 * or optimisations based on the file->f_version, so we want to
@@ -230,8 +254,10 @@ Fill:
 Done:
 	if (!copied)
 		copied = err;
-	else
+	else {
 		*ppos += copied;
+		m->read_pos += copied;
+	}
 	file->f_version = m->version;
 	mutex_unlock(&m->lock);
 	return copied;
@@ -266,16 +292,18 @@ loff_t seq_lseek(struct file *file, loff
 			if (offset < 0)
 				break;
 			retval = offset;
-			if (offset != file->f_pos) {
+			if (offset != m->read_pos) {
 				while ((retval=traverse(m, offset)) == -EAGAIN)
 					;
 				if (retval) {
 					/* with extreme prejudice... */
 					file->f_pos = 0;
+					m->read_pos = 0;
 					m->version = 0;
 					m->index = 0;
 					m->count = 0;
 				} else {
+					m->read_pos = offset;
 					retval = file->f_pos = offset;
 				}
 			}
diff -puN include/linux/seq_file.h~seq_file-properly-cope-with-pread include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq_file-properly-cope-with-pread
+++ a/include/linux/seq_file.h
@@ -19,6 +19,7 @@ struct seq_file {
 	size_t from;
 	size_t count;
 	loff_t index;
+	loff_t read_pos;
 	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
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

