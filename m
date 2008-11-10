From: akpm@linux-foundation.org
Subject: - fat-fix-and-cleanup-timestamp-conversion.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:13 -0800
Message-ID: <200811102033.mAAKXDm9024370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbYKJUdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix and cleanup timestamp conversion
has been removed from the -mm tree.  Its filename was
     fat-fix-and-cleanup-timestamp-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix and cleanup timestamp conversion
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This cleans date_dos2unix()/fat_date_unix2dos() up. New code should be
much more readable.

And this fixes those old functions. Those doesn't handle 2100
correctly. 2100 isn't leap year, but old one handles it as leap year.
Also, with this, centi sec is handled and is fixed.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c         |    6 +
 fs/fat/fat.h         |    7 +
 fs/fat/inode.c       |   34 +++------
 fs/fat/misc.c        |  146 +++++++++++++++++++++++++++++------------
 fs/fat/namei_msdos.c |    2 
 fs/fat/namei_vfat.c  |    5 -
 6 files changed, 129 insertions(+), 71 deletions(-)

diff -puN fs/fat/dir.c~fat-fix-and-cleanup-timestamp-conversion fs/fat/dir.c
--- a/fs/fat/dir.c~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/dir.c
@@ -1089,6 +1089,7 @@ int fat_alloc_new_dir(struct inode *dir,
 	struct msdos_dir_entry *de;
 	sector_t blknr;
 	__le16 date, time;
+	u8 time_cs;
 	int err, cluster;
 
 	err = fat_alloc_clusters(dir, &cluster, 1);
@@ -1102,7 +1103,7 @@ int fat_alloc_new_dir(struct inode *dir,
 		goto error_free;
 	}
 
-	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
+	fat_time_unix2fat(sbi, ts, &time, &date, &time_cs);
 
 	de = (struct msdos_dir_entry *)bhs[0]->b_data;
 	/* filling the new directory slots ("." and ".." entries) */
@@ -1112,13 +1113,14 @@ int fat_alloc_new_dir(struct inode *dir,
 	de[0].lcase = de[1].lcase = 0;
 	de[0].time = de[1].time = time;
 	de[0].date = de[1].date = date;
-	de[0].ctime_cs = de[1].ctime_cs = 0;
 	if (sbi->options.isvfat) {
 		/* extra timestamps */
 		de[0].ctime = de[1].ctime = time;
+		de[0].ctime_cs = de[1].ctime_cs = time_cs;
 		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = date;
 	} else {
 		de[0].ctime = de[1].ctime = 0;
+		de[0].ctime_cs = de[1].ctime_cs = 0;
 		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = 0;
 	}
 	de[0].start = cpu_to_le16(cluster);
diff -puN fs/fat/fat.h~fat-fix-and-cleanup-timestamp-conversion fs/fat/fat.h
--- a/fs/fat/fat.h~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/fat.h
@@ -263,9 +263,10 @@ extern int fat_flush_inodes(struct super
 extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
-extern int date_dos2unix(unsigned short time, unsigned short date, int tz_utc);
-extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date,
-			      int tz_utc);
+extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
+			      __le16 __time, __le16 __date, u8 time_cs);
+extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
+			      __le16 *time, __le16 *date, u8 *time_cs);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
 int fat_cache_init(void);
diff -puN fs/fat/inode.c~fat-fix-and-cleanup-timestamp-conversion fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/inode.c
@@ -381,22 +381,12 @@ static int fat_fill_inode(struct inode *
 	MSDOS_I(inode)->i_attrs = de->attr & ATTR_UNUSED;
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
-	inode->i_mtime.tv_sec =
-		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date),
-			      sbi->options.tz_utc);
-	inode->i_mtime.tv_nsec = 0;
+
+	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
 	if (sbi->options.isvfat) {
-		int secs = de->ctime_cs / 100;
-		int csecs = de->ctime_cs % 100;
-		inode->i_ctime.tv_sec  =
-			date_dos2unix(le16_to_cpu(de->ctime),
-				      le16_to_cpu(de->cdate),
-				      sbi->options.tz_utc) + secs;
-		inode->i_ctime.tv_nsec = csecs * 10000000;
-		inode->i_atime.tv_sec =
-			date_dos2unix(0, le16_to_cpu(de->adate),
-				      sbi->options.tz_utc);
-		inode->i_atime.tv_nsec = 0;
+		fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
+				  de->cdate, de->ctime_cs);
+		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
 	} else
 		inode->i_ctime = inode->i_atime = inode->i_mtime;
 
@@ -591,16 +581,14 @@ retry:
 	raw_entry->attr = fat_attr(inode);
 	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
 	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
-	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time,
-			  &raw_entry->date, sbi->options.tz_utc);
+	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
+			  &raw_entry->date, NULL);
 	if (sbi->options.isvfat) {
 		__le16 atime;
-		fat_date_unix2dos(inode->i_ctime.tv_sec, &raw_entry->ctime,
-				  &raw_entry->cdate, sbi->options.tz_utc);
-		fat_date_unix2dos(inode->i_atime.tv_sec, &atime,
-				  &raw_entry->adate, sbi->options.tz_utc);
-		raw_entry->ctime_cs = (inode->i_ctime.tv_sec & 1) * 100 +
-			inode->i_ctime.tv_nsec / 10000000;
+		fat_time_unix2fat(sbi, &inode->i_ctime, &raw_entry->ctime,
+				  &raw_entry->cdate, &raw_entry->ctime_cs);
+		fat_time_unix2fat(sbi, &inode->i_atime, &atime,
+				  &raw_entry->adate, NULL);
 	}
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
diff -puN fs/fat/misc.c~fat-fix-and-cleanup-timestamp-conversion fs/fat/misc.c
--- a/fs/fat/misc.c~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/misc.c
@@ -135,65 +135,131 @@ int fat_chain_add(struct inode *inode, i
 
 extern struct timezone sys_tz;
 
+/*
+ * The epoch of FAT timestamp is 1980.
+ *     :  bits :     value
+ * date:  0 -  4: day	(1 -  31)
+ * date:  5 -  8: month	(1 -  12)
+ * date:  9 - 15: year	(0 - 127) from 1980
+ * time:  0 -  4: sec	(0 -  29) 2sec counts
+ * time:  5 - 10: min	(0 -  59)
+ * time: 11 - 15: hour	(0 -  23)
+ */
+#define SECS_PER_MIN	60
+#define SECS_PER_HOUR	(60 * 60)
+#define SECS_PER_DAY	(SECS_PER_HOUR * 24)
+#define UNIX_SECS_1980	315532800L
+#if BITS_PER_LONG == 64
+#define UNIX_SECS_2108	4354819200L
+#endif
+/* days between 1.1.70 and 1.1.80 (2 leap days) */
+#define DAYS_DELTA	(365 * 10 + 2)
+/* 120 (2100 - 1980) isn't leap year */
+#define YEAR_2100	120
+#define IS_LEAP_YEAR(y)	(!((y) & 3) && (y) != YEAR_2100)
+
 /* Linear day numbers of the respective 1sts in non-leap years. */
-static int day_n[] = {
-   /* Jan  Feb  Mar  Apr   May  Jun  Jul  Aug  Sep  Oct  Nov  Dec */
-	0,  31,  59,  90,  120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0, 0
+static time_t days_in_year[] = {
+	/* Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec */
+	0,   0,  31,  59,  90, 120, 151, 181, 212, 243, 273, 304, 334, 0, 0, 0,
 };
 
-/* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
-int date_dos2unix(unsigned short time, unsigned short date, int tz_utc)
+/* Convert a FAT time/date pair to a UNIX date (seconds since 1 1 70). */
+void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
+		       __le16 __time, __le16 __date, u8 time_cs)
 {
-	int month, year, secs;
+	u16 time = le16_to_cpu(__time), date = le16_to_cpu(__date);
+	time_t second, day, leap_day, month, year;
 
-	/*
-	 * first subtract and mask after that... Otherwise, if
-	 * date == 0, bad things happen
-	 */
-	month = ((date >> 5) - 1) & 15;
-	year = date >> 9;
-	secs = (time & 31)*2+60*((time >> 5) & 63)+(time >> 11)*3600+86400*
-	    ((date & 31)-1+day_n[month]+(year/4)+year*365-((year & 3) == 0 &&
-	    month < 2 ? 1 : 0)+3653);
-			/* days since 1.1.70 plus 80's leap day */
-	if (!tz_utc)
-		secs += sys_tz.tz_minuteswest*60;
-	return secs;
+	year  = date >> 9;
+	month = max(1, (date >> 5) & 0xf);
+	day   = max(1, date & 0x1f) - 1;
+
+	leap_day = (year + 3) / 4;
+	if (year > YEAR_2100)		/* 2100 isn't leap year */
+		leap_day--;
+	if (IS_LEAP_YEAR(year) && month > 2)
+		leap_day++;
+
+	second =  (time & 0x1f) << 1;
+	second += ((time >> 5) & 0x3f) * SECS_PER_MIN;
+	second += (time >> 11) * SECS_PER_HOUR;
+	second += (year * 365 + leap_day
+		   + days_in_year[month] + day
+		   + DAYS_DELTA) * SECS_PER_DAY;
+
+	if (!sbi->options.tz_utc)
+		second += sys_tz.tz_minuteswest * SECS_PER_MIN;
+
+	if (time_cs) {
+		ts->tv_sec = second + (time_cs / 100);
+		ts->tv_nsec = (time_cs % 100) * 10000000;
+	} else {
+		ts->tv_sec = second;
+		ts->tv_nsec = 0;
+	}
 }
 
-/* Convert linear UNIX date to a MS-DOS time/date pair. */
-void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, int tz_utc)
+/* Convert linear UNIX date to a FAT time/date pair. */
+void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
+		       __le16 *time, __le16 *date, u8 *time_cs)
 {
-	int day, year, nl_day, month;
+	time_t second = ts->tv_sec;
+	time_t day, leap_day, month, year;
 
-	if (!tz_utc)
-		unix_date -= sys_tz.tz_minuteswest*60;
+	if (!sbi->options.tz_utc)
+		second -= sys_tz.tz_minuteswest * SECS_PER_MIN;
 
 	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
-	if (unix_date < 315532800)
-		unix_date = 315532800;
+	if (second < UNIX_SECS_1980) {
+		*time = 0;
+		*date = cpu_to_le16((0 << 9) | (1 << 5) | 1);
+		if (time_cs)
+			*time_cs = 0;
+		return;
+	}
+#if BITS_PER_LONG == 64
+	if (second >= UNIX_SECS_2108) {
+		*time = cpu_to_le16((23 << 11) | (59 << 5) | 29);
+		*date = cpu_to_le16((127 << 9) | (12 << 5) | 31);
+		if (time_cs)
+			*time_cs = 199;
+		return;
+	}
+#endif
 
-	*time = cpu_to_le16((unix_date % 60)/2+(((unix_date/60) % 60) << 5)+
-	    (((unix_date/3600) % 24) << 11));
-	day = unix_date/86400-3652;
-	year = day/365;
-	if ((year+3)/4+365*year > day)
+	day = second / SECS_PER_DAY - DAYS_DELTA;
+	year = day / 365;
+	leap_day = (year + 3) / 4;
+	if (year > YEAR_2100)		/* 2100 isn't leap year */
+		leap_day--;
+	if (year * 365 + leap_day > day)
 		year--;
-	day -= (year+3)/4+365*year;
-	if (day == 59 && !(year & 3)) {
-		nl_day = day;
+	leap_day = (year + 3) / 4;
+	if (year > YEAR_2100)		/* 2100 isn't leap year */
+		leap_day--;
+	day -= year * 365 + leap_day;
+
+	if (IS_LEAP_YEAR(year) && day == days_in_year[3]) {
 		month = 2;
 	} else {
-		nl_day = (year & 3) || day <= 59 ? day : day-1;
-		for (month = 0; month < 12; month++) {
-			if (day_n[month] > nl_day)
+		if (IS_LEAP_YEAR(year) && day > days_in_year[3])
+			day--;
+		for (month = 1; month < 12; month++) {
+			if (days_in_year[month + 1] > day)
 				break;
 		}
 	}
-	*date = cpu_to_le16(nl_day-day_n[month-1]+1+(month << 5)+(year << 9));
-}
+	day -= days_in_year[month];
 
-EXPORT_SYMBOL_GPL(fat_date_unix2dos);
+	*time = cpu_to_le16(((second / SECS_PER_HOUR) % 24) << 11
+			    | ((second / SECS_PER_MIN) % 60) << 5
+			    | (second % SECS_PER_MIN) >> 1);
+	*date = cpu_to_le16((year << 9) | (month << 5) | (day + 1));
+	if (time_cs)
+		*time_cs = (ts->tv_sec & 1) * 100 + ts->tv_nsec / 10000000;
+}
+EXPORT_SYMBOL_GPL(fat_time_unix2fat);
 
 int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 {
diff -puN fs/fat/namei_msdos.c~fat-fix-and-cleanup-timestamp-conversion fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/namei_msdos.c
@@ -247,7 +247,7 @@ static int msdos_add_entry(struct inode 
 	if (is_hid)
 		de.attr |= ATTR_HIDDEN;
 	de.lcase = 0;
-	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
+	fat_time_unix2fat(sbi, ts, &time, &date, NULL);
 	de.cdate = de.adate = 0;
 	de.ctime = 0;
 	de.ctime_cs = 0;
diff -puN fs/fat/namei_vfat.c~fat-fix-and-cleanup-timestamp-conversion fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-fix-and-cleanup-timestamp-conversion
+++ a/fs/fat/namei_vfat.c
@@ -568,6 +568,7 @@ static int vfat_build_slots(struct inode
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
 	__le16 time, date;
+	u8 time_cs;
 	int err, ulen, usize, i;
 	loff_t offset;
 
@@ -620,10 +621,10 @@ shortname:
 	memcpy(de->name, msdos_name, MSDOS_NAME);
 	de->attr = is_dir ? ATTR_DIR : ATTR_ARCH;
 	de->lcase = lcase;
-	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
+	fat_time_unix2fat(sbi, ts, &time, &date, &time_cs);
 	de->time = de->ctime = time;
 	de->date = de->cdate = de->adate = date;
-	de->ctime_cs = 0;
+	de->ctime_cs = time_cs;
 	de->start = cpu_to_le16(cluster);
 	de->starthi = cpu_to_le16(cluster >> 16);
 	de->size = 0;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

