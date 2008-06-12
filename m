From: akpm@linux-foundation.org
Subject: - cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:48 -0700
Message-ID: <200806122036.m5CKamEl005365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbYFLUhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, sfrench@samba.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
has been removed from the -mm tree.  Its filename was
     cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
From: Marcin Slusarz <marcin.slusarz@gmail.com>

simple "mount -t cifs //xxx /mnt" oopsed on strlen of options
http://kerneloops.org/guilty.php?guilty=cifs_get_sb&version=2.6.25-release&start=1671168&end=1703935&class=oops

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/cifs/cifsfs.c~cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~cifs-fix-oops-on-mount-when-config_cifs_dfs_upcall-is-enabled
+++ a/fs/cifs/cifsfs.c
@@ -124,9 +124,6 @@ cifs_read_super(struct super_block *sb, 
 {
 	struct inode *inode;
 	struct cifs_sb_info *cifs_sb;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	int len;
-#endif
 	int rc = 0;
 
 	/* BB should we make this contingent on mount parm? */
@@ -144,15 +141,17 @@ cifs_read_super(struct super_block *sb, 
 	 * complex operation (mount), and in case of fail
 	 * just exit instead of doing mount and attempting
 	 * undo it if this copy fails?*/
-	len = strlen(data);
-	cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
-	if (cifs_sb->mountdata == NULL) {
-		kfree(sb->s_fs_info);
-		sb->s_fs_info = NULL;
-		return -ENOMEM;
+	if (data) {
+		int len = strlen(data);
+		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
+		if (cifs_sb->mountdata == NULL) {
+			kfree(sb->s_fs_info);
+			sb->s_fs_info = NULL;
+			return -ENOMEM;
+		}
+		strncpy(cifs_sb->mountdata, data, len + 1);
+		cifs_sb->mountdata[len] = '\0';
 	}
-	strncpy(cifs_sb->mountdata, data, len + 1);
-	cifs_sb->mountdata[len] = '\0';
 #endif
 
 	rc = cifs_mount(sb, cifs_sb, data, devname);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch

