From: akpm@linux-foundation.org
Subject: [merged] fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:40 -0700
Message-ID: <20130430190140.8651331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49486 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3D3TBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:41 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87516qen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: introduce 2 new values for the -o nfs mount option
has been removed from the -mm tree.  Its filename was
     fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: introduce 2 new values for the -o nfs mount option

This patchset eliminates the client side ESTALE errors when a FAT
partition exported over NFS has its dentries evicted from the cache.  The
idea is to find the on-disk location_'i_pos' of the dirent of the inode
that has been evicted and use it to rebuild the inode.

This patch:

Provide two possible values 'stale_rw' and 'nostale_ro' for the -o nfs
mount option.The first one allows all file operations but does not reduce
ESTALE errors on memory constrained systems.  The second one eliminates
ESTALE errors but mounts the filesystem as read-only.  Not specifying a
value defaults to 'stale_rw'.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    7 +++++--
 fs/fat/inode.c |   23 ++++++++++++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/fat/fat.h~fat-introduce-2-new-values-for-the-o-nfs-mount-option fs/fat/fat.h
--- a/fs/fat/fat.h~fat-introduce-2-new-values-for-the-o-nfs-mount-option
+++ a/fs/fat/fat.h
@@ -23,6 +23,9 @@
 #define FAT_ERRORS_PANIC	2      /* panic on error */
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
+#define FAT_NFS_STALE_RW	1      /* NFS RW support, can cause ESTALE */
+#define FAT_NFS_NOSTALE_RO	2      /* NFS RO support, no ESTALE issue */
+
 struct fat_mount_options {
 	kuid_t fs_uid;
 	kgid_t fs_gid;
@@ -34,6 +37,7 @@ struct fat_mount_options {
 	unsigned short shortname;  /* flags for shortname display/create rule */
 	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	   /* On error: continue, panic, remount-ro */
+	unsigned char nfs;	  /* NFS support: nostale_ro, stale_rw */
 	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,          /* set = fake successful chmods and chowns */
 		 showexec:1,       /* set = only set x bit for com/exe/bat */
@@ -48,8 +52,7 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1,	   /* Issue discard requests on deletions */
-		 nfs:1;		   /* Do extra work needed for NFS export */
+		 discard:1;	   /* Issue discard requests on deletions */
 };
 
 #define FAT_HASH_BITS	8
diff -puN fs/fat/inode.c~fat-introduce-2-new-values-for-the-o-nfs-mount-option fs/fat/inode.c
--- a/fs/fat/inode.c~fat-introduce-2-new-values-for-the-o-nfs-mount-option
+++ a/fs/fat/inode.c
@@ -814,8 +814,6 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
-	if (opts->nfs)
-		seq_puts(m, ",nfs");
 	if (opts->showexec)
 		seq_puts(m, ",showexec");
 	if (opts->sys_immutable)
@@ -849,6 +847,10 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",errors=panic");
 	else
 		seq_puts(m, ",errors=remount-ro");
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		seq_puts(m, ",nfs=nostale_ro");
+	else if (opts->nfs)
+		seq_puts(m, ",nfs=stale_rw");
 	if (opts->discard)
 		seq_puts(m, ",discard");
 
@@ -865,7 +867,7 @@ enum {
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
-	Opt_err,
+	Opt_nfs_stale_rw, Opt_nfs_nostale_ro, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -895,7 +897,9 @@ static const match_table_t fat_tokens =
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
-	{Opt_nfs, "nfs"},
+	{Opt_nfs_stale_rw, "nfs"},
+	{Opt_nfs_stale_rw, "nfs=stale_rw"},
+	{Opt_nfs_nostale_ro, "nfs=nostale_ro"},
 	{Opt_obsolete, "conv=binary"},
 	{Opt_obsolete, "conv=text"},
 	{Opt_obsolete, "conv=auto"},
@@ -1092,6 +1096,12 @@ static int parse_options(struct super_bl
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_nfs_stale_rw:
+			opts->nfs = FAT_NFS_STALE_RW;
+			break;
+		case Opt_nfs_nostale_ro:
+			opts->nfs = FAT_NFS_NOSTALE_RO;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1150,9 +1160,6 @@ static int parse_options(struct super_bl
 		case Opt_discard:
 			opts->discard = 1;
 			break;
-		case Opt_nfs:
-			opts->nfs = 1;
-			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
@@ -1183,6 +1190,8 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		sb->s_flags |= MS_RDONLY;
 
 	return 0;
 }
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

