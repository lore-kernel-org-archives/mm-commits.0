From: akpm@linux-foundation.org
Subject: + fat-remove-fat_clusters_flush.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:07:50 -0700
Message-ID: <200804271907.m3RJ7okg020435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763017AbYD0THx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:07:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Remove fat_clusters_flush()
has been added to the -mm tree.  Its filename is
     fat-remove-fat_clusters_flush.patch

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
Subject: fat: Remove fat_clusters_flush()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This removes unneeded fat_clusters_flush().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/fat/fatent.c~fat-remove-fat_clusters_flush fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-remove-fat_clusters_flush
+++ a/fs/fat/fatent.c
@@ -585,8 +585,6 @@ error:
 		brelse(bhs[i]);
 	unlock_fat(sbi);
 
-	fat_clusters_flush(sb);
