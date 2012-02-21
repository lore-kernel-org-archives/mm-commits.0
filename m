From: akpm@linux-foundation.org
Subject: + locks-new-proc-lockinfo.patch added to -mm tree
Date: Tue, 21 Feb 2012 13:06:25 -0800
Message-ID: <20120221210625.89432A014E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50175 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2BUVG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 16:06:26 -0500
Received: by ggnp1 with SMTP id p1so864637ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 13:06:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org, bfields@fieldses.org, ebiederm@xmission.com, matthew@wil.cx, viro@zeniv.linux.org.uk


The patch titled
     Subject: locks: new /proc/lockinfo
has been added to the -mm tree.  Its filename is
     locks-new-proc-lockinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@gnu.org>
Subject: locks: new /proc/lockinfo

Based on our previous discussion https://lkml.org/lkml/2012/2/10/462 we
came to agree on deprecating the current /proc/locks in favor of a more
extensible interface.  The new /proc/lockinfo file exports similar
information - except instead of maj:min the device name is shown - and
entries are formated like those in /proc/cpuinfo, allowing us to add new
entries without breaking userspace.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   10 +
 fs/locks.c                                 |  109 ++++++++++++++++++-
 2 files changed, 114 insertions(+), 5 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~locks-new-proc-lockinfo Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~locks-new-proc-lockinfo
+++ a/Documentation/feature-removal-schedule.txt
@@ -491,6 +491,16 @@ Why:	The delaylog mode that has been the
 	the log code.
 Who:	Christoph Hellwig <hch@lst.de>
 
+---------------------------
+
+What:	/proc/locks
+When:	2014
+Why:	The current /proc/locks file does not allow modifying entries as it
+        breaks userspace (most notably lslk(8)). A new /proc/lockinfo interface
+        replaces this file in a more extendable format (lines per entry), like
+        /proc/cpuinfo.
+Who:	Davidlohr Bueso <dave@gnu.org>
+
 ----------------------------
 
 What:	iwlagn alias support
diff -puN fs/locks.c~locks-new-proc-lockinfo fs/locks.c
--- a/fs/locks.c~locks-new-proc-lockinfo
+++ a/fs/locks.c
@@ -112,6 +112,9 @@
  *  Leases and LOCK_MAND
  *  Matthew Wilcox <willy@debian.org>, June, 2000.
  *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
+ *
+ *  Deprecated /proc/locks in favor of /proc/lockinfo
+ *  Davidlohr Bueso <dave@gnu.org>, February, 2012.
  */
 
 #include <linux/capability.h>
@@ -2156,6 +2159,10 @@ static void lock_get_status(struct seq_f
 	struct inode *inode = NULL;
 	unsigned int fl_pid;
 
+	/* deprecated, see Documentation/feature-removal-schedule.txt */
+	printk_once(KERN_WARNING "%s (%d): /proc/locks is deprecated please use /proc/lockinfo instead.\n",
+		    current->comm, task_pid_nr(current));
+
 	if (fl->fl_nspid)
 		fl_pid = pid_vnr(fl->fl_nspid);
 	else
@@ -2199,15 +2206,10 @@ static void lock_get_status(struct seq_f
 			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
 	}
 	if (inode) {
-#ifdef WE_CAN_BREAK_LSLK_NOW
-		seq_printf(f, "%d %s:%ld ", fl_pid,
-				inode->i_sb->s_id, inode->i_ino);
-#else
 		/* userspace relies on this representation of dev_t ;-( */
 		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
-#endif
 	} else {
 		seq_printf(f, "%d <none>:0 ", fl_pid);
 	}
@@ -2275,9 +2277,106 @@ static const struct file_operations proc
 	.release	= seq_release_private,
 };
 
+static void lockinfo_get_status(struct seq_file *f, struct file_lock *fl,
+				loff_t id)
+{
+	struct inode *inode = NULL;
+	unsigned int fl_pid;
+
+	if (fl->fl_nspid)
+		fl_pid = pid_vnr(fl->fl_nspid);
+	else
+		fl_pid = fl->fl_pid;
+
+	if (fl->fl_file != NULL)
+		inode = fl->fl_file->f_path.dentry->d_inode;
+
+	if (IS_POSIX(fl)) {
+		seq_printf(f, "Personality:\t %s\n",
+			   (fl->fl_flags & FL_ACCESS) ? "ACCESS" : "POSIX ");
+		seq_printf(f, "Type:\t\t %s\n",
+			   (!inode) ? "*NOINODE*" : mandatory_lock(inode)
+			   ? "MANDATORY" : "ADVISORY ");
+	} else if (IS_FLOCK(fl)) {
+		seq_printf(f, "Personality:\t FLOCK\n");
+		seq_printf(f, "Type:\t\t %s\n",
+			   (fl->fl_type & LOCK_MAND) ? "MSNFS" : "ADVISORY");
+	} else if (IS_LEASE(fl)) {
+		seq_printf(f, "Personality:\t LEASE\n");
+		seq_printf(f, "Type:\t\t %s\n",
+			   (lease_breaking(fl)) ? "BREAKING"
+			   : (fl->fl_file) ? "ACTIVE" : "BREAKER");
+	} else {
+		seq_printf(f, "Personality:\t UNKNOWN\n");
+		seq_printf(f, "Type:\t\t UNKNOWN\n");
+	}
+
+	if (fl->fl_type & LOCK_MAND) {
+		seq_printf(f, "Access:\t\t %s\n",
+			   (fl->fl_type & LOCK_READ)
+			   ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
+			   : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
+	} else {
+		seq_printf(f, "Access:\t\t %s\n",
+			   (lease_breaking(fl))
+			   ? (fl->fl_type & F_UNLCK) ? "UNLCK" : "READ "
+			   : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
+	}
+
+	seq_printf(f, "PID:\t\t %d\n", fl_pid);
+
+	if (inode) {
+		seq_printf(f, "Device:\t\t %s\n",  inode->i_sb->s_id);
+		seq_printf(f, "Inode:\t\t %ld\n", inode->i_ino);
+	}
+
+	if (IS_POSIX(fl)) {
+		if (fl->fl_end == OFFSET_MAX)
+			seq_printf(f, "Start-end:\t %Ld-EOF\n\n", fl->fl_start);
+		else
+			seq_printf(f, "Start-end:\t %Ld-%Ld\n\n", fl->fl_start, fl->fl_end);
+	} else {
+		seq_printf(f, "Start-end:\t 0-EOF\n\n");
+	}
+}
+
+static int lockinfo_show(struct seq_file *f, void *v)
+{
+	struct file_lock *fl, *bfl;
+
+	fl = list_entry(v, struct file_lock, fl_link);
+
+	lockinfo_get_status(f, fl, *((loff_t *)f->private));
+
+	list_for_each_entry(bfl, &fl->fl_block, fl_block)
+		lockinfo_get_status(f, bfl, *((loff_t *)f->private));
+
+	return 0;
+}
+
+static const struct seq_operations lockinfo_seq_operations = {
+	.start	= locks_start,
+	.next	= locks_next,
+	.stop	= locks_stop,
+	.show	= lockinfo_show,
+};
+
+static int lockinfo_open(struct inode *inode, struct file *filp)
+{
+	return seq_open_private(filp, &lockinfo_seq_operations, sizeof(loff_t));
+}
+
+static const struct file_operations proc_lockinfo_operations = {
+	.open		= lockinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init proc_locks_init(void)
 {
 	proc_create("locks", 0, NULL, &proc_locks_operations);
+	proc_create("lockinfo", 0, NULL, &proc_lockinfo_operations);
 	return 0;
 }
 module_init(proc_locks_init);
_
Subject: Subject: locks: new /proc/lockinfo

Patches currently in -mm which might be from dave@gnu.org are

locks-new-proc-lockinfo.patch

