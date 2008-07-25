From: akpm@linux-foundation.org
Subject: - fat-fix-parse_options.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:23 -0700
Message-ID: <200807252257.m6PMvNxh003183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYGYW5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: fix parse_options()
has been removed from the -mm tree.  Its filename was
     fat-fix-parse_options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

