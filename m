From: akpm@linux-foundation.org
Subject: + fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:36:34 -0700
Message-ID: <20130314213634.D9FE15A4213@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52901 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3CNVgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:36:36 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so268852vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:36:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: introduce 2 new values for the -o nfs mount option
has been added to the -mm tree.  Its filename is
     fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fat-introduce-2-new-values-for-the-o-nfs-mount-option.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-introduce-a-helper-fat_get_blknr_offset.patch
fat-restructure-export_operations.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

