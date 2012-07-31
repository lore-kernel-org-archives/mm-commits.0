From: akpm@linux-foundation.org
Subject: [merged] fat-refactor-shortname-parsing.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:28 -0700
Message-ID: <20120731185329.0E15E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33528 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346Ab2GaSxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:53:31 -0400
Received: by lagr15 with SMTP id r15so292336lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: refactor shortname parsing
has been removed from the -mm tree.  Its filename was
     fat-refactor-shortname-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: fat: refactor shortname parsing

Nearly identical shortname parsing is performed in fat_search_long() and
__fat_readdir().  Extract this code into a function that may be called by
both.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |  255 ++++++++++++++++++++++++++-----------------------
 1 file changed, 137 insertions(+), 118 deletions(-)

diff -puN fs/fat/dir.c~fat-refactor-shortname-parsing fs/fat/dir.c
--- a/fs/fat/dir.c~fat-refactor-shortname-parsing
+++ a/fs/fat/dir.c
@@ -35,6 +35,11 @@
 #define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
 #define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
 
+static inline unsigned char fat_tolower(unsigned char c)
+{
+	return ((c >= 'A') && (c <= 'Z')) ? c+32 : c;
+}
+
 static inline loff_t fat_make_i_pos(struct super_block *sb,
 				    struct buffer_head *bh,
 				    struct msdos_dir_entry *de)
@@ -333,6 +338,124 @@ parse_long:
 	return 0;
 }
 
+/**
+ * fat_parse_short - Parse MS-DOS (short) directory entry.
+ * @sb:		superblock
+ * @de:		directory entry to parse
+ * @name:	FAT_MAX_SHORT_SIZE array in which to place extracted name
+ * @dot_hidden:	Nonzero == prepend '.' to names with ATTR_HIDDEN
+ *
+ * Returns the number of characters extracted into 'name'.
+ */
+static int fat_parse_short(struct super_block *sb,
+			   const struct msdos_dir_entry *de,
+			   unsigned char *name, int dot_hidden)
+{
+	const struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int isvfat = sbi->options.isvfat;
+	int nocase = sbi->options.nocase;
+	unsigned short opt_shortname = sbi->options.shortname;
+	struct nls_table *nls_disk = sbi->nls_disk;
+	wchar_t uni_name[14];
+	unsigned char c, work[MSDOS_NAME];
+	unsigned char *ptname = name;
+	int chi, chl, i, j, k;
+	int dotoffset = 0;
+	int name_len = 0, uni_len = 0;
+
+	if (!isvfat && dot_hidden && (de->attr & ATTR_HIDDEN)) {
+		*ptname++ = '.';
+		dotoffset = 1;
+	}
+
+	memcpy(work, de->name, sizeof(work));
+	/* see namei.c, msdos_format_name */
+	if (work[0] == 0x05)
+		work[0] = 0xE5;
+
+	/* Filename */
+	for (i = 0, j = 0; i < 8;) {
+		c = work[i];
+		if (!c)
+			break;
+		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
+					&uni_name[j++], opt_shortname,
+					de->lcase & CASE_LOWER_BASE);
+		if (chl <= 1) {
+			if (!isvfat)
+				ptname[i] = nocase ? c : fat_tolower(c);
+			i++;
+			if (c != ' ') {
+				name_len = i;
+				uni_len  = j;
+			}
+		} else {
+			uni_len = j;
+			if (isvfat)
+				i += min(chl, 8-i);
+			else {
+				for (chi = 0; chi < chl && i < 8; chi++, i++)
+					ptname[i] = work[i];
+			}
+			if (chl)
+				name_len = i;
+		}
+	}
+
+	i = name_len;
+	j = uni_len;
+	fat_short2uni(nls_disk, ".", 1, &uni_name[j++]);
+	if (!isvfat)
+		ptname[i] = '.';
+	i++;
+
+	/* Extension */
+	for (k = 8; k < MSDOS_NAME;) {
+		c = work[k];
+		if (!c)
+			break;
+		chl = fat_shortname2uni(nls_disk, &work[k], MSDOS_NAME - k,
+					&uni_name[j++], opt_shortname,
+					de->lcase & CASE_LOWER_EXT);
+		if (chl <= 1) {
+			k++;
+			if (!isvfat)
+				ptname[i] = nocase ? c : fat_tolower(c);
+			i++;
+			if (c != ' ') {
+				name_len = i;
+				uni_len  = j;
+			}
+		} else {
+			uni_len = j;
+			if (isvfat) {
+				int offset = min(chl, MSDOS_NAME-k);
+				k += offset;
+				i += offset;
+			} else {
+				for (chi = 0; chi < chl && k < MSDOS_NAME;
+				     chi++, i++, k++) {
+						ptname[i] = work[k];
+				}
+			}
+			if (chl)
+				name_len = i;
+		}
+	}
+
+	if (name_len > 0) {
+		name_len += dotoffset;
+
+		if (sbi->options.isvfat) {
+			uni_name[uni_len] = 0x0000;
+			name_len = fat_uni_to_x8(sb, uni_name, name,
+						 FAT_MAX_SHORT_SIZE);
+		}
+	}
+
+	return name_len;
+}
+
 /*
  * Return values: negative -> error, 0 -> not found, positive -> found,
  * value is the total amount of slots, including the shortname entry.
@@ -344,15 +467,11 @@ int fat_search_long(struct inode *inode,
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_disk = sbi->nls_disk;
 	unsigned char nr_slots;
-	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char work[MSDOS_NAME];
 	unsigned char bufname[FAT_MAX_SHORT_SIZE];
-	unsigned short opt_shortname = sbi->options.shortname;
 	loff_t cpos = 0;
-	int chl, i, j, last_u, err, len;
+	int err, len;
 
 	err = -ENOENT;
 	while (1) {
@@ -380,47 +499,16 @@ parse_record:
 				goto end_of_dir;
 		}
 
-		memcpy(work, de->name, sizeof(de->name));
-		/* see namei.c, msdos_format_name */
-		if (work[0] == 0x05)
-			work[0] = 0xE5;
-		for (i = 0, j = 0, last_u = 0; i < 8;) {
-			if (!work[i])
-				break;
-			chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
-						&bufuname[j++], opt_shortname,
-						de->lcase & CASE_LOWER_BASE);
-			if (chl <= 1) {
-				if (work[i] != ' ')
-					last_u = j;
-			} else {
-				last_u = j;
-			}
-			i += chl;
-		}
-		j = last_u;
-		fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
-		for (i = 8; i < MSDOS_NAME;) {
-			if (!work[i])
-				break;
-			chl = fat_shortname2uni(nls_disk, &work[i],
-						MSDOS_NAME - i,
-						&bufuname[j++], opt_shortname,
-						de->lcase & CASE_LOWER_EXT);
-			if (chl <= 1) {
-				if (work[i] != ' ')
-					last_u = j;
-			} else {
-				last_u = j;
-			}
-			i += chl;
-		}
-		if (!last_u)
+		/* Never prepend '.' to hidden files here.
+		 * That is done only for msdos mounts (and only when
+		 * 'dotsOK=yes'); if we are executing here, it is in the
+		 * context of a vfat mount.
+		 */
+		len = fat_parse_short(sb, de, bufname, 0);
+		if (len == 0)
 			continue;
 
 		/* Compare shortname */
-		bufuname[last_u] = 0x0000;
-		len = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
 		if (fat_name_match(sbi, name, name_len, bufname, len))
 			goto found;
 
@@ -469,20 +557,15 @@ static int __fat_readdir(struct inode *i
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_disk = sbi->nls_disk;
 	unsigned char nr_slots;
-	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char c, work[MSDOS_NAME];
-	unsigned char bufname[FAT_MAX_SHORT_SIZE], *ptname = bufname;
-	unsigned short opt_shortname = sbi->options.shortname;
+	unsigned char bufname[FAT_MAX_SHORT_SIZE];
 	int isvfat = sbi->options.isvfat;
-	int nocase = sbi->options.nocase;
 	const char *fill_name = NULL;
 	unsigned long inum;
 	unsigned long lpos, dummy, *furrfu = &lpos;
 	loff_t cpos;
-	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len = 0;
+	int short_len = 0, fill_len = 0;
 	int ret = 0;
 
 	lock_super(sb);
@@ -556,74 +639,10 @@ parse_record:
 		}
 	}
 
-	if (sbi->options.dotsOK) {
-		ptname = bufname;
-		dotoffset = 0;
-		if (de->attr & ATTR_HIDDEN) {
-			*ptname++ = '.';
-			dotoffset = 1;
-		}
-	}
-
-	memcpy(work, de->name, sizeof(de->name));
-	/* see namei.c, msdos_format_name */
-	if (work[0] == 0x05)
-		work[0] = 0xE5;
-	for (i = 0, j = 0, last = 0, last_u = 0; i < 8;) {
-		if (!(c = work[i]))
-			break;
-		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
-					&bufuname[j++], opt_shortname,
-					de->lcase & CASE_LOWER_BASE);
-		if (chl <= 1) {
-			ptname[i++] = (!nocase && c>='A' && c<='Z') ? c+32 : c;
-			if (c != ' ') {
-				last = i;
-				last_u = j;
-			}
-		} else {
-			last_u = j;
-			for (chi = 0; chi < chl && i < 8; chi++) {
-				ptname[i] = work[i];
-				i++; last = i;
-			}
-		}
-	}
-	i = last;
-	j = last_u;
-	fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
-	ptname[i++] = '.';
-	for (i2 = 8; i2 < MSDOS_NAME;) {
-		if (!(c = work[i2]))
-			break;
-		chl = fat_shortname2uni(nls_disk, &work[i2], MSDOS_NAME - i2,
-					&bufuname[j++], opt_shortname,
-					de->lcase & CASE_LOWER_EXT);
-		if (chl <= 1) {
-			i2++;
-			ptname[i++] = (!nocase && c>='A' && c<='Z') ? c+32 : c;
-			if (c != ' ') {
-				last = i;
-				last_u = j;
-			}
-		} else {
-			last_u = j;
-			for (chi = 0; chi < chl && i2 < MSDOS_NAME; chi++) {
-				ptname[i++] = work[i2++];
-				last = i;
-			}
-		}
-	}
-	if (!last)
+	short_len = fat_parse_short(sb, de, bufname, sbi->options.dotsOK);
+	if (short_len == 0)
 		goto record_end;
 
-	i = last + dotoffset;
-	j = last_u;
-
-	if (isvfat) {
-		bufuname[j] = 0x0000;
-		i = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
-	}
 	if (nr_slots) {
 		/* hack for fat_ioctl_filldir() */
 		struct fat_ioctl_filldir_callback *p = dirent;
@@ -631,12 +650,12 @@ parse_record:
 		p->longname = fill_name;
 		p->long_len = fill_len;
 		p->shortname = bufname;
-		p->short_len = i;
+		p->short_len = short_len;
 		fill_name = NULL;
 		fill_len = 0;
 	} else {
 		fill_name = bufname;
-		fill_len = i;
+		fill_len = short_len;
 	}
 
 start_filldir:
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch
fat-exportfs-move-nfs-support-code.patch
fat-exportfs-fix-dentry-reconnection.patch

