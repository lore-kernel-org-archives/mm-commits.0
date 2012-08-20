From: akpm@linux-foundation.org
Subject: + fs-fat-fix-checkpatch-issues-in-fatentc.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:47 -0700
Message-ID: <20120820202348.8B2775C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35981 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2HTUXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:23:50 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so314618lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix checkpatch issues in fatent.c
has been added to the -mm tree.  Its filename is
     fs-fat-fix-checkpatch-issues-in-fatentc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
