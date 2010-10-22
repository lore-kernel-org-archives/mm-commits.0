From: akpm@linux-foundation.org
Subject: + procfs-fix-numbering-in-proc-locks.patch added to -mm tree
Date: Fri, 22 Oct 2010 14:27:08 -0700
Message-ID: <201010222127.o9MLR8KG008602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab0JVV1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 17:27:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmarchan@redhat.com, matthew@wil.cx, xemul@parallels.com


The patch titled
     procfs: fix numbering in /proc/locks
has been added to the -mm tree.  Its filename is
     procfs-fix-numbering-in-proc-locks.patch

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
Subject: procfs: fix numbering in /proc/locks
From: Jerome Marchand <jmarchan@redhat.com>

The lock number in /proc/locks (first field) is implemented by a counter
(private field of struct seq_file) which is incremented at each call of
locks_show() and reset to 1 in locks_start() whatever the offset is.  It
should be reset according to the actual position in the list.  Because of
this, the numbering erratically restarts at 1 several times when reading a
long /proc/locks file.

Moreover, locks_show() can be called twice to print a single line thus
skipping a number.  The counter should be incremented in locks_next().

And last, pos is a loff_t, which can be bigger than a pointer, so we don't
use the pointer as an integer anymore, and allocate a loff_t instead.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN fs/locks.c~procfs-fix-numbering-in-proc-locks fs/locks.c
--- a/fs/locks.c~procfs-fix-numbering-in-proc-locks
+++ a/fs/locks.c
@@ -2109,7 +2109,7 @@ EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 #include <linux/seq_file.h>
 
 static void lock_get_status(struct seq_file *f, struct file_lock *fl,
-							int id, char *pfx)
+			    loff_t id, char *pfx)
 {
 	struct inode *inode = NULL;
 	unsigned int fl_pid;
@@ -2122,7 +2122,7 @@ static void lock_get_status(struct seq_f
 	if (fl->fl_file != NULL)
 		inode = fl->fl_file->f_path.dentry->d_inode;
 
-	seq_printf(f, "%d:%s ", id, pfx);
+	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
 		seq_printf(f, "%6s %s ",
 			     (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ",
@@ -2185,24 +2185,27 @@ static int locks_show(struct seq_file *f
 
 	fl = list_entry(v, struct file_lock, fl_link);
 
-	lock_get_status(f, fl, (long)f->private, "");
+	lock_get_status(f, fl, *((loff_t *)f->private), "");
 
 	list_for_each_entry(bfl, &fl->fl_block, fl_block)
-		lock_get_status(f, bfl, (long)f->private, " ->");
+		lock_get_status(f, bfl, *((loff_t *)f->private), " ->");
 
-	f->private++;
 	return 0;
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
+	loff_t *p = f->private;
+
 	lock_flocks();
-	f->private = (void *)1;
+	*p = (*pos + 1);
 	return seq_list_start(&file_lock_list, *pos);
 }
 
 static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 {
+	loff_t *p = f->private;
+	++*p;
 	return seq_list_next(v, &file_lock_list, pos);
 }
 
@@ -2220,14 +2223,14 @@ static const struct seq_operations locks
 
 static int locks_open(struct inode *inode, struct file *filp)
 {
-	return seq_open(filp, &locks_seq_operations);
+	return seq_open_private(filp, &locks_seq_operations, sizeof(loff_t));
 }
 
 static const struct file_operations proc_locks_operations = {
 	.open		= locks_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int __init proc_locks_init(void)
_

Patches currently in -mm which might be from jmarchan@redhat.com are

procfs-fix-numbering-in-proc-locks.patch

