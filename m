From: akpm@linux-foundation.org
Subject: + fat-provide-option-for-setting-timezone-offset.patch added to -mm tree
Date: Tue, 13 Nov 2012 15:40:53 -0800
Message-ID: <20121113234053.A3893100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:39616 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2KMXky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 18:40:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so935113yen.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 15:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: provide option for setting timezone offset
has been added to the -mm tree.  Its filename is
     fat-provide-option-for-setting-timezone-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fat: provide option for setting timezone offset

So far FAT either offsets time stamps by sys_tz.minuteswest or leaves them
as they are (when tz=UTC mount option is used).  However in some cases it
is useful if one can specify time stamp offset on his own (e.g.  when time
zone of the camera connected is different from time zone of the computer,
or when HW clock is in UTC and thus sys_tz.minuteswest == 0).

So provide a mount option time_offset= which allows user to specify offset
in minutes that should be applied to time stamps on the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    9 +++++++++
 fs/fat/fat.h                       |    3 ++-
 fs/fat/inode.c                     |   25 ++++++++++++++++++++-----
 fs/fat/misc.c                      |    9 ++++++---
 4 files changed, 37 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-provide-option-for-setting-timezone-offset Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fat-provide-option-for-setting-timezone-offset
+++ a/Documentation/filesystems/vfat.txt
@@ -111,6 +111,15 @@ tz=UTC        -- Interpret timestamps as
                  useful when mounting devices (like digital cameras)
                  that are set to UTC in order to avoid the pitfalls of
                  local time.
+time_offset=minutes
+	      -- Set offset for conversion of timestamps from local time
+		 used by FAT to UTC. I.e. <minutes> minutes will be subtracted
+		 from each timestamp to convert it to UTC used internally by
+		 Linux. This is useful when time zone set in sys_tz is
+		 not the time zone used by the filesystem. Note that this
+		 option still does not provide correct time stamps in all
+		 cases in presence of DST - time stamps in a different DST
+		 setting will be off by one hour.
 
 showexec      -- If set, the execute permission bits of the file will be
 		 allowed only if the extension part of the name is .EXE,
diff -puN fs/fat/fat.h~fat-provide-option-for-setting-timezone-offset fs/fat/fat.h
--- a/fs/fat/fat.h~fat-provide-option-for-setting-timezone-offset
+++ a/fs/fat/fat.h
@@ -29,6 +29,7 @@ struct fat_mount_options {
 	unsigned short fs_fmask;
 	unsigned short fs_dmask;
 	unsigned short codepage;   /* Codepage for shortname conversions */
+	int time_offset;	   /* Offset of timestamps from UTC (in minutes) */
 	char *iocharset;           /* Charset used for filename input/display */
 	unsigned short shortname;  /* flags for shortname display/create rule */
 	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
@@ -45,7 +46,7 @@ struct fat_mount_options {
 		 flush:1,	   /* write things quickly */
 		 nocase:1,	   /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	   /* Use free_clusters for FAT32 */
-		 tz_utc:1,	   /* Filesystem timestamps are in UTC */
+		 tz_set:1,	   /* Filesystem timestamps' offset set */
 		 rodir:1,	   /* allow ATTR_RO for directory */
 		 discard:1,	   /* Issue discard requests on deletions */
 		 nfs:1;		   /* Do extra work needed for NFS export */
diff -puN fs/fat/inode.c~fat-provide-option-for-setting-timezone-offset fs/fat/inode.c
--- a/fs/fat/inode.c~fat-provide-option-for-setting-timezone-offset
+++ a/fs/fat/inode.c
@@ -777,8 +777,12 @@ static int fat_show_options(struct seq_f
 	}
 	if (opts->flush)
 		seq_puts(m, ",flush");
-	if (opts->tz_utc)
-		seq_puts(m, ",tz=UTC");
+	if (opts->tz_set) {
+		if (opts->time_offset)
+			seq_printf(m, ",time_offset=%d", opts->time_offset);
+		else
+			seq_puts(m, ",tz=UTC");
+	}
 	if (opts->errors == FAT_ERRORS_CONT)
 		seq_puts(m, ",errors=continue");
 	else if (opts->errors == FAT_ERRORS_PANIC)
@@ -800,7 +804,8 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_nfs, Opt_time_offset,
+	Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -825,6 +830,7 @@ static const match_table_t fat_tokens = 
 	{Opt_immutable, "sys_immutable"},
 	{Opt_flush, "flush"},
 	{Opt_tz_utc, "tz=UTC"},
+	{Opt_time_offset, "time_offset=%d"},
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
@@ -909,7 +915,7 @@ static int parse_options(struct super_bl
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
-	opts->tz_utc = 0;
+	opts->tz_set = 0;
 	opts->nfs = 0;
 	opts->errors = FAT_ERRORS_RO;
 	*debug = 0;
@@ -1005,8 +1011,17 @@ static int parse_options(struct super_bl
 		case Opt_flush:
 			opts->flush = 1;
 			break;
+		case Opt_time_offset:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < -12 * 60 || option > 12 * 60)
+				return 0;
+			opts->tz_set = 1;
+			opts->time_offset = option;
+			break;
 		case Opt_tz_utc:
-			opts->tz_utc = 1;
+			opts->tz_set = 1;
+			opts->time_offset = 0;
 			break;
 		case Opt_err_cont:
 			opts->errors = FAT_ERRORS_CONT;
diff -puN fs/fat/misc.c~fat-provide-option-for-setting-timezone-offset fs/fat/misc.c
--- a/fs/fat/misc.c~fat-provide-option-for-setting-timezone-offset
+++ a/fs/fat/misc.c
@@ -212,8 +212,10 @@ void fat_time_fat2unix(struct msdos_sb_i
 		   + days_in_year[month] + day
 		   + DAYS_DELTA) * SECS_PER_DAY;
 
-	if (!sbi->options.tz_utc)
+	if (!sbi->options.tz_set)
 		second += sys_tz.tz_minuteswest * SECS_PER_MIN;
+	else
+		second -= sbi->options.time_offset * SECS_PER_MIN;
 
 	if (time_cs) {
 		ts->tv_sec = second + (time_cs / 100);
@@ -229,8 +231,9 @@ void fat_time_unix2fat(struct msdos_sb_i
 		       __le16 *time, __le16 *date, u8 *time_cs)
 {
 	struct tm tm;
-	time_to_tm(ts->tv_sec, sbi->options.tz_utc ? 0 :
-		   -sys_tz.tz_minuteswest * 60, &tm);
+	time_to_tm(ts->tv_sec,
+		   (sbi->options.tz_set ? sbi->options.time_offset :
+		   -sys_tz.tz_minuteswest) * SECS_PER_MIN, &tm);
 
 	/*  FAT can only support year between 1980 to 2107 */
 	if (tm.tm_year < 1980 - 1900) {
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
fat-provide-option-for-setting-timezone-offset.patch

