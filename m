From: akpm@linux-foundation.org
Subject: + fat-modify-nfs-mount-option.patch added to -mm tree
Date: Tue, 09 Oct 2012 11:59:27 -0700
Message-ID: <20121009185927.716701E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54344 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2JIS72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:59:28 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so670146ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:59:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: modify nfs mount option
has been added to the -mm tree.  Its filename is
     fat-modify-nfs-mount-option.patch

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
Subject: fat: modify nfs mount option

This patchset eliminates the client side ESTALE errors when a FAT
partition exported over NFS has its dentries evicted from the cache.

One of the reasons for this error is lack of permanent inode numbers on
FAT which makes it difficult to construct persistent file handles.  This
can be overcome by using fat_encode_fh() that include i_pos in file
handle.

Once the i_pos is available, it is only a matter of reading the directory
entries from the disk clusters to locate the matching entry and rebuild
the corresponding inode.

We reached the conclusion support stable inode's read-only export first
after discussing with OGAWA and Bruce.  And will make it writable with
some operation(unlink and rename) limitation next time.



This patch:

Provide two possible values 'stale_rw' and 'nostale_ro' for the -o nfs
mount option.  The first one allows all file operations but does not
reduce ESTALE errors on memory constrained systems.  The second one
eliminates ESTALE errors but mounts the filesystem as read-only.  Not
specifying a value defaults to 'stale_rw'.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    7 +++++--
 fs/fat/inode.c |   24 +++++++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff -puN fs/fat/fat.h~fat-modify-nfs-mount-option fs/fat/fat.h
--- a/fs/fat/fat.h~fat-modify-nfs-mount-option
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
@@ -33,6 +36,7 @@ struct fat_mount_options {
 	unsigned short shortname;  /* flags for shortname display/create rule */
 	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	   /* On error: continue, panic, remount-ro */
+	unsigned char nfs;	   /* NFS support: nostale_ro, stale_rw */
 	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,          /* set = fake successful chmods and chowns */
 		 showexec:1,       /* set = only set x bit for com/exe/bat */
@@ -47,8 +51,7 @@ struct fat_mount_options {
 		 usefree:1,	   /* Use free_clusters for FAT32 */
 		 tz_utc:1,	   /* Filesystem timestamps are in UTC */
 		 rodir:1,	   /* allow ATTR_RO for directory */
-		 discard:1,	   /* Issue discard requests on deletions */
-		 nfs:1;		   /* Do extra work needed for NFS export */
+		 discard:1;	   /* Issue discard requests on deletions */
 };
 
 #define FAT_HASH_BITS	8
diff -puN fs/fat/inode.c~fat-modify-nfs-mount-option fs/fat/inode.c
--- a/fs/fat/inode.c~fat-modify-nfs-mount-option
+++ a/fs/fat/inode.c
@@ -754,8 +754,6 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
-	if (opts->nfs)
-		seq_puts(m, ",nfs");
 	if (opts->showexec)
 		seq_puts(m, ",showexec");
 	if (opts->sys_immutable)
@@ -785,6 +783,10 @@ static int fat_show_options(struct seq_f
 		seq_puts(m, ",errors=panic");
 	else
 		seq_puts(m, ",errors=remount-ro");
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		seq_puts(m, ",nfs=nostale_ro");
+	else if (opts->nfs)
+		seq_puts(m, ",nfs=stale_rw");
 	if (opts->discard)
 		seq_puts(m, ",discard");
 
@@ -800,7 +802,8 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs_stale_rw,
+	Opt_nfs_nostale_ro, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -829,7 +832,9 @@ static const match_table_t fat_tokens = 
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
@@ -1017,6 +1022,12 @@ static int parse_options(struct super_bl
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
@@ -1075,9 +1086,6 @@ static int parse_options(struct super_bl
 		case Opt_discard:
 			opts->discard = 1;
 			break;
-		case Opt_nfs:
-			opts->nfs = 1;
-			break;
 
 		/* obsolete mount options */
 		case Opt_obsolete:
@@ -1108,6 +1116,8 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
+	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+		sb->s_flags |= MS_RDONLY;
 
 	return 0;
 }
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

