From: akpm@linux-foundation.org
Subject: + fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:39 -0700
Message-ID: <20120820202340.8BFD720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:54415 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2HTUXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:42 -0400
Received: by faem1 with SMTP id m1so221793fae.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix all other checkpatch issues in dir.c
has been added to the -mm tree.  Its filename is
     fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch

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
Subject: fs/fat: fix all other checkpatch issues in dir.c

1: Import linux/uaccess.h instead of asm.uaccess.h
2: Stop any lines going over 80 characters
3: Stopped setting any variables in if statements
4: Stopped splitting quoted strings
5: Removed unneeded parentheses

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc fs/fat/dir.c
--- a/fs/fat/dir.c~fs-fat-fix-all-other-checkpatch-issues-in-dirc
+++ a/fs/fat/dir.c
@@ -18,7 +18,7 @@
 #include <linux/time.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include "fat.h"
 
@@ -123,7 +123,8 @@ static inline int fat_get_entry(struct i
 {
 	/* Fast stuff first */
 	if (*bh && *de &&
-	    (*de - (struct msdos_dir_entry *)(*bh)->b_data) < MSDOS_SB(dir->i_sb)->dir_per_block - 1) {
+	   (*de - (struct msdos_dir_entry *)(*bh)->b_data) <
+				MSDOS_SB(dir->i_sb)->dir_per_block - 1) {
 		*pos += sizeof(struct msdos_dir_entry);
 		(*de)++;
 		return 0;
@@ -155,7 +156,8 @@ static int uni16_to_x8(struct super_bloc
 
 	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
 		ec = *ip++;
-		if ((charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
+		charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE);
+		if (charlen > 0) {
 			op += charlen;
 			len -= charlen;
 		} else {
@@ -172,12 +174,12 @@ static int uni16_to_x8(struct super_bloc
 	}
 
 	if (unlikely(*ip)) {
-		fat_msg(sb, KERN_WARNING, "filename was truncated while "
-			"converting.");
+		fat_msg(sb, KERN_WARNING,
+			"filename was truncated while converting.");
 	}
 
 	*op = 0;
-	return (op - ascii);
+	return op - ascii;
 }
 
 static inline int fat_uni_to_x8(struct super_block *sb, const wchar_t *uni,
@@ -205,7 +207,8 @@ fat_short2uni(struct nls_table *t, unsig
 }
 
 static inline int
-fat_short2lower_uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
+fat_short2lower_uni(struct nls_table *t, unsigned char *c,
+		    int clen, wchar_t *uni)
 {
 	int charlen;
 	wchar_t wc;
@@ -220,7 +223,9 @@ fat_short2lower_uni(struct nls_table *t,
 		if (!nc)
 			nc = *c;
 
-		if ( (charlen = t->char2uni(&nc, 1, uni)) < 0) {
+		charlen = t->char2uni(&nc, 1, uni);
+
+		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
 		}
@@ -573,7 +578,8 @@ static int __fat_readdir(struct inode *i
 	/* Fake . and .. for the root directory. */
 	if (inode->i_ino == MSDOS_ROOT_INO) {
 		while (cpos < 2) {
-			if (filldir(dirent, "..", cpos+1, cpos, MSDOS_ROOT_INO, DT_DIR) < 0)
+			if (filldir(dirent, "..", cpos+1, cpos,
+				    MSDOS_ROOT_INO, DT_DIR) < 0)
 				goto out;
 			cpos++;
 			filp->f_pos++;
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

