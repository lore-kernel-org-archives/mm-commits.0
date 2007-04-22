From: akpm@linux-foundation.org
Subject: + fat_dont-use_free_clusters-for-fat32.patch added to -mm tree
Date: Sat, 21 Apr 2007 21:40:28 -0700
Message-ID: <200704220440.l3M4eSLa019668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXDVEkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, juergen127@kreuzholzen.de


The patch titled
     fat: don't use free_clusters for fat32
has been added to the -mm tree.  Its filename is
     fat_dont-use_free_clusters-for-fat32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fat: don't use free_clusters for fat32
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

It seems that the recent Windows changed specification, and it's
undocumented.  Windows doesn't update ->free_clusters correctly.

This patch doesn't use ->free_clusters by default.  (instead, add "usefree"
for forcing to use it)

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c           |   14 +++++++++++---
 include/linux/msdos_fs.h |    3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN fs/fat/inode.c~fat_dont-use_free_clusters-for-fat32 fs/fat/inode.c
--- a/fs/fat/inode.c~fat_dont-use_free_clusters-for-fat32
+++ a/fs/fat/inode.c
@@ -825,6 +825,8 @@ static int fat_show_options(struct seq_f
 	}
 	if (opts->name_check != 'n')
 		seq_printf(m, ",check=%c", opts->name_check);
+	if (opts->usefree)
+		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
 	if (opts->showexec)
@@ -850,7 +852,7 @@ static int fat_show_options(struct seq_f
 
 enum {
 	Opt_check_n, Opt_check_r, Opt_check_s, Opt_uid, Opt_gid,
-	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_nocase,
+	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_usefree, Opt_nocase,
 	Opt_quiet, Opt_showexec, Opt_debug, Opt_immutable,
 	Opt_dots, Opt_nodots,
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
@@ -872,6 +874,7 @@ static match_table_t fat_tokens = {
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
 	{Opt_codepage, "codepage=%u"},
+	{Opt_usefree, "usefree"},
 	{Opt_nocase, "nocase"},
 	{Opt_quiet, "quiet"},
 	{Opt_showexec, "showexec"},
@@ -951,7 +954,7 @@ static int parse_options(char *options, 
 	opts->quiet = opts->showexec = opts->sys_immutable = opts->dotsOK =  0;
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
-	opts->nocase = 0;
+	opts->usefree = opts->nocase = 0;
 	*debug = 0;
 
 	if (!options)
@@ -979,6 +982,9 @@ static int parse_options(char *options, 
 		case Opt_check_n:
 			opts->name_check = 'n';
 			break;
+		case Opt_usefree:
+			opts->usefree = 1;
+			break;
 		case Opt_nocase:
 			if (!is_vfat)
 				opts->nocase = 1;
@@ -1304,7 +1310,9 @@ int fat_fill_super(struct super_block *s
 			       le32_to_cpu(fsinfo->signature2),
 			       sbi->fsinfo_sector);
 		} else {
-			sbi->free_clusters = le32_to_cpu(fsinfo->free_clusters);
+			if (sbi->options.usefree)
+				sbi->free_clusters =
+					le32_to_cpu(fsinfo->free_clusters);
 			sbi->prev_free = le32_to_cpu(fsinfo->next_cluster);
 		}
 
diff -puN include/linux/msdos_fs.h~fat_dont-use_free_clusters-for-fat32 include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat_dont-use_free_clusters-for-fat32
+++ a/include/linux/msdos_fs.h
@@ -205,7 +205,8 @@ struct fat_mount_options {
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
 		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
-		 nocase:1;	  /* Does this need case conversion? 0=need case conversion*/
+		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
+		 usefree:1;	  /* Use free_clusters for FAT32 */
 };
 
 #define FAT_HASH_BITS	8
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

is_power_of_2-in-fat.patch
fat_dont-use_free_clusters-for-fat32.patch
