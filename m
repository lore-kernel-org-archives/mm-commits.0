From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
 removed from -mm tree
Date: Thu, 03 Apr 2014 14:12:55 -0700
Message-ID: <533dced7.rLnURPtLj9kWFFF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaDCVM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp

Subject: [folded-merged] nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch removed from -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,andreas.rohner@gmx.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:12:55 -0700


The patch titled
     Subject: nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch

This patch was dropped because it was folded into nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix

Use put_bh() instead of brelse() because we know bh != NULL.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix
+++ a/fs/nilfs2/sufile.c
@@ -978,13 +978,13 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 
 		/* get different block */
 		mark_buffer_dirty(bh);
-		brelse(bh);
+		put_bh(bh);
 		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
 		if (unlikely(ret < 0))
 			goto out_mark;
 	}
 	mark_buffer_dirty(bh);
-	brelse(bh);
+	put_bh(bh);
 
  out_mark:
 	if (ncleaned || ndirtied) {
@@ -994,7 +994,7 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 	}
 	nilfs_mdt_mark_dirty(sufile);
  out_header:
-	brelse(header_bh);
+	put_bh(header_bh);
  out_sem:
 	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-update-maintainers-file-entries.patch
nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch
nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
nilfs2-verify-metadata-sizes-read-from-disk.patch
nilfs2-update-maintainers-file-entries-fix.patch
nilfs2-update-projects-web-site-in-nilfs2txt.patch

