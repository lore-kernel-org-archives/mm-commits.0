From: akpm@linux-foundation.org
Subject: [merged] kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:57 -0700
Message-ID: <53960c9d.aeGR2ITfVs32WCvQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaFITf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, fabf@skynet.be

Subject: [merged] kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch removed from -mm tree
To: fabf@skynet.be,oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:57 -0700


The patch titled
     Subject: kernel/user_namespace.c: kernel-doc/checkpatch fixes
has been removed from the -mm tree.  Its filename was
     kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/user_namespace.c: kernel-doc/checkpatch fixes

-uid->gid
-split some function declarations
-if/then/else warning

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN kernel/user_namespace.c~kernel-user_namespacec-kernel-doc-checkpatch-fixes kernel/user_namespace.c
--- a/kernel/user_namespace.c~kernel-user_namespacec-kernel-doc-checkpatch-fixes
+++ a/kernel/user_namespace.c
@@ -286,7 +286,7 @@ EXPORT_SYMBOL(from_kuid_munged);
 /**
  *	make_kgid - Map a user-namespace gid pair into a kgid.
  *	@ns:  User namespace that the gid is in
- *	@uid: group identifier
+ *	@gid: group identifier
  *
  *	Maps a user-namespace gid pair into a kernel internal kgid,
  *	and returns that kgid.
@@ -482,7 +482,8 @@ static int projid_m_show(struct seq_file
 	return 0;
 }
 
-static void *m_start(struct seq_file *seq, loff_t *ppos, struct uid_gid_map *map)
+static void *m_start(struct seq_file *seq, loff_t *ppos,
+		     struct uid_gid_map *map)
 {
 	struct uid_gid_extent *extent = NULL;
 	loff_t pos = *ppos;
@@ -546,7 +547,8 @@ struct seq_operations proc_projid_seq_op
 	.show = projid_m_show,
 };
 
-static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent *extent)
+static bool mappings_overlap(struct uid_gid_map *new_map,
+			     struct uid_gid_extent *extent)
 {
 	u32 upper_first, lower_first, upper_last, lower_last;
 	unsigned idx;
@@ -653,7 +655,7 @@ static ssize_t map_write(struct file *fi
 	ret = -EINVAL;
 	pos = kbuf;
 	new_map.nr_extents = 0;
-	for (;pos; pos = next_line) {
+	for (; pos; pos = next_line) {
 		extent = &new_map.extent[new_map.nr_extents];
 
 		/* Find the end of line and ensure I don't look past it */
@@ -687,13 +689,16 @@ static ssize_t map_write(struct file *fi
 
 		/* Verify we have been given valid starting values */
 		if ((extent->first == (u32) -1) ||
-		    (extent->lower_first == (u32) -1 ))
+		    (extent->lower_first == (u32) -1))
 			goto out;
 
-		/* Verify count is not zero and does not cause the extent to wrap */
+		/* Verify count is not zero and does not cause the
+		 * extent to wrap
+		 */
 		if ((extent->first + extent->count) <= extent->first)
 			goto out;
-		if ((extent->lower_first + extent->count) <= extent->lower_first)
+		if ((extent->lower_first + extent->count) <=
+		     extent->lower_first)
 			goto out;
 
 		/* Do the ranges in extent overlap any previous extents? */
@@ -751,7 +756,8 @@ out:
 	return ret;
 }
 
-ssize_t proc_uid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_uid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -767,7 +773,8 @@ ssize_t proc_uid_map_write(struct file *
 			 &ns->uid_map, &ns->parent->uid_map);
 }
 
-ssize_t proc_gid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_gid_map_write(struct file *file, const char __user *buf,
+			   size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -783,7 +790,8 @@ ssize_t proc_gid_map_write(struct file *
 			 &ns->gid_map, &ns->parent->gid_map);
 }
 
-ssize_t proc_projid_map_write(struct file *file, const char __user *buf, size_t size, loff_t *ppos)
+ssize_t proc_projid_map_write(struct file *file, const char __user *buf,
+			      size_t size, loff_t *ppos)
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *ns = seq->private;
@@ -800,7 +808,7 @@ ssize_t proc_projid_map_write(struct fil
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
-static bool new_idmap_permitted(const struct file *file, 
+static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
@@ -811,8 +819,7 @@ static bool new_idmap_permitted(const st
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
-		}
-		else if (cap_setid == CAP_SETGID) {
+		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
 			if (gid_eq(gid, file->f_cred->fsgid))
 				return true;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

