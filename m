From: akpm@linux-foundation.org
Subject: + seq_file-properly-cope-with-pread.patch added to -mm tree
Date: Tue, 27 Jan 2009 14:03:50 -0800
Message-ID: <200901272203.n0RM3ppI025618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbZA0WEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 17:04:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, pjt@google.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     seq_file: properly cope with pread
has been added to the -mm tree.  Its filename is
     seq_file-properly-cope-with-pread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: properly cope with pread
From: ebiederm@xmission.com (Eric W. Biederman)

Currently seq_read assumes that the offset passed to it is always the
offset it passed to user space.  In the case pread this assumption is
broken and we do the wrong thing when presented with pread.

To solve this I introduce an offset cache inside of struct seq_file so we
know where our logical file position is.  Then in seq_read if we try to
read from another offset we reset our data structures and attempt to go to
the offset user space wanted.

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Turner <pjt@google.com>
Cc:  Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c            |   24 ++++++++++++++++++++++--
 include/linux/seq_file.h |    1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN fs/seq_file.c~seq_file-properly-cope-with-pread fs/seq_file.c
--- a/fs/seq_file.c~seq_file-properly-cope-with-pread
+++ a/fs/seq_file.c
@@ -130,6 +130,22 @@ ssize_t seq_read(struct file *file, char
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
@@ -229,8 +245,10 @@ Fill:
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
@@ -265,16 +283,18 @@ loff_t seq_lseek(struct file *file, loff
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

linux-next.patch
seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

