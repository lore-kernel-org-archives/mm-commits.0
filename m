From: akpm@linux-foundation.org
Subject: - fat-remove-fat_clusters_flush.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:38 -0700
Message-ID: <200804282201.m3SM1cF3018883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965808AbYD1WBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Remove fat_clusters_flush()
has been removed from the -mm tree.  Its filename was
     fat-remove-fat_clusters_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
