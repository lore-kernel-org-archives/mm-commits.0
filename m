From: akpm@linux-foundation.org
Subject: - cgroups-introduce-cft-read_seq-v2.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:52 -0700
Message-ID: <200804300542.m3U5gqtN029180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbYD3FtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: introduce cft->read_seq()
has been removed from the -mm tree.  Its filename was
     cgroups-introduce-cft-read_seq-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: introduce cft->read_seq()
From: Serge E. Hallyn <serue@us.ibm.com>

Introduce a read_seq() helper in cftype, which uses seq_file to print out
lists.  Use it in the devices cgroup.  Also split devices.allow into two
files, so now devices.deny and devices.allow are the ones to use to manipulate
the whitelist, while devices.list outputs the cgroup's current whitelist.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h   |    6 +++
 kernel/cgroup.c          |   15 ++++---
 security/device_cgroup.c |   74 +++++++++++--------------------------
 3 files changed, 38 insertions(+), 57 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-introduce-cft-read_seq-v2 include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-introduce-cft-read_seq-v2
+++ a/include/linux/cgroup.h
@@ -226,6 +226,12 @@ struct cftype {
 	 */
 	int (*read_map) (struct cgroup *cont, struct cftype *cft,
 			 struct cgroup_map_cb *cb);
+	/*
+	 * read_seq_string() is used for outputting a simple sequence
+	 * using seqfile.
+	 */
+	int (*read_seq_string) (struct cgroup *cont, struct cftype *cft,
+			 struct seq_file *m);
 
 	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
 			  struct file *file,
diff -puN kernel/cgroup.c~cgroups-introduce-cft-read_seq-v2 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-introduce-cft-read_seq-v2
+++ a/kernel/cgroup.c
@@ -1549,11 +1549,14 @@ static int cgroup_seqfile_show(struct se
 {
 	struct cgroup_seqfile_state *state = m->private;
 	struct cftype *cft = state->cft;
-	struct cgroup_map_cb cb = {
-		.fill = cgroup_map_add,
-		.state = m,
-	};
-	return cft->read_map(state->cgroup, cft, &cb);
+	if (cft->read_map) {
+		struct cgroup_map_cb cb = {
+			.fill = cgroup_map_add,
+			.state = m,
+		};
+		return cft->read_map(state->cgroup, cft, &cb);
+	}
+	return cft->read_seq_string(state->cgroup, cft, m);
 }
 
 int cgroup_seqfile_release(struct inode *inode, struct file *file)
@@ -1581,7 +1584,7 @@ static int cgroup_file_open(struct inode
 	cft = __d_cft(file->f_dentry);
 	if (!cft)
 		return -ENODEV;
-	if (cft->read_map) {
+	if (cft->read_map || cft->read_seq_string) {
 		struct cgroup_seqfile_state *state =
 			kzalloc(sizeof(*state), GFP_USER);
 		if (!state)
diff -puN security/device_cgroup.c~cgroups-introduce-cft-read_seq-v2 security/device_cgroup.c
--- a/security/device_cgroup.c~cgroups-introduce-cft-read_seq-v2
+++ a/security/device_cgroup.c
@@ -9,6 +9,7 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/uaccess.h>
+#include <linux/seq_file.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
@@ -201,11 +202,15 @@ static void devcgroup_destroy(struct cgr
 
 #define DEVCG_ALLOW 1
 #define DEVCG_DENY 2
+#define DEVCG_LIST 3
+
+#define MAJMINLEN 10
+#define ACCLEN 4
 
 static void set_access(char *acc, short access)
 {
 	int idx = 0;
-	memset(acc, 0, 4);
+	memset(acc, 0, ACCLEN);
 	if (access & ACC_READ)
 		acc[idx++] = 'r';
 	if (access & ACC_WRITE)
@@ -225,70 +230,33 @@ static char type_to_char(short type)
 	return 'X';
 }
 
-static void set_majmin(char *str, int len, unsigned m)
+static void set_majmin(char *str, unsigned m)
 {
-	memset(str, 0, len);
+	memset(str, 0, MAJMINLEN);
 	if (m == ~0)
 		sprintf(str, "*");
 	else
-		snprintf(str, len, "%d", m);
+		snprintf(str, MAJMINLEN, "%d", m);
 }
 
-static char *print_whitelist(struct dev_cgroup *devcgroup, int *len)
+static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				struct seq_file *m)
 {
-	char *buf, *s, acc[4];
+	struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
 	struct dev_whitelist_item *wh;
-	int ret;
-	int count = 0;
-	char maj[10], min[10];
-
-	buf = kmalloc(4096, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-	s = buf;
-	*s = '\0';
-	*len = 0;
+	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
 
 	spin_lock(&devcgroup->lock);
 	list_for_each_entry(wh, &devcgroup->whitelist, list) {
 		set_access(acc, wh->access);
-		set_majmin(maj, 10, wh->major);
-		set_majmin(min, 10, wh->minor);
-		ret = snprintf(s, 4095-(s-buf), "%c %s:%s %s\n",
-			type_to_char(wh->type), maj, min, acc);
-		if (s+ret >= buf+4095) {
-			kfree(buf);
-			buf = ERR_PTR(-ENOMEM);
-			break;
-		}
-		s += ret;
-		*len += ret;
-		count++;
+		set_majmin(maj, wh->major);
+		set_majmin(min, wh->minor);
+		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
+			   maj, min, acc);
 	}
 	spin_unlock(&devcgroup->lock);
 
-	return buf;
-}
-
-static ssize_t devcgroup_access_read(struct cgroup *cgroup,
-			struct cftype *cft, struct file *file,
-			char __user *userbuf, size_t nbytes, loff_t *ppos)
-{
-	struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
-	int filetype = cft->private;
-	char *buffer;
-	int uninitialized_var(len);
-	int retval;
-
-	if (filetype != DEVCG_ALLOW)
-		return -EINVAL;
-	buffer = print_whitelist(devcgroup, &len);
-	if (IS_ERR(buffer))
-		return PTR_ERR(buffer);
-
-	retval = simple_read_from_buffer(userbuf, nbytes, ppos, buffer, len);
-	kfree(buffer);
-	return retval;
+	return 0;
 }
 
 /*
@@ -501,7 +469,6 @@ out1:
 static struct cftype dev_cgroup_files[] = {
 	{
 		.name = "allow",
-		.read = devcgroup_access_read,
 		.write  = devcgroup_access_write,
 		.private = DEVCG_ALLOW,
 	},
@@ -510,6 +477,11 @@ static struct cftype dev_cgroup_files[] 
 		.write = devcgroup_access_write,
 		.private = DEVCG_DENY,
 	},
+	{
+		.name = "list",
+		.read_seq_string = devcgroup_seq_read,
+		.private = DEVCG_LIST,
+	},
 };
 
 static int devcgroup_populate(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
devpts-propagate-error-code-from-devpts_pty_new.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch
reiser4-replace-uid==0-check-with-capability.patch

