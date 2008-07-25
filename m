From: akpm@linux-foundation.org
Subject: - cgroup-files-clean-up-whitespace-in-struct-cftype.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:09 -0700
Message-ID: <200807252258.m6PMw9u1003262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYGYXEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: clean up whitespace in struct cftype
has been removed from the -mm tree.  Its filename was
     cgroup-files-clean-up-whitespace-in-struct-cftype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: clean up whitespace in struct cftype
From: Paul Menage <menage@google.com>

This patch removes some extraneous spaces from method declarations in
struct cftype, to fit in with conventional kernel style.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-files-clean-up-whitespace-in-struct-cftype include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-files-clean-up-whitespace-in-struct-cftype
+++ a/include/linux/cgroup.h
@@ -205,48 +205,48 @@ struct cftype {
 	 * subsystem, followed by a period */
 	char name[MAX_CFTYPE_NAME];
 	int private;
-	int (*open) (struct inode *inode, struct file *file);
-	ssize_t (*read) (struct cgroup *cgrp, struct cftype *cft,
-			 struct file *file,
-			 char __user *buf, size_t nbytes, loff_t *ppos);
+	int (*open)(struct inode *inode, struct file *file);
+	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
+			struct file *file,
+			char __user *buf, size_t nbytes, loff_t *ppos);
 	/*
 	 * read_u64() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
 	 */
-	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
+	u64 (*read_u64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_s64() is a signed version of read_u64()
 	 */
-	s64 (*read_s64) (struct cgroup *cgrp, struct cftype *cft);
+	s64 (*read_s64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_map() is used for defining a map of key/value
 	 * pairs. It should call cb->fill(cb, key, value) for each
 	 * entry. The key/value pairs (and their ordering) should not
 	 * change between reboots.
 	 */
-	int (*read_map) (struct cgroup *cont, struct cftype *cft,
-			 struct cgroup_map_cb *cb);
+	int (*read_map)(struct cgroup *cont, struct cftype *cft,
+			struct cgroup_map_cb *cb);
 	/*
 	 * read_seq_string() is used for outputting a simple sequence
 	 * using seqfile.
 	 */
-	int (*read_seq_string) (struct cgroup *cont, struct cftype *cft,
-			 struct seq_file *m);
+	int (*read_seq_string)(struct cgroup *cont, struct cftype *cft,
+			       struct seq_file *m);
 
-	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
-			  struct file *file,
-			  const char __user *buf, size_t nbytes, loff_t *ppos);
+	ssize_t (*write)(struct cgroup *cgrp, struct cftype *cft,
+			 struct file *file,
+			 const char __user *buf, size_t nbytes, loff_t *ppos);
 
 	/*
 	 * write_u64() is a shortcut for the common case of accepting
 	 * a single integer (as parsed by simple_strtoull) from
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
-	int (*write_u64) (struct cgroup *cgrp, struct cftype *cft, u64 val);
+	int (*write_u64)(struct cgroup *cgrp, struct cftype *cft, u64 val);
 	/*
 	 * write_s64() is a signed version of write_u64()
 	 */
-	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
+	int (*write_s64)(struct cgroup *cgrp, struct cftype *cft, s64 val);
 
 	/*
 	 * trigger() callback can be used to get some kick from the
@@ -256,7 +256,7 @@ struct cftype {
 	 */
 	int (*trigger)(struct cgroup *cgrp, unsigned int event);
 
-	int (*release) (struct inode *inode, struct file *file);
+	int (*release)(struct inode *inode, struct file *file);
 };
 
 struct cgroup_scanner {
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

