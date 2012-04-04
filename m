From: akpm@linux-foundation.org
Subject: + hpfs-remove-printk-macro.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:03:56 -0700
Message-ID: <20120404220356.971ECA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53771 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2DDWD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:03:58 -0400
Received: by yenq2 with SMTP id q2so99759yen.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:03:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com


The patch titled
     Subject: HPFS: remove PRINTK() macro
has been added to the -mm tree.  Its filename is
     hpfs-remove-printk-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: HPFS: remove PRINTK() macro

The PRINTK() macro isn't really used.  Let's just remove it because it
is ugly and out of date.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/buffer.c  |    1 -
 fs/hpfs/hpfs_fn.h |    7 -------
 2 files changed, 8 deletions(-)

diff -puN fs/hpfs/buffer.c~hpfs-remove-printk-macro fs/hpfs/buffer.c
--- a/fs/hpfs/buffer.c~hpfs-remove-printk-macro
+++ a/fs/hpfs/buffer.c
@@ -156,7 +156,6 @@ void hpfs_brelse4(struct quad_buffer_hea
 
 void hpfs_mark_4buffers_dirty(struct quad_buffer_head *qbh)
 {
-	PRINTK(("hpfs_mark_4buffers_dirty\n"));
 	memcpy(qbh->bh[0]->b_data, qbh->data, 512);
 	memcpy(qbh->bh[1]->b_data, qbh->data + 512, 512);
 	memcpy(qbh->bh[2]->b_data, qbh->data + 2 * 512, 512);
diff -puN fs/hpfs/hpfs_fn.h~hpfs-remove-printk-macro fs/hpfs/hpfs_fn.h
--- a/fs/hpfs/hpfs_fn.h~hpfs-remove-printk-macro
+++ a/fs/hpfs/hpfs_fn.h
@@ -35,13 +35,6 @@
 
 #define CHKCOND(x,y) if (!(x)) printk y
 
-#ifdef DBG
-#define PRINTK(x) printk x
-#else
-#undef PRINTK
-#define PRINTK(x)
-#endif
