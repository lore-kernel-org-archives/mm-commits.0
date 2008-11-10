From: akpm@linux-foundation.org
Subject: - fat-cleanup-fat_parse_long-error-handling.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:17 -0800
Message-ID: <200811102033.mAAKXHaP024402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYKJUiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrenrjenkins@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: cleanup fat_parse_long() error handling
has been removed from the -mm tree.  Its filename was
     fat-cleanup-fat_parse_long-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


