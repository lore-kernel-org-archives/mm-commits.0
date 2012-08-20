From: akpm@linux-foundation.org
Subject: + fs-fat-changed-indentation-of-some-comments-in-fath.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:29 -0700
Message-ID: <20120820202330.991F85C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35981 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2HTUXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:32 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so314618lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: chang indentation of some comments in fat.h
has been added to the -mm tree.  Its filename is
     fs-fat-changed-indentation-of-some-comments-in-fath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: fs/fat: chang indentation of some comments in fat.h

The comments were not lined up properly, so I just re-indented them.

This also fixes a stupid checkpatch issue unknowingly

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h |   72 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff -puN fs/fat/fat.h~fs-fat-changed-indentation-of-some-comments-in-fath fs/fat/fat.h
--- a/fs/fat/fat.h~fs-fat-changed-indentation-of-some-comments-in-fath
+++ a/fs/fat/fat.h
@@ -28,27 +28,27 @@ struct fat_mount_options {
 	gid_t fs_gid;
 	unsigned short fs_fmask;
 	unsigned short fs_dmask;
-	unsigned short codepage;  /* Codepage for shortname conversions */
-	char *iocharset;          /* Charset used for filename input/display */
-	unsigned short shortname; /* flags for shortname display/create rule */
-	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
-	unsigned char errors;	  /* On error: continue, panic, remount-ro */
+	unsigned short codepage;   /* Codepage for shortname conversions */
+	char *iocharset;           /* Charset used for filename input/display */
+	unsigned short shortname;  /* flags for shortname display/create rule */
+	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
+	unsigned char errors;	   /* On error: continue, panic, remount-ro */
 	unsigned short allow_utime;/* permission for setting the [am]time */
-	unsigned quiet:1,         /* set = fake successful chmods and chowns */
-		 showexec:1,      /* set = only set x bit for com/exe/bat */
-		 sys_immutable:1, /* set = system files are immutable */
-		 dotsOK:1,        /* set = hidden and system files are named '.filename' */
-		 isvfat:1,        /* 0=no vfat long filename support, 1=vfat support */
-		 utf8:1,	  /* Use of UTF-8 character set (Default) */
-		 unicode_xlate:1, /* create escape sequences for unhandled Unicode */
-		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
-		 flush:1,	  /* write things quickly */
-		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
-		 usefree:1,	  /* Use free_clusters for FAT32 */
-		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1,	  /* allow ATTR_RO for directory */
-		 discard:1,	  /* Issue discard requests on deletions */
-		 nfs:1;		  /* Do extra work needed for NFS export */
+	unsigned quiet:1,          /* set = fake successful chmods and chowns */
+		 showexec:1,       /* set = only set x bit for com/exe/bat */
+		 sys_immutable:1,  /* set = system files are immutable */
+		 dotsOK:1,         /* set = hidden and system files are named '.filename' */
+		 isvfat:1,         /* 0=no vfat long filename support, 1=vfat support */
+		 utf8:1,	   /* Use of UTF-8 character set (Default) */
+		 unicode_xlate:1,  /* create escape sequences for unhandled Unicode */
+		 numtail:1,        /* Does first alias have a numeric '~1' type tail? */
+		 flush:1,	   /* write things quickly */
+		 nocase:1,	   /* Does this need case conversion? 0=need case conversion*/
+		 usefree:1,	   /* Use free_clusters for FAT32 */
+		 tz_utc:1,	   /* Filesystem timestamps are in UTC */
+		 rodir:1,	   /* allow ATTR_RO for directory */
+		 discard:1,	   /* Issue discard requests on deletions */
+		 nfs:1;		   /* Do extra work needed for NFS export */
 };
 
 #define FAT_HASH_BITS	8
@@ -58,28 +58,28 @@ struct fat_mount_options {
  * MS-DOS file system in-core superblock data
  */
 struct msdos_sb_info {
-	unsigned short sec_per_clus; /* sectors/cluster */
-	unsigned short cluster_bits; /* log2(cluster_size) */
-	unsigned int cluster_size;   /* cluster size */
+	unsigned short sec_per_clus;  /* sectors/cluster */
+	unsigned short cluster_bits;  /* log2(cluster_size) */
+	unsigned int cluster_size;    /* cluster size */
 	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12 or 16) */
 	unsigned short fat_start;
-	unsigned long fat_length;    /* FAT start & length (sec.) */
+	unsigned long fat_length;     /* FAT start & length (sec.) */
 	unsigned long dir_start;
-	unsigned short dir_entries;  /* root dir start & entries */
-	unsigned long data_start;    /* first data sector */
-	unsigned long max_cluster;   /* maximum cluster number */
-	unsigned long root_cluster;  /* first cluster of the root directory */
-	unsigned long fsinfo_sector; /* sector number of FAT32 fsinfo */
+	unsigned short dir_entries;   /* root dir start & entries */
+	unsigned long data_start;     /* first data sector */
+	unsigned long max_cluster;    /* maximum cluster number */
+	unsigned long root_cluster;   /* first cluster of the root directory */
+	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
-	unsigned int prev_free;      /* previously allocated cluster number */
-	unsigned int free_clusters;  /* -1 if undefined */
+	unsigned int prev_free;       /* previously allocated cluster number */
+	unsigned int free_clusters;   /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
 	struct fat_mount_options options;
-	struct nls_table *nls_disk;  /* Codepage used on disk */
-	struct nls_table *nls_io;    /* Charset used for input and display */
-	const void *dir_ops;		     /* Opaque; default directory operations */
-	int dir_per_block;	     /* dir entries per block */
-	int dir_per_block_bits;	     /* log2(dir_per_block) */
+	struct nls_table *nls_disk;   /* Codepage used on disk */
+	struct nls_table *nls_io;     /* Charset used for input and display */
+	const void *dir_ops;	      /* Opaque; default directory operations */
+	int dir_per_block;	      /* dir entries per block */
+	int dir_per_block_bits;	      /* log2(dir_per_block) */
 
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
_

Patches currently in -mm which might be from cruzjbishop@gmail.com are

linux-next.patch
fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch
fs-fat-fix-some-checkpatch-issues-in-fath.patch
fs-fat-changed-indentation-of-some-comments-in-fath.patch
fs-fat-fix-two-checkpatch-issues-in-cachec.patch
fs-fat-fixes-some-small-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fs-fat-fix-checkpatch-issues-in-fatentc.patch

