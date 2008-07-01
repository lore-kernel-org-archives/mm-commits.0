From: akpm@linux-foundation.org
Subject: + fat-fix-parse_options.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:08 -0700
Message-ID: <200807010334.m613Y8Jx007130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYGADeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: fix parse_options()
has been added to the -mm tree.  Its filename is
     fat-fix-parse_options.patch

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
Subject: fat: fix parse_options()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Current parse_options() exits too early.  We need to run the code of
bottom in this function even if users doesn't specify options.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat-fix-parse_options fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-parse_options
+++ a/fs/fat/inode.c
@@ -950,7 +950,7 @@ static int parse_options(char *options, 
 	*debug = 0;
 
 	if (!options)
-		return 0;
+		goto out;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
@@ -1104,10 +1104,13 @@ static int parse_options(char *options, 
 			return -EINVAL;
 		}
 	}
+
+out:
 	/* UTF-8 doesn't provide FAT semantics */
 	if (!strcmp(opts->iocharset, "utf8")) {
 		printk(KERN_ERR "FAT: utf8 is not a recommended IO charset"
-		       " for FAT filesystems, filesystem will be case sensitive!\n");
+		       " for FAT filesystems, filesystem will be "
+		       "case sensitive!\n");
 	}
 
 	/* If user doesn't specify allow_utime, it's initialized from dmask. */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-parse_options.patch
fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
fat-cleanup-fs-fat-dirc.patch
fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch
fat-small-optimization-to-__fat_readdir.patch
pdflush-use-time_after-instead-of-open-coding-it.patch
msdos-fs-remove-unsettable-atari-option.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch

