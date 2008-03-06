From: akpm@linux-foundation.org
Subject: - embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:28:27 -0800
Message-ID: <200803062228.m26MSRwa021182__13320.0088087053$1204843167$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757812AbYCFWi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, hch@lst.de, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
has been removed from the -mm tree.  Its filename was
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Embed a struct path into struct nameidata instead of nd->{dentry,mnt}
From: Jan Blunck <jblunck@suse.de>

Switch from nd->{dentry,mnt} to nd->path.{dentry,mnt} everywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-fsdevel@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/main.c  |    9 ++++-----
 fs/unionfs/super.c |   17 ++++++++---------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/unionfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/inode.c
diff -puN fs/unionfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/main.c
--- a/fs/unionfs/main.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
+++ a/fs/unionfs/main.c
@@ -230,11 +230,11 @@ void unionfs_reinterpose(struct dentry *
 int check_branch(struct nameidata *nd)
 {
 	/* XXX: remove in ODF code -- stacking unions allowed there */
-	if (!strcmp(nd->dentry->d_sb->s_type->name, UNIONFS_NAME))
+	if (!strcmp(nd->path.dentry->d_sb->s_type->name, UNIONFS_NAME))
 		return -EINVAL;
-	if (!nd->dentry->d_inode)
+	if (!nd->path.dentry->d_inode)
 		return -ENOENT;
-	if (!S_ISDIR(nd->dentry->d_inode->i_mode))
+	if (!S_ISDIR(nd->path.dentry->d_inode->i_mode))
 		return -ENOTDIR;
 	return 0;
 }
@@ -375,8 +375,7 @@ static int parse_dirs_option(struct supe
 			goto out;
 		}
 
-		lower_root_info->lower_paths[bindex].dentry = nd.dentry;
-		lower_root_info->lower_paths[bindex].mnt = nd.mnt;
+		lower_root_info->lower_paths[bindex] = nd.path;
 
 		set_branchperms(sb, bindex, perms);
 		set_branch_count(sb, bindex, 0);
diff -puN fs/unionfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs fs/unionfs/super.c
--- a/fs/unionfs/super.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
+++ a/fs/unionfs/super.c
@@ -223,8 +223,8 @@ static noinline int do_remount_mode_opti
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -266,8 +266,8 @@ static noinline int do_remount_del_optio
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -350,8 +350,8 @@ static noinline int do_remount_add_optio
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_release(&nd);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -417,10 +417,9 @@ found_insertion_point:
 		memmove(&new_lower_paths[idx+1], &new_lower_paths[idx],
 			(cur_branches - idx) * sizeof(struct path));
 	}
-	new_lower_paths[idx].dentry = nd.dentry;
-	new_lower_paths[idx].mnt = nd.mnt;
+	new_lower_paths[idx] = nd.path;
 
-	new_data[idx].sb = nd.dentry->d_sb;
+	new_data[idx].sb = nd.path.dentry->d_sb;
 	atomic_set(&new_data[idx].open_files, 0);
 	new_data[idx].branchperms = perms;
 	new_data[idx].branch_id = ++*high_branch_id; /* assign new branch ID */
_

Patches currently in -mm which might be from jblunck@suse.de are

git-unionfs.patch

