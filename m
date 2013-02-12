From: akpm@linux-foundation.org
Subject: [withdrawn] fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod.patch removed from -mm tree
Date: Mon, 11 Feb 2013 16:13:24 -0800
Message-ID: <20130212001325.54BEA31C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:52115 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BLAN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Feb 2013 19:13:26 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so1267531iad.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Feb 2013 16:13:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD
has been removed from the -mm tree.  Its filename was
     fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD

When doing lookups via fat_search_long(), we can stop checking for further
entries if we detect End of Directory, i.e.  if (de->name[0] == 0x00).The
current code traverses the cluster chain of a directory until a hit is
found or till the last cluster for that directory, ignoring the EOD mark. 
Fix this.

Likewise,when readdir(3) is called, we can stop checking for further
entries in __fat_readdir() when we hit EOD.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod fs/fat/dir.c
--- a/fs/fat/dir.c~fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod
+++ a/fs/fat/dir.c
@@ -484,10 +484,10 @@ parse_record:
 		nr_slots = 0;
 		if (de->name[0] == DELETED_FLAG)
 			continue;
+		if (!de->name[0])
+			goto end_of_dir;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
 			continue;
-		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			continue;
 		if (de->attr == ATTR_EXT) {
 			int status = fat_parse_long(inode, &cpos, &bh, &de,
 						    &unicode, &nr_slots);
@@ -608,8 +608,8 @@ parse_record:
 			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
 			goto record_end;
-		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			goto record_end;
+		if (!de->name[0])
+			goto end_of_dir;
 	} else {
 		if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
 			goto record_end;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch
lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch

