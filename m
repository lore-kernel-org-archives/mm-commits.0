From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:00 -0700
Message-ID: <53ea6d54.Jzlpp3jxbPsEzwLk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:37810 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaHLTjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:01 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2668448pde.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, fengguang.wu@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: check superblock before dump operation
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/befs/linuxvfs.c: check superblock before dump operation

befs_dump_super_block was called between befs_load_sb and befs_check_sb.
It has been reported to crash (5/900) with null block testing.

This patch loads, checks and only dump superblock if it's a valid one then
brelse bh.

(befs_dump_super_block uses disk_sb (bh->b_data) so it seems we need to call
it before brelse(bh) but I don't know why befs_check_sb was called
after brelse. Another thing I don't understand is why this problem appears now).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-check-superblock-before-dump-operation fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-check-superblock-before-dump-operation
+++ a/fs/befs/linuxvfs.c
@@ -832,16 +832,14 @@ befs_fill_super(struct super_block *sb,
 		    (befs_super_block *) ((void *) bh->b_data + x86_sb_off);
 	}
 
-	if (befs_load_sb(sb, disk_sb) != BEFS_OK)
+	if ((befs_load_sb(sb, disk_sb) != BEFS_OK) ||
+	    (befs_check_sb(sb) != BEFS_OK))
 		goto unacquire_bh;
 
 	befs_dump_super_block(sb, disk_sb);
 
 	brelse(bh);
 
-	if (befs_check_sb(sb) != BEFS_OK)
-		goto unacquire_priv_sbp;
