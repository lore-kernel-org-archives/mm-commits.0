From: akpm@linux-foundation.org
Subject: [merged] fat-use-accessor-function-for-msdos_dir_entry-start.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:09 -0700
Message-ID: <20121005201810.241E65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55302 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:12 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141084lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: use accessor function for msdos_dir_entry 'start'
has been removed from the -mm tree.  Its filename was
     fat-use-accessor-function-for-msdos_dir_entry-start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

