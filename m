From: akpm@linux-foundation.org
Subject: [merged] fs-befs-check-silent-flag-before-logging-errors.patch
 removed from -mm tree
Date: Mon, 01 Aug 2016 17:25:25 -0700
Message-ID: <579fe875.1POA77xBAuXmrsVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbcHBAZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 20:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c: check silent flag before logging errors
has been removed from the -mm tree.  Its filename was
     fs-befs-check-silent-flag-before-logging-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c: check silent flag before logging errors

Log errors only when silent flag is not set.

Link: http://lkml.kernel.org/r/d400aaf5a7430de79bd956e40ec075fb1cb08474.1464226521.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-check-silent-flag-before-logging-errors fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-check-silent-flag-before-logging-errors
+++ a/fs/befs/linuxvfs.c
@@ -772,7 +772,8 @@ befs_fill_super(struct super_block *sb,
 	befs_sb = BEFS_SB(sb);
 
 	if (!parse_options((char *) data, &befs_sb->mount_opts)) {
-		befs_error(sb, "cannot parse mount options");
+		if (!silent)
+			befs_error(sb, "cannot parse mount options");
 		goto unacquire_priv_sbp;
 	}
 
@@ -796,7 +797,8 @@ befs_fill_super(struct super_block *sb,
 	sb_min_blocksize(sb, 1024);
 
 	if (!(bh = sb_bread(sb, sb_block))) {
-		befs_error(sb, "unable to read superblock");
+		if (!silent)
+			befs_error(sb, "unable to read superblock");
 		goto unacquire_priv_sbp;
 	}
 
@@ -820,9 +822,9 @@ befs_fill_super(struct super_block *sb,
 	brelse(bh);
 
 	if( befs_sb->num_blocks > ~((sector_t)0) ) {
-		befs_error(sb, "blocks count: %llu "
-			"is larger than the host can use",
-			befs_sb->num_blocks);
+		if (!silent)
+			befs_error(sb, "blocks count: %llu is larger than the host can use",
+					befs_sb->num_blocks);
 		goto unacquire_priv_sbp;
 	}
 
@@ -841,7 +843,8 @@ befs_fill_super(struct super_block *sb,
 	}
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
-		befs_error(sb, "get root inode failed");
+		if (!silent)
+			befs_error(sb, "get root inode failed");
 		goto unacquire_priv_sbp;
 	}
 
_

Patches currently in -mm which might be from salah.triki@acm.org are


