From: akpm@linux-foundation.org
Subject: - fatfs-add-utc-timestamp-option.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:41 -0700
Message-ID: <200807252257.m6PMvfuD003210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbYGYW6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@skyrush.com, free_beer_for_all@yahoo.com, hirofumi@mail.parknet.co.jp, paul@ondioline.org, mm-commits@vger.kernel.org


The patch titled
     fatfs: add UTC timestamp option
has been removed from the -mm tree.  Its filename was
     fatfs-add-utc-timestamp-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fatfs: add UTC timestamp option
From: Joe Peterson <joe@skyrush.com>

Provide a new mount option ("tz=UTC") for DOS (vfat/msdos) filesystems,
allowing timestamps to be in coordinated universal time (UTC) rather than
local time in applications where doing this is advantageous.

In particular, portable devices that use fat/vfat (such as digital
cameras) can benefit from using UTC in their internal clocks, thus
avoiding daylight saving time errors and general time ambiguity issues. 
The user of the device does not have to worry about changing the time when
moving from place or when daylight saving changes.

The new mount option, when set, disables the counter-adjustment that Linux
currently makes to FAT timestamp info in anticipation of the normal
userspace time zone correction.  When used in this new mode, all daylight
saving time and time zone handling is done in userspace as is normal for
many other filesystems (like ext3).  The default mode, which remains
unchanged, is still appropriate when mounting volumes written in Windows
(because of its use of local time).

I originally based this patch on one submitted last year by Paul Collins,
but I updated it to work with current source and changed variable/option
naming.  Ogawa Hirofumi (who maintains these filesystems) and I discussed
this patch at length on lkml, and he suggested using the option name in
the attached version of the patch.  Barry Bouwsma pointed out a good
addition to the patch as well.

Signed-off-by: Joe Peterson <joe@skyrush.com>
Signed-off-by: Paul Collins <paul@ondioline.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Barry Bouwsma <free_beer_for_all@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c             |    2 +-
 fs/fat/inode.c           |   27 ++++++++++++++++++++-------
 fs/fat/misc.c            |   10 ++++++----
 fs/msdos/namei.c         |    3 ++-
 fs/vfat/namei.c          |    2 +-
 include/linux/msdos_fs.h |    8 +++++---
 6 files changed, 35 insertions(+), 17 deletions(-)

diff -puN fs/fat/dir.c~fatfs-add-utc-timestamp-option fs/fat/dir.c
--- a/fs/fat/dir.c~fatfs-add-utc-timestamp-option
+++ a/fs/fat/dir.c
@@ -1101,7 +1101,7 @@ int fat_alloc_new_dir(struct inode *dir,
 		goto error_free;
 	}
 
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 
 	de = (struct msdos_dir_entry *)bhs[0]->b_data;
 	/* filling the new directory slots ("." and ".." entries) */
diff -puN fs/fat/inode.c~fatfs-add-utc-timestamp-option fs/fat/inode.c
--- a/fs/fat/inode.c~fatfs-add-utc-timestamp-option
+++ a/fs/fat/inode.c
@@ -382,17 +382,20 @@ static int fat_fill_inode(struct inode *
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	inode->i_mtime.tv_sec =
-		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date));
+		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date),
+			      sbi->options.tz_utc);
 	inode->i_mtime.tv_nsec = 0;
 	if (sbi->options.isvfat) {
 		int secs = de->ctime_cs / 100;
 		int csecs = de->ctime_cs % 100;
 		inode->i_ctime.tv_sec  =
 			date_dos2unix(le16_to_cpu(de->ctime),
-				      le16_to_cpu(de->cdate)) + secs;
+				      le16_to_cpu(de->cdate),
+				      sbi->options.tz_utc) + secs;
 		inode->i_ctime.tv_nsec = csecs * 10000000;
 		inode->i_atime.tv_sec =
-			date_dos2unix(0, le16_to_cpu(de->adate));
+			date_dos2unix(0, le16_to_cpu(de->adate),
+				      sbi->options.tz_utc);
 		inode->i_atime.tv_nsec = 0;
 	} else
 		inode->i_ctime = inode->i_atime = inode->i_mtime;
@@ -591,11 +594,14 @@ retry:
 	raw_entry->attr = fat_attr(inode);
 	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
 	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
-	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, &raw_entry->date);
+	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time,
+			  &raw_entry->date, sbi->options.tz_utc);
 	if (sbi->options.isvfat) {
 		__le16 atime;
-		fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cdate);
-		fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate);
+		fat_date_unix2dos(inode->i_ctime.tv_sec, &raw_entry->ctime,
+				  &raw_entry->cdate, sbi->options.tz_utc);
+		fat_date_unix2dos(inode->i_atime.tv_sec, &atime,
+				  &raw_entry->adate, sbi->options.tz_utc);
 		raw_entry->ctime_cs = (inode->i_ctime.tv_sec & 1) * 100 +
 			inode->i_ctime.tv_nsec / 10000000;
 	}
@@ -836,6 +842,8 @@ static int fat_show_options(struct seq_f
 	}
 	if (sbi->options.flush)
 		seq_puts(m, ",flush");
+	if (opts->tz_utc)
+		seq_puts(m, ",tz=UTC");
 
 	return 0;
 }
@@ -848,7 +856,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_err,
 };
 
 static match_table_t fat_tokens = {
@@ -883,6 +891,7 @@ static match_table_t fat_tokens = {
 	{Opt_obsolate, "cvf_options=%100s"},
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
+	{Opt_tz_utc, "tz=UTC"},
 	{Opt_err, NULL},
 };
 static match_table_t msdos_tokens = {
@@ -947,6 +956,7 @@ static int parse_options(char *options, 
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
+	opts->tz_utc = 0;
 	*debug = 0;
 
 	if (!options)
@@ -1036,6 +1046,9 @@ static int parse_options(char *options, 
 		case Opt_flush:
 			opts->flush = 1;
 			break;
+		case Opt_tz_utc:
+			opts->tz_utc = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
diff -puN fs/fat/misc.c~fatfs-add-utc-timestamp-option fs/fat/misc.c
--- a/fs/fat/misc.c~fatfs-add-utc-timestamp-option
+++ a/fs/fat/misc.c
@@ -142,7 +142,7 @@ static int day_n[] = {
 };
 
 /* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
-int date_dos2unix(unsigned short time, unsigned short date)
+int date_dos2unix(unsigned short time, unsigned short date, int tz_utc)
 {
 	int month, year, secs;
 
@@ -156,16 +156,18 @@ int date_dos2unix(unsigned short time, u
 	    ((date & 31)-1+day_n[month]+(year/4)+year*365-((year & 3) == 0 &&
 	    month < 2 ? 1 : 0)+3653);
 			/* days since 1.1.70 plus 80's leap day */
-	secs += sys_tz.tz_minuteswest*60;
+	if (!tz_utc)
+		secs += sys_tz.tz_minuteswest*60;
 	return secs;
 }
 
 /* Convert linear UNIX date to a MS-DOS time/date pair. */
-void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date)
+void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, int tz_utc)
 {
 	int day, year, nl_day, month;
 
-	unix_date -= sys_tz.tz_minuteswest*60;
+	if (!tz_utc)
+		unix_date -= sys_tz.tz_minuteswest*60;
 
 	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
 	if (unix_date < 315532800)
diff -puN fs/msdos/namei.c~fatfs-add-utc-timestamp-option fs/msdos/namei.c
--- a/fs/msdos/namei.c~fatfs-add-utc-timestamp-option
+++ a/fs/msdos/namei.c
@@ -237,6 +237,7 @@ static int msdos_add_entry(struct inode 
 			   int is_dir, int is_hid, int cluster,
 			   struct timespec *ts, struct fat_slot_info *sinfo)
 {
+	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
 	struct msdos_dir_entry de;
 	__le16 time, date;
 	int err;
@@ -246,7 +247,7 @@ static int msdos_add_entry(struct inode 
 	if (is_hid)
 		de.attr |= ATTR_HIDDEN;
 	de.lcase = 0;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 	de.cdate = de.adate = 0;
 	de.ctime = 0;
 	de.ctime_cs = 0;
diff -puN fs/vfat/namei.c~fatfs-add-utc-timestamp-option fs/vfat/namei.c
--- a/fs/vfat/namei.c~fatfs-add-utc-timestamp-option
+++ a/fs/vfat/namei.c
@@ -621,7 +621,7 @@ shortname:
 	memcpy(de->name, msdos_name, MSDOS_NAME);
 	de->attr = is_dir ? ATTR_DIR : ATTR_ARCH;
 	de->lcase = lcase;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 	de->time = de->ctime = time;
 	de->date = de->cdate = de->adate = date;
 	de->ctime_cs = 0;
diff -puN include/linux/msdos_fs.h~fatfs-add-utc-timestamp-option include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fatfs-add-utc-timestamp-option
+++ a/include/linux/msdos_fs.h
@@ -203,7 +203,8 @@ struct fat_mount_options {
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
-		 usefree:1;	  /* Use free_clusters for FAT32 */
+		 usefree:1,	  /* Use free_clusters for FAT32 */
+		 tz_utc:1;	  /* Filesystem timestamps are in UTC */
 };
 
 #define FAT_HASH_BITS	8
@@ -434,8 +435,9 @@ extern int fat_flush_inodes(struct super
 extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
-extern int date_dos2unix(unsigned short time, unsigned short date);
-extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date);
+extern int date_dos2unix(unsigned short time, unsigned short date, int tz_utc);
+extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date,
+			      int tz_utc);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
 int fat_cache_init(void);
_

Patches currently in -mm which might be from joe@skyrush.com are

origin.patch

