From: akpm@linux-foundation.org
Subject: +
 nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch added
 to -mm tree
Date: Wed, 05 Feb 2014 13:49:10 -0800
Message-ID: <52f2b1d6.rY8djeO9sp19BTZH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBEVtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 16:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,andreas.rohner@gmx.net
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 13:49:10 -0800


The patch titled
     Subject: nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix
has been added to the -mm tree.  Its filename is
     nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch

