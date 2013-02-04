From: akpm@linux-foundation.org
Subject: + fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod.patch added to -mm tree
Date: Mon, 04 Feb 2013 14:08:27 -0800
Message-ID: <20130204220827.B94CD5A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:54358 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BDWIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 17:08:30 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so519153vea.0
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 14:08:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: eliminate iterations in fat_search_long and __fat_readdir in case of EOD
has been added to the -mm tree.  Its filename is
     fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fat-eliminate-iterations-in-fat_search_long-and-__fat_readdir-in-case-of-eod.patch

