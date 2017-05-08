From: akpm@linux-foundation.org
Subject: [patch 093/114] fs: cifs: replace CURRENT_TIME by other
 appropriate apis
Date: Mon, 08 May 2017 15:59:16 -0700
Message-ID: <20170508225916.Iz2aVyMEm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdEHW7R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, deepa.kernel@gmail.com, mm-commits@vger.kernel.org, sfrench@samba.org, torvalds@linux-foundation.org

From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: cifs: replace CURRENT_TIME by other appropriate apis

CURRENT_TIME macro is not y2038 safe on 32 bit systems.

The patch replaces all the uses of CURRENT_TIME by current_time() for
filesystem times, and ktime_get_* functions for authentication timestamps
and timezone calculations.

This is also in preparation for the patch that transitions vfs timestamps
to use 64 bit time and hence make them y2038 safe.

CURRENT_TIME macro will be deleted before merging the aforementioned
change.

The inode timestamps read from the server are assumed to have correct
granularity and range.

The patch also assumes that the difference between server and client times
lie in the range INT_MIN..INT_MAX.  This is valid because this is the
difference between current times between server and client, and the
largest timezone difference is in the range of one day.

All cifs timestamps currently use timespec representation internally. 
Authentication and timezone timestamps can also be transitioned into using
timespec64 when all other timestamps for cifs is transitioned to use
timespec64.

Link: http://lkml.kernel.org/r/1491613030-11599-4-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsencrypt.c |    4 +++-
 fs/cifs/cifssmb.c     |   10 +++++-----
 fs/cifs/inode.c       |   28 +++++++++++++++-------------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff -puN fs/cifs/cifsencrypt.c~fs-cifs-replace-current_time-by-other-appropriate-apis fs/cifs/cifsencrypt.c
--- a/fs/cifs/cifsencrypt.c~fs-cifs-replace-current_time-by-other-appropriate-apis
+++ a/fs/cifs/cifsencrypt.c
@@ -478,6 +478,7 @@ find_timestamp(struct cifs_ses *ses)
 	unsigned char *blobptr;
 	unsigned char *blobend;
 	struct ntlmssp2_name *attrptr;
+	struct timespec ts;
 
 	if (!ses->auth_key.len || !ses->auth_key.response)
 		return 0;
@@ -502,7 +503,8 @@ find_timestamp(struct cifs_ses *ses)
 		blobptr += attrsize; /* advance attr value */
 	}
 
-	return cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
+	ktime_get_real_ts(&ts);
+	return cpu_to_le64(cifs_UnixTimeToNT(ts));
 }
 
 static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
diff -puN fs/cifs/cifssmb.c~fs-cifs-replace-current_time-by-other-appropriate-apis fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c~fs-cifs-replace-current_time-by-other-appropriate-apis
+++ a/fs/cifs/cifssmb.c
@@ -478,14 +478,14 @@ decode_lanman_negprot_rsp(struct TCP_Ser
 		 * this requirement.
 		 */
 		int val, seconds, remain, result;
-		struct timespec ts, utc;
-		utc = CURRENT_TIME;
+		struct timespec ts;
+		unsigned long utc = ktime_get_real_seconds();
 		ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 				    rsp->SrvTime.Time, 0);
 		cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
-			 (int)ts.tv_sec, (int)utc.tv_sec,
-			 (int)(utc.tv_sec - ts.tv_sec));
-		val = (int)(utc.tv_sec - ts.tv_sec);
+			 (int)ts.tv_sec, (int)utc,
+			 (int)(utc - ts.tv_sec));
+		val = (int)(utc - ts.tv_sec);
 		seconds = abs(val);
 		result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
 		remain = seconds % MIN_TZ_ADJ;
diff -puN fs/cifs/inode.c~fs-cifs-replace-current_time-by-other-appropriate-apis fs/cifs/inode.c
--- a/fs/cifs/inode.c~fs-cifs-replace-current_time-by-other-appropriate-apis
+++ a/fs/cifs/inode.c
@@ -322,9 +322,9 @@ cifs_create_dfs_fattr(struct cifs_fattr
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
 	fattr->cf_uid = cifs_sb->mnt_uid;
 	fattr->cf_gid = cifs_sb->mnt_gid;
-	fattr->cf_atime = CURRENT_TIME;
-	fattr->cf_ctime = CURRENT_TIME;
-	fattr->cf_mtime = CURRENT_TIME;
+	ktime_get_real_ts(&fattr->cf_mtime);
+	fattr->cf_mtime = timespec_trunc(fattr->cf_mtime, sb->s_time_gran);
+	fattr->cf_atime = fattr->cf_ctime = fattr->cf_mtime;
 	fattr->cf_nlink = 2;
 	fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
 }
@@ -586,9 +586,10 @@ static int cifs_sfu_mode(struct cifs_fat
 /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
 static void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
-		       struct cifs_sb_info *cifs_sb, bool adjust_tz,
+		       struct super_block *sb, bool adjust_tz,
 		       bool symlink)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	memset(fattr, 0, sizeof(*fattr));
@@ -598,8 +599,10 @@ cifs_all_info_to_fattr(struct cifs_fattr
 
 	if (info->LastAccessTime)
 		fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
-	else
-		fattr->cf_atime = CURRENT_TIME;
+	else {
+		ktime_get_real_ts(&fattr->cf_atime);
+		fattr->cf_atime = timespec_trunc(fattr->cf_atime, sb->s_time_gran);
+	}
 
 	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
@@ -659,7 +662,6 @@ cifs_get_file_info(struct file *filp)
 	FILE_ALL_INFO find_data;
 	struct cifs_fattr fattr;
 	struct inode *inode = file_inode(filp);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile = filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -671,7 +673,7 @@ cifs_get_file_info(struct file *filp)
 	rc = server->ops->query_file_info(xid, tcon, &cfile->fid, &find_data);
 	switch (rc) {
 	case 0:
-		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false,
+		cifs_all_info_to_fattr(&fattr, &find_data, inode->i_sb, false,
 				       false);
 		break;
 	case -EREMOTE:
@@ -753,7 +755,7 @@ cifs_get_inode_info(struct inode **inode
 	}
 
 	if (!rc) {
-		cifs_all_info_to_fattr(&fattr, data, cifs_sb, adjust_tz,
+		cifs_all_info_to_fattr(&fattr, data, sb, adjust_tz,
 				       symlink);
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, sb);
@@ -1363,9 +1365,9 @@ out_reval:
 		cifs_inode = CIFS_I(inode);
 		cifs_inode->time = 0;	/* will force revalidate to get info
 					   when needed */
-		inode->i_ctime = current_fs_time(sb);
+		inode->i_ctime = current_time(inode);
 	}
-	dir->i_ctime = dir->i_mtime = current_fs_time(sb);
+	dir->i_ctime = dir->i_mtime = current_time(dir);
 	cifs_inode = CIFS_I(dir);
 	CIFS_I(dir)->time = 0;	/* force revalidate of dir as well */
 unlink_out:
@@ -1633,7 +1635,7 @@ int cifs_rmdir(struct inode *inode, stru
 	cifsInode->time = 0;
 
 	d_inode(direntry)->i_ctime = inode->i_ctime = inode->i_mtime =
-		current_fs_time(inode->i_sb);
+		current_time(inode);
 
 rmdir_exit:
 	kfree(full_path);
@@ -1806,7 +1808,7 @@ unlink_target:
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
-		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+		target_dir->i_mtime = current_time(source_dir);
 
 cifs_rename_exit:
 	kfree(info_buf_source);
_
