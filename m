From: akpm@linux-foundation.org
Subject: - nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:20 -0700
Message-ID: <200810092228.m99MSKW0006063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbYJIW2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: ERR_PTR is expected on failure from nfs_do_clone_mount
has been removed from the -mm tree.  Its filename was
     nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: ERR_PTR is expected on failure from nfs_do_clone_mount
From: "Denis V. Lunev" <den@openvz.org>

Replace NULL with ERR_PTR(-EINVAL).

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/namespace.c~nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~nfs-err_ptr-is-expected-on-failure-from-nfs_do_clone_mount
+++ a/fs/nfs/namespace.c
@@ -189,7 +189,7 @@ static struct vfsmount *nfs_do_clone_mou
 					   struct nfs_clone_mount *mountdata)
 {
 #ifdef CONFIG_NFS_V4
-	struct vfsmount *mnt = NULL;
+	struct vfsmount *mnt = ERR_PTR(-EINVAL);
 	switch (server->nfs_client->rpc_ops->version) {
 		case 2:
 		case 3:
_

Patches currently in -mm which might be from den@openvz.org are

git-nfs.patch
git-net.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

