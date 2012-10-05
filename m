From: akpm@linux-foundation.org
Subject: [merged] fs-fat-fix-checkpatch-issues-in-fatentc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:42 -0700
Message-ID: <20121005201843.1AF5820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52715 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2JEUSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:45 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so139030bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: fix checkpatch issues in fatent.c
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-checkpatch-issues-in-fatentc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: fs/fat: fix checkpatch issues in fatent.c

1: Stop any lines going over 80 characters
2: Remove a blank line before EXPORT_SYMBOL_GPL

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/fat/fatent.c~fs-fat-fix-checkpatch-issues-in-fatentc fs/fat/fatent.c
--- a/fs/fat/fatent.c~fs-fat-fix-checkpatch-issues-in-fatentc
+++ a/fs/fat/fatent.c
@@ -203,15 +203,18 @@ static int fat12_ent_next(struct fat_ent
 
 	fatent->entry++;
 	if (fatent->nr_bhs == 1) {
-		WARN_ON(ent12_p[0] > (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 2)));
-		WARN_ON(ent12_p[1] > (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1)));
+		WARN_ON(ent12_p[0] > (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 2)));
+		WARN_ON(ent12_p[1] > (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 1)));
 		if (nextp < (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1))) {
 			ent12_p[0] = nextp - 1;
 			ent12_p[1] = nextp;
 			return 1;
 		}
 	} else {
-		WARN_ON(ent12_p[0] != (u8 *)(bhs[0]->b_data + (bhs[0]->b_size - 1)));
+		WARN_ON(ent12_p[0] != (u8 *)(bhs[0]->b_data +
+							(bhs[0]->b_size - 1)));
 		WARN_ON(ent12_p[1] != (u8 *)bhs[1]->b_data);
 		ent12_p[0] = nextp - 1;
 		ent12_p[1] = nextp;
@@ -631,7 +634,6 @@ error:
 
 	return err;
 }
