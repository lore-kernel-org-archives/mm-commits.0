From: akpm@linux-foundation.org
Subject: [merged] fat-no-need-to-reset-eof-in-ent_put-for-fat32.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:46 -0700
Message-ID: <20121005201847.30B305C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:48485 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2JEUSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:50 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98902lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: no need to reset EOF in ent_put for FAT32
has been removed from the -mm tree.  Its filename was
     fat-no-need-to-reset-eof-in-ent_put-for-fat32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: no need to reset EOF in ent_put for FAT32

#define FAT_ENT_EOF(EOF_FAT32)

there is no need to reset value of 'new' for FAT32 as the values is
already correct

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/fat/fatent.c~fat-no-need-to-reset-eof-in-ent_put-for-fat32 fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-no-need-to-reset-eof-in-ent_put-for-fat32
+++ a/fs/fat/fatent.c
@@ -186,9 +186,6 @@ static void fat16_ent_put(struct fat_ent
 
 static void fat32_ent_put(struct fat_entry *fatent, int new)
 {
-	if (new == FAT_ENT_EOF)
-		new = EOF_FAT32;
