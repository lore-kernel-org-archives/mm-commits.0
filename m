From: akpm@linux-foundation.org
Subject: [folded] fs-hardlink-creation-restrictions-cleanup.patch removed from -mm tree
Date: Wed, 28 Mar 2012 15:14:13 -0700
Message-ID: <20120328221413.B079CA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37938 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2C1WOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 18:14:14 -0400
Received: by ggnd2 with SMTP id d2so196850ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 15:14:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: hardlink creation restriction cleanup
has been removed from the -mm tree.  Its filename was
     fs-hardlink-creation-restrictions-cleanup.patch

This patch was dropped because it was folded into fs-hardlink-creation-restrictions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: hardlink creation restriction cleanup

Clean-up of hardlink restriction logic, as suggested by Andrew Morton.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   62 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff -puN fs/namei.c~fs-hardlink-creation-restrictions-cleanup fs/namei.c
--- a/fs/namei.c~fs-hardlink-creation-restrictions-cleanup
+++ a/fs/namei.c
@@ -693,46 +693,72 @@ static inline int may_follow_link(struct
 }
 
 /**
+ * safe_hardlink_source - Check for safe hardlink conditions
+ * @inode: the source inode to hardlink from
+ *
+ * Return false if at least one of the following conditions:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *
+ * Otherwise returns true.
+ */
+static bool safe_hardlink_source(struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+
+	/* Special files should not get pinned to the filesystem. */
+	if (!S_ISREG(mode))
+		return false;
+
+	/* Setuid files should not get pinned to the filesystem. */
+	if (mode & S_ISUID)
+		return false;
+
+	/* Executable setgid files should not get pinned to the filesystem. */
+	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
+		return false;
+
+	/* Hardlinking to unreadable or unwritable sources is dangerous. */
+	if (inode_permission(inode, MAY_READ | MAY_WRITE))
+		return false;
+
+	return true;
+}
+
+/**
  * may_linkat - Check permissions for creating a hardlink
  * @link: the source to hardlink from
  *
  * Block hardlink when all of:
  *  - sysctl_protected_hardlinks enabled
  *  - fsuid does not match inode
- *  - at least one of:
- *    - inode is not a regular file
- *    - inode is setuid
- *    - inode is setgid and group-exec
- *    - access failure for read and write
+ *  - hardlink source is unsafe (see safe_hardlink_source() above)
  *  - not CAP_FOWNER
  *
  * Returns 0 if successful, -ve on error.
  */
 static int may_linkat(struct path *link)
 {
-	int error = 0;
 	const struct cred *cred;
 	struct inode *inode;
-	int mode;
 
 	if (!sysctl_protected_hardlinks)
 		return 0;
 
 	cred = current_cred();
 	inode = link->dentry->d_inode;
-	mode = inode->i_mode;
-
-	if (cred->fsuid != inode->i_uid &&
-	    (!S_ISREG(mode) || (mode & S_ISUID) ||
-	     ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) ||
-	     (inode_permission(inode, MAY_READ | MAY_WRITE))) &&
-	    !capable(CAP_FOWNER))
-		error = -EPERM;
 
-	if (error)
-		audit_log_link_denied("linkat", link);
+	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
+	 * otherwise, it must be a safe source.
+	 */
+	if (cred->fsuid == inode->i_uid || safe_hardlink_source(inode) ||
+	    capable(CAP_FOWNER))
+		return 0;
 
-	return error;
+	audit_log_link_denied("linkat", link);
+	return -EPERM;
 }
 #else
 static inline int may_follow_link(struct path *link)
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch

