From: akpm@linux-foundation.org
Subject: + vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:50:08 -0700
Message-ID: <200804271950.m3RJo8VF021952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763325AbYD0TuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ek9852@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     vfat: bug fix for vfat cannot handle filename with 255
has been added to the -mm tree.  Its filename is
     vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfat: bug fix for vfat cannot handle filename with 255
From: Keith Mok <ek9852@gmail.com>

This patch fix the problem that the buffer allocated for convert of unicode to
utf8 in fat/dir.c is too small.

And cannot handle filename with 255 asian characters when mounted with utf8
options.

Also it fix the filename length limitation checking in vfat/namei.c that the
filename length should be checked against the number of converted unicode
characters.

Not the length before NLS/UTF8 converted.

Signed-off-by: Keith Mok <ek9852@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c    |   44 ++++++++++++++++++++++++++++----------------
 fs/vfat/namei.c |   25 +++++++++++--------------
 2 files changed, 39 insertions(+), 30 deletions(-)

diff -puN fs/fat/dir.c~vfat-bug-fix-for-vfat-cannot-handle-filename-with-255 fs/fat/dir.c
--- a/fs/fat/dir.c~vfat-bug-fix-for-vfat-cannot-handle-filename-with-255
+++ a/fs/fat/dir.c
@@ -124,8 +124,8 @@ static inline int fat_get_entry(struct i
  * but ignore that right now.
  * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
  */
-static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int uni_xlate,
-		       struct nls_table *nls)
+static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len,
+		       int uni_xlate, struct nls_table *nls)
 {
 	wchar_t *ip, ec;
 	unsigned char *op, nc;
@@ -135,10 +135,11 @@ static int uni16_to_x8(unsigned char *as
 	ip = uni;
 	op = ascii;
 
-	while (*ip) {
+	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
 		ec = *ip++;
 		if ( (charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
 			op += charlen;
+			len -= charlen;
 		} else {
 			if (uni_xlate == 1) {
 				*op = ':';
@@ -149,16 +150,19 @@ static int uni16_to_x8(unsigned char *as
 					ec >>= 4;
 				}
 				op += 5;
+				len -= 5;
 			} else {
 				*op++ = '?';
+				len--;
 			}
 		}
-		/* We have some slack there, so it's OK */
-		if (op>ascii+256) {
-			op = ascii + 256;
-			break;
-		}
 	}
+
+	if (unlikely(*ip)) {
+		printk(KERN_WARNING "FAT: filename was truncated while "
+		       "converting.");
+	}
+
 	*op = 0;
 	return (op - ascii);
 }
@@ -311,9 +315,11 @@ int fat_search_long(struct inode *inode,
 	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
 	wchar_t bufuname[14];
-	unsigned char xlate_len, nr_slots;
+	unsigned char nr_slots;
+	int xlate_len;
 	wchar_t *unicode = NULL;
-	unsigned char work[MSDOS_NAME], bufname[260];	/* 256 + 4 */
+	unsigned char work[MSDOS_NAME];
+	unsigned char *bufname = NULL;
 	int uni_xlate = sbi->options.unicode_xlate;
 	int utf8 = sbi->options.utf8;
 	int anycase = (sbi->options.name_check != 's');
@@ -321,6 +327,10 @@ int fat_search_long(struct inode *inode,
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err;
 
+	bufname = (unsigned char*)__get_free_page(GFP_KERNEL);
+	if (!bufname)
+		return -ENOMEM;
+
 	err = -ENOENT;
 	while(1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
@@ -386,8 +396,8 @@ parse_record:
 
 		bufuname[last_u] = 0x0000;
 		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			:uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
+			?utf8_wcstombs(bufname, bufuname, PAGE_SIZE)
+			:uni16_to_x8(bufname, bufuname, PAGE_SIZE, uni_xlate, nls_io);
 		if (xlate_len == name_len)
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
 			    (anycase && !nls_strnicmp(nls_io, name, bufname,
@@ -396,8 +406,8 @@ parse_record:
 
 		if (nr_slots) {
 			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, sizeof(bufname))
-				:uni16_to_x8(bufname, unicode, uni_xlate, nls_io);
+				?utf8_wcstombs(bufname, unicode, PAGE_SIZE)
+				:uni16_to_x8(bufname, unicode, PAGE_SIZE, uni_xlate, nls_io);
 			if (xlate_len != name_len)
 				continue;
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
@@ -416,6 +426,8 @@ Found:
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
 EODir:
+	if (bufname)
+		free_page((unsigned long)bufname);
 	if (unicode)
 		free_page((unsigned long)unicode);
 
@@ -598,7 +610,7 @@ parse_record:
 	if (isvfat) {
 		bufuname[j] = 0x0000;
 		i = utf8 ? utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			 : uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
+			 : uni16_to_x8(bufname, bufuname, sizeof(bufname), uni_xlate, nls_io);
 	}
 
 	fill_name = bufname;
@@ -610,7 +622,7 @@ parse_record:
 		int buf_size = PAGE_SIZE - (261 * sizeof(unicode[0]));
 		int long_len = utf8
 			? utf8_wcstombs(longname, unicode, buf_size)
-			: uni16_to_x8(longname, unicode, uni_xlate, nls_io);
+			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
 
 		if (!both) {
 			fill_name = longname;
diff -puN fs/vfat/namei.c~vfat-bug-fix-for-vfat-cannot-handle-filename-with-255 fs/vfat/namei.c
--- a/fs/vfat/namei.c~vfat-bug-fix-for-vfat-cannot-handle-filename-with-255
+++ a/fs/vfat/namei.c
@@ -176,15 +176,10 @@ static inline int vfat_is_used_badchars(
 	for (i = 0; i < len; i++)
 		if (vfat_bad_char(s[i]))
 			return -EINVAL;
-	return 0;
-}
 
-static int vfat_valid_longname(const unsigned char *name, unsigned int len)
-{
-	if (name[len - 1] == ' ')
+	if (s[i - 1] == ' ') /* last character cannot be space */
 		return -EINVAL;
-	if (len >= 256)
-		return -ENAMETOOLONG;
+
 	return 0;
 }
 
@@ -485,11 +480,14 @@ xlate_to_uni(const unsigned char *name, 
 		 */
 		*outlen -= (name_len - len);
 
+		if (*outlen > 255)
+			return -ENAMETOOLONG;
+
 		op = &outname[*outlen * sizeof(wchar_t)];
 	} else {
 		if (nls) {
 			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= 260;
+			     i < len && *outlen <= 255;
 			     *outlen += 1)
 			{
 				if (escape && (*ip == ':')) {
@@ -525,18 +523,20 @@ xlate_to_uni(const unsigned char *name, 
 					op += 2;
 				}
 			}
+			if (i < len)
+				return -ENAMETOOLONG;
 		} else {
 			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= 260;
+			     i < len && *outlen <= 255;
 			     i++, *outlen += 1)
 			{
 				*op++ = *ip++;
 				*op++ = 0;
 			}
+			if (i < len)
+				return -ENAMETOOLONG;
 		}
 	}
-	if (*outlen > 260)
-		return -ENAMETOOLONG;
 
 	*longlen = *outlen;
 	if (*outlen % 13) {
@@ -574,9 +574,6 @@ static int vfat_build_slots(struct inode
 	loff_t offset;
 
 	*nr_slots = 0;
-	err = vfat_valid_longname(name, len);
-	if (err)
-		return err;
 
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
_

Patches currently in -mm which might be from ek9852@gmail.com are

input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch

