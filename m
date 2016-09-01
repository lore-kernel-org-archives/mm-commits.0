From: akpm@linux-foundation.org
Subject: + proc-unsigned-file-descriptors.patch added to -mm tree
Date: Thu, 01 Sep 2016 15:01:55 -0700
Message-ID: <57c8a553.T9jlbOf7HLKzUEW6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbcIAWB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 18:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: unsigned file descriptors
has been added to the -mm tree.  Its filename is
     proc-unsigned-file-descriptors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-unsigned-file-descriptors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-unsigned-file-descriptors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: unsigned file descriptors

Make struct proc_inode::fd unsigned.

This allows better code generation on x86_64 (less sign extensions).

Link: http://lkml.kernel.org/r/20160901214202.GB7453@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c       |    8 ++++----
 fs/proc/fd.h       |    2 +-
 fs/proc/internal.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/fd.c~proc-unsigned-file-descriptors fs/proc/fd.c
--- a/fs/proc/fd.c~proc-unsigned-file-descriptors
+++ a/fs/proc/fd.c
@@ -31,7 +31,7 @@ static int seq_show(struct seq_file *m,
 	put_task_struct(task);
 
 	if (files) {
-		int fd = proc_fd(m->private);
+		unsigned int fd = proc_fd(m->private);
 
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
@@ -86,7 +86,7 @@ static int tid_fd_revalidate(struct dent
 	struct task_struct *task;
 	const struct cred *cred;
 	struct inode *inode;
-	int fd;
+	unsigned int fd;
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
@@ -158,7 +158,7 @@ static int proc_fd_link(struct dentry *d
 	}
 
 	if (files) {
-		int fd = proc_fd(d_inode(dentry));
+		unsigned int fd = proc_fd(d_inode(dentry));
 		struct file *fd_file;
 
 		spin_lock(&files->file_lock);
@@ -253,7 +253,7 @@ static int proc_readfd_common(struct fil
 			continue;
 		rcu_read_unlock();
 
-		len = snprintf(name, sizeof(name), "%d", fd);
+		len = snprintf(name, sizeof(name), "%u", fd);
 		if (!proc_fill_cache(file, ctx,
 				     name, len, instantiate, p,
 				     (void *)(unsigned long)fd))
diff -puN fs/proc/fd.h~proc-unsigned-file-descriptors fs/proc/fd.h
--- a/fs/proc/fd.h~proc-unsigned-file-descriptors
+++ a/fs/proc/fd.h
@@ -11,7 +11,7 @@ extern const struct inode_operations pro
 
 extern int proc_fd_permission(struct inode *inode, int mask);
 
-static inline int proc_fd(struct inode *inode)
+static inline unsigned int proc_fd(struct inode *inode)
 {
 	return PROC_I(inode)->fd;
 }
diff -puN fs/proc/internal.h~proc-unsigned-file-descriptors fs/proc/internal.h
--- a/fs/proc/internal.h~proc-unsigned-file-descriptors
+++ a/fs/proc/internal.h
@@ -60,7 +60,7 @@ union proc_op {
 
 struct proc_inode {
 	struct pid *pid;
-	int fd;
+	unsigned int fd;
 	union proc_op op;
 	struct proc_dir_entry *pde;
 	struct ctl_table_header *sysctl;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
mm-unrig-vma-cache-hit-ratio.patch
proc-much-faster-proc-vmstat.patch
proc-faster-proc-status.patch
proc-unsigned-file-descriptors.patch
cred-simpler-1d-supplementary-groups.patch
make-isdigit-table-lookupless.patch
kstrtox-smaller-_parse_integer.patch

