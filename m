From: akpm@linux-foundation.org
Subject: [merged] proc-add-and-remove-proc-entry-create-checks.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:48 -0700
Message-ID: <53ea6d84.2kO5Iw4J06eTO6ui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:58529 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaHLTjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:49 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2670659pde.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add and remove /proc entry create checks
has been removed from the -mm tree.  Its filename was
     proc-add-and-remove-proc-entry-create-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: add and remove /proc entry create checks

* remove proc_create(NULL, ...) check, let it oops

* warn about proc_create("", ...) and proc_create("very very long name", ...)
  proc code keeps length as u8, no 256+ name length possible

* warn about proc_create("123", ...)
  /proc/$PID and /proc/misc namespaces are separate things,
  but dumb module might create funky a-la $PID entry.

* remove post mortem strchr('/') check
  Triggering it implies either strchr() is buggy or memory corruption.
  It should be VFS check anyway.

In reality, none of these checks will ever trigger,
it is preparation for the next patch.

Based on patch from Al Viro.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    4 ++--
 fs/proc/fd.c       |    2 +-
 fs/proc/generic.c  |   30 +++++++++++++++---------------
 fs/proc/internal.h |    6 +++---
 4 files changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/proc/base.c~proc-add-and-remove-proc-entry-create-checks fs/proc/base.c
--- a/fs/proc/base.c~proc-add-and-remove-proc-entry-create-checks
+++ a/fs/proc/base.c
@@ -2785,7 +2785,7 @@ struct dentry *proc_pid_lookup(struct in
 	unsigned tgid;
 	struct pid_namespace *ns;
 
-	tgid = name_to_int(dentry);
+	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
 		goto out;
 
@@ -3033,7 +3033,7 @@ static struct dentry *proc_task_lookup(s
 	if (!leader)
 		goto out_no_task;
 
-	tid = name_to_int(dentry);
+	tid = name_to_int(&dentry->d_name);
 	if (tid == ~0U)
 		goto out;
 
diff -puN fs/proc/fd.c~proc-add-and-remove-proc-entry-create-checks fs/proc/fd.c
--- a/fs/proc/fd.c~proc-add-and-remove-proc-entry-create-checks
+++ a/fs/proc/fd.c
@@ -206,7 +206,7 @@ static struct dentry *proc_lookupfd_comm
 {
 	struct task_struct *task = get_proc_task(dir);
 	int result = -ENOENT;
-	unsigned fd = name_to_int(dentry);
+	unsigned fd = name_to_int(&dentry->d_name);
 
 	if (!task)
 		goto out_no_task;
diff -puN fs/proc/generic.c~proc-add-and-remove-proc-entry-create-checks fs/proc/generic.c
--- a/fs/proc/generic.c~proc-add-and-remove-proc-entry-create-checks
+++ a/fs/proc/generic.c
@@ -330,28 +330,28 @@ static struct proc_dir_entry *__proc_cre
 					  nlink_t nlink)
 {
 	struct proc_dir_entry *ent = NULL;
-	const char *fn = name;
-	unsigned int len;
-
-	/* make sure name is valid */
-	if (!name || !strlen(name))
-		goto out;
+	const char *fn;
+	struct qstr qstr;
 
 	if (xlate_proc_name(name, parent, &fn) != 0)
 		goto out;
+	qstr.name = fn;
+	qstr.len = strlen(fn);
+	if (qstr.len == 0 || qstr.len >= 256) {
+		WARN(1, "name len %u\n", qstr.len);
+		return NULL;
+	}
+	if (*parent == &proc_root && name_to_int(&qstr) != ~0U) {
+		WARN(1, "create '/proc/%s' by hand\n", qstr.name);
+		return NULL;
+	}
 
-	/* At this point there must not be any '/' characters beyond *fn */
-	if (strchr(fn, '/'))
-		goto out;
-
-	len = strlen(fn);
-
-	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	ent = kzalloc(sizeof(struct proc_dir_entry) + qstr.len + 1, GFP_KERNEL);
 	if (!ent)
 		goto out;
 
-	memcpy(ent->name, fn, len + 1);
-	ent->namelen = len;
+	memcpy(ent->name, fn, qstr.len + 1);
+	ent->namelen = qstr.len;
 	ent->mode = mode;
 	ent->nlink = nlink;
 	atomic_set(&ent->count, 1);
diff -puN fs/proc/internal.h~proc-add-and-remove-proc-entry-create-checks fs/proc/internal.h
--- a/fs/proc/internal.h~proc-add-and-remove-proc-entry-create-checks
+++ a/fs/proc/internal.h
@@ -112,10 +112,10 @@ static inline int task_dumpable(struct t
 	return 0;
 }
 
-static inline unsigned name_to_int(struct dentry *dentry)
+static inline unsigned name_to_int(const struct qstr *qstr)
 {
-	const char *name = dentry->d_name.name;
-	int len = dentry->d_name.len;
+	const char *name = qstr->name;
+	int len = qstr->len;
 	unsigned n = 0;
 
 	if (len > 1 && *name == '0')
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

