From: akpm@linux-foundation.org
Subject: + gfs2-replace-current_time-with-current_time.patch added to -mm
 tree
Date: Thu, 20 Apr 2017 12:55:42 -0700
Message-ID: <58f9123e.F58XeJ0JbEbEmRxS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945077AbdDTTzn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2017 15:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: replace CURRENT_TIME with current_time
has been added to the -mm tree.  Its filename is
     gfs2-replace-current_time-with-current_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gfs2-replace-current_time-with-current_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gfs2-replace-current_time-with-current_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: gfs2: replace CURRENT_TIME with current_time

Link: http://lkml.kernel.org/r/20170420161852.0492bc3f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/gfs2/bmap.c~gfs2-replace-current_time-with-current_time fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~gfs2-replace-current_time-with-current_time
+++ a/fs/gfs2/bmap.c
@@ -1072,7 +1072,7 @@ out_unlock:
 			/* Every transaction boundary, we rewrite the dinode
 			   to keep its di_blocks current in case of failure. */
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime =
-				CURRENT_TIME;
+				current_time(&ip->i_inode);
 			gfs2_trans_add_meta(ip->i_gl, dibh);
 			gfs2_dinode_out(ip, dibh->b_data);
 			up_write(&ip->i_rw_mutex);
@@ -1293,7 +1293,7 @@ static int trunc_dealloc(struct gfs2_ino
 		gfs2_statfs_change(sdp, 0, +btotal, 0);
 		gfs2_quota_change(ip, -(s64)btotal, ip->i_inode.i_uid,
 				  ip->i_inode.i_gid);
-		ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
+		ip->i_inode.i_mtime = ip->i_inode.i_ctime = current_time(&ip->i_inode);
 		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		up_write(&ip->i_rw_mutex);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers-fix.patch
treewide-decouple-cacheflushh-and-set_memoryh-fix.patch
gfs2-replace-current_time-with-current_time.patch

