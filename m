From: akpm@linux-foundation.org
Subject: [merged] hpfs-remove-printk-macro.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:20 -0700
Message-ID: <20120601193320.51CF5A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42352 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042Ab2FATdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:21 -0400
Received: by yhgm50 with SMTP id m50so287975yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HPFS: remove PRINTK() macro
has been removed from the -mm tree.  Its filename was
     hpfs-remove-printk-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
