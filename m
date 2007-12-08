From: akpm@linux-foundation.org
Subject: - lost-content-of-proc-sys-fs-binfmt_misc.patch removed from -mm tree
Date: Fri, 07 Dec 2007 16:19:41 -0800
Message-ID: <200712080019.lB80JgaC010872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbXLHAU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 19:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, cate@debian.org, ebiederm@xmission.com, marcus@better.se, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     lost content of /proc/sys/fs/binfmt_misc
has been removed from the -mm tree.  Its filename was
     lost-content-of-proc-sys-fs-binfmt_misc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lost content of /proc/sys/fs/binfmt_misc
From: "Denis V. Lunev" <den@openvz.org>

/proc/sys/fs/binfmt_misc dentry disappeared during d_revalidate. 
d_revalidate only dentries from shadowed one and below. 
http://bugzilla.kernel.org/show_bug.cgi?id=9504

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Marcus Better <marcus@better.se>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Marcus Better <marcus@better.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~lost-content-of-proc-sys-fs-binfmt_misc fs/proc/generic.c
--- a/fs/proc/generic.c~lost-content-of-proc-sys-fs-binfmt_misc
+++ a/fs/proc/generic.c
@@ -380,12 +380,17 @@ static int proc_revalidate_dentry(struct
 	return 0;
 }
 
-static struct dentry_operations proc_dentry_operations =
+static struct dentry_operations proc_dentry_shadow_operations =
 {
 	.d_delete	= proc_delete_dentry,
 	.d_revalidate	= proc_revalidate_dentry,
 };
 
+static struct dentry_operations proc_dentry_operations =
+{
+	.d_delete	= proc_delete_dentry,
+};
+
 /*
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
@@ -394,6 +399,7 @@ struct dentry *proc_lookup(struct inode 
 {
 	struct inode *inode = NULL;
 	struct proc_dir_entry * de;
+	int use_shadow = 0;
 	int error = -ENOENT;
 
 	lock_kernel();
@@ -406,8 +412,10 @@ struct dentry *proc_lookup(struct inode 
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 				unsigned int ino;
 
-				if (de->shadow_proc)
+				if (de->shadow_proc) {
 					de = de->shadow_proc(current, de);
+					use_shadow = 1;
+				}
 				ino = de->low_ino;
 				de_get(de);
 				spin_unlock(&proc_subdir_lock);
@@ -423,6 +431,8 @@ struct dentry *proc_lookup(struct inode 
 
 	if (inode) {
 		dentry->d_op = &proc_dentry_operations;
+		dentry->d_op = use_shadow ?
+			&proc_dentry_shadow_operations : dentry->d_parent->d_op;
 		d_add(dentry, inode);
 		return NULL;
 	}
_

Patches currently in -mm which might be from den@openvz.org are

revert-fix-proc-net-breakage.patch
lost-content-of-proc-sys-fs-binfmt_misc.patch
lost-content-of-proc-sys-fs-binfmt_misc-checkpatch-fixes.patch
git-net.patch
