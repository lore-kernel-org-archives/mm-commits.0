From: akpm@linux-foundation.org
Subject: - fat-cleanup-fs-fat-dirc.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:29 -0700
Message-ID: <200807252257.m6PMvTvM003192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbYGYXG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: cleanup fs/fat/dir.c
has been removed from the -mm tree.  Its filename was
     fat-cleanup-fs-fat-dirc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: cleanup fs/fat/dir.c
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This is no logic changes, just cleans fs/fat/dir.c up.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |  131 +++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 64 deletions(-)

diff -puN fs/fat/dir.c~fat-cleanup-fs-fat-dirc fs/fat/dir.c
--- a/fs/fat/dir.c~fat-cleanup-fs-fat-dirc
+++ a/fs/fat/dir.c
@@ -123,10 +123,11 @@ static inline int fat_get_entry(struct i
  * but ignore that right now.
  * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
  */
-static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len,
+static int uni16_to_x8(unsigned char *ascii, const wchar_t *uni, int len,
 		       int uni_xlate, struct nls_table *nls)
 {
-	wchar_t *ip, ec;
+	const wchar_t *ip;
+	wchar_t ec;
 	unsigned char *op, nc;
 	int charlen;
 	int k;
@@ -166,6 +167,16 @@ static int uni16_to_x8(unsigned char *as
 	return (op - ascii);
 }
 
+static inline int fat_uni_to_x8(struct msdos_sb_info *sbi, const wchar_t *uni,
+				unsigned char *buf, int size)
+{
+	if (sbi->options.utf8)
+		return utf8_wcstombs(buf, uni, size);
+	else
+		return uni16_to_x8(buf, uni, size, sbi->options.unicode_xlate,
+				   sbi->nls_io);
+}
+
 static inline int
 fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
 {
@@ -226,6 +237,19 @@ fat_shortname2uni(struct nls_table *nls,
 	return len;
 }
 
+static inline int fat_name_match(struct msdos_sb_info *sbi,
+				 const unsigned char *a, int a_len,
+				 const unsigned char *b, int b_len)
+{
+	if (a_len != b_len)
+		return 0;
+
+	if (sbi->options.name_check != 's')
+		return !nls_strnicmp(sbi->nls_io, a, b, a_len);
+	else
+		return !memcmp(a, b, a_len);
+}
+
 enum { PARSE_INVALID = 1, PARSE_NOT_LONGNAME, PARSE_EOF, };
 
 /**
@@ -311,29 +335,24 @@ int fat_search_long(struct inode *inode,
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
-	wchar_t bufuname[14];
 	unsigned char nr_slots;
-	int xlate_len;
+	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char work[MSDOS_NAME];
 	unsigned char *bufname = NULL;
-	int uni_xlate = sbi->options.unicode_xlate;
-	int utf8 = sbi->options.utf8;
-	int anycase = (sbi->options.name_check != 's');
 	unsigned short opt_shortname = sbi->options.shortname;
 	loff_t cpos = 0;
-	int chl, i, j, last_u, err;
+	int chl, i, j, last_u, err, len;
 
 	bufname = __getname();
 	if (!bufname)
 		return -ENOMEM;
 
 	err = -ENOENT;
-	while(1) {
+	while (1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
-			goto EODir;
+			goto end_of_dir;
 parse_record:
 		nr_slots = 0;
 		if (de->name[0] == DELETED_FLAG)
@@ -352,7 +371,7 @@ parse_record:
 			else if (status == PARSE_NOT_LONGNAME)
 				goto parse_record;
 			else if (status == PARSE_EOF)
-				goto EODir;
+				goto end_of_dir;
 		}
 
 		memcpy(work, de->name, sizeof(de->name));
@@ -393,30 +412,21 @@ parse_record:
 		if (!last_u)
 			continue;
 
+		/* Compare shortname */
 		bufuname[last_u] = 0x0000;
-		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, PATH_MAX)
-			:uni16_to_x8(bufname, bufuname, PATH_MAX, uni_xlate, nls_io);
-		if (xlate_len == name_len)
-			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
-			    (anycase && !nls_strnicmp(nls_io, name, bufname,
-								xlate_len)))
-				goto Found;
+		len = fat_uni_to_x8(sbi, bufuname, bufname, PATH_MAX);
+		if (fat_name_match(sbi, name, name_len, bufname, len))
+			goto found;
 
 		if (nr_slots) {
-			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, PATH_MAX)
-				:uni16_to_x8(bufname, unicode, PATH_MAX, uni_xlate, nls_io);
-			if (xlate_len != name_len)
-				continue;
-			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
-			    (anycase && !nls_strnicmp(nls_io, name, bufname,
-								xlate_len)))
-				goto Found;
+			/* Compare longname */
+			len = fat_uni_to_x8(sbi, unicode, bufname, PATH_MAX);
+			if (fat_name_match(sbi, name, name_len, bufname, len))
+				goto found;
 		}
 	}
 
-Found:
+found:
 	nr_slots++;	/* include the de */
 	sinfo->slot_off = cpos - nr_slots * sizeof(*de);
 	sinfo->nr_slots = nr_slots;
@@ -424,7 +434,7 @@ Found:
 	sinfo->bh = bh;
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
-EODir:
+end_of_dir:
 	if (bufname)
 		__putname(bufname);
 	if (unicode)
@@ -452,23 +462,19 @@ static int __fat_readdir(struct inode *i
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
-	unsigned char long_slots;
-	const char *fill_name;
-	int fill_len;
+	unsigned char nr_slots;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
-	unsigned long lpos, dummy, *furrfu = &lpos;
-	int uni_xlate = sbi->options.unicode_xlate;
+	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
-	int utf8 = sbi->options.utf8;
 	int nocase = sbi->options.nocase;
-	unsigned short opt_shortname = sbi->options.shortname;
+	const char *fill_name;
 	unsigned long inum;
-	int chi, chl, i, i2, j, last, last_u, dotoffset = 0;
+	unsigned long lpos, dummy, *furrfu = &lpos;
 	loff_t cpos;
+	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len;
 	int ret = 0;
 
 	lock_super(sb);
@@ -488,43 +494,43 @@ static int __fat_readdir(struct inode *i
 			cpos = 0;
 		}
 	}
-	if (cpos & (sizeof(struct msdos_dir_entry)-1)) {
+	if (cpos & (sizeof(struct msdos_dir_entry) - 1)) {
 		ret = -ENOENT;
 		goto out;
 	}
 
 	bh = NULL;
-GetNew:
+get_new:
 	if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
-		goto EODir;
+		goto end_of_dir;
 parse_record:
-	long_slots = 0;
+	nr_slots = 0;
 	/* Check for long filename entry */
 	if (isvfat) {
 		if (de->name[0] == DELETED_FLAG)
-			goto RecEnd;
+			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
-			goto RecEnd;
+			goto record_end;
 		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			goto RecEnd;
+			goto record_end;
 	} else {
 		if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
-			goto RecEnd;
+			goto record_end;
 	}
 
 	if (isvfat && de->attr == ATTR_EXT) {
 		int status = fat_parse_long(inode, &cpos, &bh, &de,
-					    &unicode, &long_slots);
+					    &unicode, &nr_slots);
 		if (status < 0) {
 			filp->f_pos = cpos;
 			ret = status;
 			goto out;
 		} else if (status == PARSE_INVALID)
-			goto RecEnd;
+			goto record_end;
 		else if (status == PARSE_NOT_LONGNAME)
 			goto parse_record;
 		else if (status == PARSE_EOF)
-			goto EODir;
+			goto end_of_dir;
 	}
 
 	if (sbi->options.dotsOK) {
@@ -586,12 +592,12 @@ parse_record:
 		}
 	}
 	if (!last)
-		goto RecEnd;
+		goto record_end;
 
 	i = last + dotoffset;
 	j = last_u;
 
-	lpos = cpos - (long_slots+1)*sizeof(struct msdos_dir_entry);
+	lpos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME))
 		inum = inode->i_ino;
 	else if (!memcmp(de->name, MSDOS_DOTDOT, MSDOS_NAME)) {
@@ -608,20 +614,17 @@ parse_record:
 
 	if (isvfat) {
 		bufuname[j] = 0x0000;
-		i = utf8 ? utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			 : uni16_to_x8(bufname, bufuname, sizeof(bufname), uni_xlate, nls_io);
+		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
 	}
 
 	fill_name = bufname;
 	fill_len = i;
-	if (!short_only && long_slots) {
+	if (!short_only && nr_slots) {
 		/* convert the unicode long name. 261 is maximum size
 		 * of unicode buffer. (13 * slots + nul) */
 		void *longname = unicode + 261;
 		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
-		int long_len = utf8
-			? utf8_wcstombs(longname, unicode, buf_size)
-			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
+		int long_len = fat_uni_to_x8(sbi, unicode, longname, buf_size);
 
 		if (!both) {
 			fill_name = longname;
@@ -640,15 +643,15 @@ parse_record:
 	}
 	if (filldir(dirent, fill_name, fill_len, *furrfu, inum,
 		    (de->attr & ATTR_DIR) ? DT_DIR : DT_REG) < 0)
-		goto FillFailed;
+		goto fill_failed;
 
-RecEnd:
+record_end:
 	furrfu = &lpos;
 	filp->f_pos = cpos;
-	goto GetNew;
-EODir:
+	goto get_new;
+end_of_dir:
 	filp->f_pos = cpos;
-FillFailed:
+fill_failed:
 	brelse(bh);
 	if (unicode)
 		__putname(unicode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
linux-next.patch

