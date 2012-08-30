From: akpm@linux-foundation.org
Subject: + fat-simplify-writeback_inode.patch added to -mm tree
Date: Thu, 30 Aug 2012 13:01:53 -0700
Message-ID: <20120830200154.A21225C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:64261 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2H3UB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 16:01:56 -0400
Received: by wgbdt11 with SMTP id dt11so118537wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 13:01:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: simplify writeback_inode()
has been added to the -mm tree.  Its filename is
     fat-simplify-writeback_inode.patch

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
Subject: fat: simplify writeback_inode()

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/fat/inode.c~fat-simplify-writeback_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-simplify-writeback_inode
+++ a/fs/fat/inode.c
@@ -1457,18 +1457,14 @@ static int writeback_inode(struct inode 
 {
 
 	int ret;
-	struct address_space *mapping = inode->i_mapping;
-	struct writeback_control wbc = {
-	       .sync_mode = WB_SYNC_NONE,
-	      .nr_to_write = 0,
-	};
-	/* if we used WB_SYNC_ALL, sync_inode waits for the io for the
-	* inode to finish.  So WB_SYNC_NONE is sent down to sync_inode
+
+	/* if we used wait=1, sync_inode_metadata waits for the io for the
+	* inode to finish.  So wait=0 is sent down to sync_inode_metadata
 	* and filemap_fdatawrite is used for the data blocks
 	*/
-	ret = sync_inode(inode, &wbc);
+	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-	       ret = filemap_fdatawrite(mapping);
+	       ret = filemap_fdatawrite(inode->i_mapping);
 	return ret;
 }
 
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
fat-use-accessor-function-for-msdos_dir_entry-start.patch
fat-no-need-to-reset-eof-in-ent_put-for-fat32.patch
fat-simplify-writeback_inode.patch

