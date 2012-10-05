From: akpm@linux-foundation.org
Subject: [merged] fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:38 -0700
Message-ID: <20121005201839.21879200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55302 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2JEUSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:40 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141084lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: fix all other checkpatch issues in dir.c
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/fat/dir.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

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
@@ -220,7 +223,8 @@ fat_short2lower_uni(struct nls_table *t,
 		if (!nc)
 			nc = *c;
 
-		if ( (charlen = t->char2uni(&nc, 1, uni)) < 0) {
+		charlen = t->char2uni(&nc, 1, uni);
+		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
 		}
@@ -573,7 +577,8 @@ static int __fat_readdir(struct inode *i
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

origin.patch

