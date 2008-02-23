From: akpm@linux-foundation.org
Subject: + cgroup-clean-up-cgrouph.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:38 -0800
Message-ID: <200802230733.m1N7XRcQ018217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYBWHyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroup: clean up cgroup.h
has been added to the -mm tree.  Its filename is
     cgroup-clean-up-cgrouph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: clean up cgroup.h
From: Li Zefan <lizf@cn.fujitsu.com>

- replace old name 'cont' with 'cgrp' (Paul Menage did this cleanup for
  cgroup.c in commit bd89aabc6761de1c35b154fe6f914a445d301510)
- remove a duplicate declaration of cgroup_path()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   48 ++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-clean-up-cgrouph include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-clean-up-cgrouph
+++ a/include/linux/cgroup.h
@@ -186,15 +186,15 @@ struct cftype {
 	char name[MAX_CFTYPE_NAME];
 	int private;
 	int (*open) (struct inode *inode, struct file *file);
-	ssize_t (*read) (struct cgroup *cont, struct cftype *cft,
+	ssize_t (*read) (struct cgroup *cgrp, struct cftype *cft,
 			 struct file *file,
 			 char __user *buf, size_t nbytes, loff_t *ppos);
 	/*
 	 * read_uint() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
 	 */
-	u64 (*read_uint) (struct cgroup *cont, struct cftype *cft);
-	ssize_t (*write) (struct cgroup *cont, struct cftype *cft,
+	u64 (*read_uint) (struct cgroup *cgrp, struct cftype *cft);
+	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
 
@@ -203,7 +203,7 @@ struct cftype {
 	 * a single integer (as parsed by simple_strtoull) from
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
-	int (*write_uint) (struct cgroup *cont, struct cftype *cft, u64 val);
+	int (*write_uint) (struct cgroup *cgrp, struct cftype *cft, u64 val);
 
 	int (*release) (struct inode *inode, struct file *file);
 };
@@ -218,41 +218,41 @@ struct cgroup_scanner {
 
 /* Add a new file to the given cgroup directory. Should only be
  * called by subsystems from within a populate() method */
-int cgroup_add_file(struct cgroup *cont, struct cgroup_subsys *subsys,
+int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		       const struct cftype *cft);
 
 /* Add a set of new files to the given cgroup directory. Should
  * only be called by subsystems from within a populate() method */
-int cgroup_add_files(struct cgroup *cont,
+int cgroup_add_files(struct cgroup *cgrp,
 			struct cgroup_subsys *subsys,
 			const struct cftype cft[],
 			int count);
 
-int cgroup_is_removed(const struct cgroup *cont);
+int cgroup_is_removed(const struct cgroup *cgrp);
 
-int cgroup_path(const struct cgroup *cont, char *buf, int buflen);
+int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
-int cgroup_task_count(const struct cgroup *cont);
+int cgroup_task_count(const struct cgroup *cgrp);
 
 /* Return true if the cgroup is a descendant of the current cgroup */
-int cgroup_is_descendant(const struct cgroup *cont);
+int cgroup_is_descendant(const struct cgroup *cgrp);
 
 /* Control Group subsystem type. See Documentation/cgroups.txt for details */
 
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
-						  struct cgroup *cont);
-	void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cont);
-	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cont);
+						  struct cgroup *cgrp);
+	void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
+	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss,
-			  struct cgroup *cont, struct task_struct *tsk);
-	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cont,
-			struct cgroup *old_cont, struct task_struct *tsk);
+			  struct cgroup *cgrp, struct task_struct *tsk);
+	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
+			struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
 	void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
 	int (*populate)(struct cgroup_subsys *ss,
-			struct cgroup *cont);
-	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cont);
+			struct cgroup *cgrp);
+	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 	int subsys_id;
 	int active;
@@ -273,9 +273,9 @@ struct cgroup_subsys {
 #undef SUBSYS
 
 static inline struct cgroup_subsys_state *cgroup_subsys_state(
-	struct cgroup *cont, int subsys_id)
+	struct cgroup *cgrp, int subsys_id)
 {
-	return cont->subsys[subsys_id];
+	return cgrp->subsys[subsys_id];
 }
 
 static inline struct cgroup_subsys_state *task_subsys_state(
@@ -290,8 +290,6 @@ static inline struct cgroup* task_cgroup
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
-int cgroup_path(const struct cgroup *cont, char *buf, int buflen);
-
 int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss);
 
 /* A cgroup_iter should be treated as an opaque object */
@@ -313,10 +311,10 @@ struct cgroup_iter {
  *    - cgroup_scan_tasks() holds the css_set_lock when calling the test_task()
  *      callback, but not while calling the process_task() callback.
  */
-void cgroup_iter_start(struct cgroup *cont, struct cgroup_iter *it);
-struct task_struct *cgroup_iter_next(struct cgroup *cont,
+void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it);
+struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
 					struct cgroup_iter *it);
-void cgroup_iter_end(struct cgroup *cont, struct cgroup_iter *it);
+void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroup-fix-and-update-documentation.patch
cgroup-fix-comments.patch
cgroup-clean-up-cgrouph.patch
cgroup-fix-memory-leak-in-cgroup_get_sb.patch
cgroup-fix-subsys-bitops.patch
cgroup-remove-duplicate-code-in-find_css_set.patch
cgroup-remove-dead-code-in-cgroup_get_rootdir.patch
memcgroup-fix-and-update-documentation.patch
memcgroup-remove-a-useless-vm_bug_on.patch
memcgroup-return-negative-error-code-in-mem_cgroup_create.patch
