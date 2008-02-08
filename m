From: akpm@linux-foundation.org
Subject: - use-__u32-in-linux-reiserfs_fsh.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:32 -0800
Message-ID: <200802082020.m18KKD1B011146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163AbYBHU3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     use __u32 in linux/reiserfs_fs.h
has been removed from the -mm tree.  Its filename was
     use-__u32-in-linux-reiserfs_fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use __u32 in linux/reiserfs_fs.h
From: Mike Frysinger <vapier@gentoo.org>

Since this header is exported to userspace and all the other types in the
header have been scrubbed, this brings the last straggler in line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/reiserfs_fs.h~use-__u32-in-linux-reiserfs_fsh include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~use-__u32-in-linux-reiserfs_fsh
+++ a/include/linux/reiserfs_fs.h
@@ -287,7 +287,7 @@ static inline struct reiserfs_sb_info *R
 
 /* Don't trust REISERFS_SB(sb)->s_bmap_nr, it's a u16
  * which overflows on large file systems. */
-static inline u32 reiserfs_bmap_count(struct super_block *sb)
+static inline __u32 reiserfs_bmap_count(struct super_block *sb)
 {
 	return (SB_BLOCK_COUNT(sb) - 1) / (sb->s_blocksize * 8) + 1;
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
