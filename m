From: akpm@linux-foundation.org
Subject: + fat-cleanup-fat_parse_long-error-handling.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:26 -0700
Message-ID: <200810162207.m9GM7QAH028053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176AbYJPWHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darrenrjenkins@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     fat: cleanup fat_parse_long() error handling
has been added to the -mm tree.  Its filename is
     fat-cleanup-fat_parse_long-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: cleanup fat_parse_long() error handling
From: "Darren Jenkins" <darrenrjenkins@gmail.com>

Coverity CID 2332 & 2333 RESOURCE_LEAK

In fat_search_long() if fat_parse_long() returns a -ve value we return
without first freeing unicode.  This patch free's them on this error path.

The above was false positive on current tree, but this change is more
clean, so apply as cleanup.

[hirofumi@mail.parknet.co.jp: fix coding style]
Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/fat/dir.c~fat-cleanup-fat_parse_long-error-handling fs/fat/dir.c
--- a/fs/fat/dir.c~fat-cleanup-fat_parse_long-error-handling
+++ a/fs/fat/dir.c
@@ -373,9 +373,10 @@ parse_record:
 		if (de->attr == ATTR_EXT) {
 			int status = fat_parse_long(inode, &cpos, &bh, &de,
 						    &unicode, &nr_slots);
-			if (status < 0)
-				return status;
-			else if (status == PARSE_INVALID)
+			if (status < 0) {
+				err = status;
+				goto end_of_dir;
+			} else if (status == PARSE_INVALID)
 				continue;
 			else if (status == PARSE_NOT_LONGNAME)
 				goto parse_record;
_

Patches currently in -mm which might be from darrenrjenkins@gmail.com are

fat-cleanup-fat_parse_long-error-handling.patch

