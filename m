From: akpm@osdl.org
Subject: + user-ns-implement-shared-mounts-fixes.patch added to -mm tree
Date: Fri, 05 Jan 2007 00:11:46 -0800
Message-ID: <200701050811.l058Bk4B013760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161000AbXAEIPA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 03:15:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com


The patch titled
     user ns fixes
has been added to the -mm tree.  Its filename is
     user-ns-implement-shared-mounts-fixes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user ns fixes
From: "Serge E. Hallyn" <serue@us.ibm.com>

Don't do user_ns permission checks when !CONFIG_USER_NS.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/namespace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/namespace.c~user-ns-implement-shared-mounts-fixes fs/namespace.c
--- a/fs/namespace.c~user-ns-implement-shared-mounts-fixes
+++ a/fs/namespace.c
@@ -236,10 +236,8 @@ static struct vfsmount *clone_mnt(struct
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt;
 
-	if (!(old->mnt_flags & MNT_SHARE_NS)) {
-		if (old->mnt_user_ns != current->nsproxy->user_ns)
-			return ERR_PTR(-EPERM);
-	}
+	if (!clone_mnt_userns_permission(old))
+		return ERR_PTR(-EPERM);
 
 	mnt = alloc_vfsmnt(old->mnt_devname);
 
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-always-on.patch
integrity-service-api-and-dummy-provider-fix.patch
