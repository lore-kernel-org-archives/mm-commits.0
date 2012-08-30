From: akpm@linux-foundation.org
Subject: + fat-no-need-to-reset-eof-in-ent_put-for-fat32.patch added to -mm tree
Date: Thu, 30 Aug 2012 13:01:50 -0700
Message-ID: <20120830200151.747BD5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51031 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab2H3UBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Aug 2012 16:01:54 -0400
Received: by lagw12 with SMTP id w12so117824lag.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 13:01:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: no need to reset EOF in ent_put for FAT32
has been added to the -mm tree.  Its filename is
     fat-no-need-to-reset-eof-in-ent_put-for-fat32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
