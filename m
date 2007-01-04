From: akpm@osdl.org
Subject: + user-ns-hook-permission.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:10:28 -0800
Message-ID: <200701042210.l04MASSM000436@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965111AbXADWlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at


The patch titled
     user ns: hook permission
has been added to the -mm tree.  Its filename is
     user-ns-hook-permission.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user ns: hook permission
From: "Serge E. Hallyn" <serue@us.ibm.com>

Hook permission to check vfsmnt->user_ns against current.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namei.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN fs/namei.c~user-ns-hook-permission fs/namei.c
--- a/fs/namei.c~user-ns-hook-permission
+++ a/fs/namei.c
@@ -246,6 +246,8 @@ int permission(struct inode *inode, int 
 			return -EACCES;
 	}
 
+	if (nd && !task_mnt_same_uidns(current, nd->mnt))
+		return -EACCES;
 
 	/*
 	 * MAY_EXEC on regular files requires special handling: We override
@@ -433,6 +435,8 @@ static int exec_permission_lite(struct i
 {
 	umode_t	mode = inode->i_mode;
 
+	if (!task_mnt_same_uidns(current, nd->mnt))
+		return -EACCES;
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
