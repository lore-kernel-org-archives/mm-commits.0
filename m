From: akpm@linux-foundation.org
Subject: + fat-use-accessor-function-for-msdos_dir_entry-start.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:13:15 -0700
Message-ID: <20120820201316.0CA14200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59231 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2HTUNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:13:18 -0400
Received: by weyr1 with SMTP id r1so311128wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:13:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: use accessor function for msdos_dir_entry 'start'
has been added to the -mm tree.  Its filename is
     fat-use-accessor-function-for-msdos_dir_entry-start.patch

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
Subject: fat: use accessor function for msdos_dir_entry 'start'

Use accessor function for msdos_dir_entry 'start'

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat-use-accessor-function-for-msdos_dir_entry-start fs/fat/dir.c
--- a/fs/fat/dir.c~fat-use-accessor-function-for-msdos_dir_entry-start
+++ a/fs/fat/dir.c
@@ -1141,10 +1141,8 @@ int fat_alloc_new_dir(struct inode *dir,
 		de[0].ctime_cs = de[1].ctime_cs = 0;
 		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = 0;
 	}
-	de[0].start = cpu_to_le16(cluster);
-	de[0].starthi = cpu_to_le16(cluster >> 16);
-	de[1].start = cpu_to_le16(MSDOS_I(dir)->i_logstart);
-	de[1].starthi = cpu_to_le16(MSDOS_I(dir)->i_logstart >> 16);
+	fat_set_start(&de[0], cluster);
+	fat_set_start(&de[1], MSDOS_I(dir)->i_logstart);
 	de[0].size = de[1].size = 0;
 	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
 	set_buffer_uptodate(bhs[0]);
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

documentation-update-mount-option-in-filesystem-vfattxt.patch
linux-next.patch
fat-use-accessor-function-for-msdos_dir_entry-start.patch

