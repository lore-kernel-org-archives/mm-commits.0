From: akpm@linux-foundation.org
Subject: [patch 099/114] gfs2: replace CURRENT_TIME with
 current_time
Date: Mon, 08 May 2017 15:59:34 -0700
Message-ID: <20170508225934.qrSDLNSWl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdEHW7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org

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
