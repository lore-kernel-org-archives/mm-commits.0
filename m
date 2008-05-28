From: akpm@linux-foundation.org
Subject: + msdos-fs-remove-unsettable-atari-option.patch added to -mm tree
Date: Wed, 28 May 2008 15:40:27 -0700
Message-ID: <200805282240.m4SMeRKg003984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYE1WlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 18:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.scharfe@lsrfire.ath.cx, hirofumi@mail.parknet.co.jp


The patch titled
     msdos fs: remove unsettable atari option
has been added to the -mm tree.  Its filename is
     msdos-fs-remove-unsettable-atari-option.patch

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
Subject: msdos fs: remove unsettable atari option
From: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>

It has been impossible to set the option 'atari' of the MSDOS filesystem
for several years.  Since nobody seems to have missed it, let's remove its
remains.

Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/msdos/namei.c         |   18 ++++++------------
 include/linux/msdos_fs.h |    1 -
 2 files changed, 6 insertions(+), 13 deletions(-)

diff -puN fs/msdos/namei.c~msdos-fs-remove-unsettable-atari-option fs/msdos/namei.c
--- a/fs/msdos/namei.c~msdos-fs-remove-unsettable-atari-option
+++ a/fs/msdos/namei.c
@@ -14,12 +14,7 @@
 
 /* Characters that are undesirable in an MS-DOS file name */
 static unsigned char bad_chars[] = "*?<>|\"";
-static unsigned char bad_if_strict_pc[] = "+=,; ";
-/* GEMDOS is less restrictive */
-static unsigned char bad_if_strict_atari[] = " ";
-
-#define bad_if_strict(opts) \
-	((opts)->atari ? bad_if_strict_atari : bad_if_strict_pc)
+static unsigned char bad_if_strict[] = "+=,; ";
 
 /***** Formats an MS-DOS file name. Rejects invalid names. */
 static int msdos_format_name(const unsigned char *name, int len,
@@ -40,21 +35,20 @@ static int msdos_format_name(const unsig
 			/* Get rid of dot - test for it elsewhere */
 			name++;
 			len--;
-		} else if (!opts->atari)
+		} else
 			return -EINVAL;
 	}
 	/*
-	 * disallow names that _really_ start with a dot for MS-DOS,
-	 * GEMDOS does not care
+	 * disallow names that _really_ start with a dot
 	 */
-	space = !opts->atari;
+	space = 1;
 	c = 0;
 	for (walk = res; len && walk - res < 8; walk++) {
 		c = *name++;
 		len--;
 		if (opts->name_check != 'r' && strchr(bad_chars, c))
 			return -EINVAL;
-		if (opts->name_check == 's' && strchr(bad_if_strict(opts), c))
+		if (opts->name_check == 's' && strchr(bad_if_strict, c))
 			return -EINVAL;
 		if (c >= 'A' && c <= 'Z' && opts->name_check == 's')
 			return -EINVAL;
@@ -94,7 +88,7 @@ static int msdos_format_name(const unsig
 			if (opts->name_check != 'r' && strchr(bad_chars, c))
 				return -EINVAL;
 			if (opts->name_check == 's' &&
-			    strchr(bad_if_strict(opts), c))
+			    strchr(bad_if_strict, c))
 				return -EINVAL;
 			if (c < ' ' || c == ':' || c == '\\')
 				return -EINVAL;
diff -puN include/linux/msdos_fs.h~msdos-fs-remove-unsettable-atari-option include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~msdos-fs-remove-unsettable-atari-option
+++ a/include/linux/msdos_fs.h
@@ -208,7 +208,6 @@ struct fat_mount_options {
 		 utf8:1,	  /* Use of UTF-8 character set (Default) */
 		 unicode_xlate:1, /* create escape sequences for unhandled Unicode */
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
-		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1;	  /* Use free_clusters for FAT32 */
_

Patches currently in -mm which might be from rene.scharfe@lsrfire.ath.cx are

msdos-fs-remove-unsettable-atari-option.patch

