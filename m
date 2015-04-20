From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-bgl_lock_ptr.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:43 -0700
Message-ID: <55355113.ZwvFJmCnG5BqXEzo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbDTTMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use bgl_lock_ptr()
has been removed from the -mm tree.  Its filename was
     nilfs2-use-bgl_lock_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use bgl_lock_ptr()

Simplify nilfs_mdt_bgl_lock() by utilizing bgl_lock_ptr() helper in
<linux/blockgroup_lock.h>.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/mdt.h~nilfs2-use-bgl_lock_ptr fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-use-bgl_lock_ptr
+++ a/fs/nilfs2/mdt.h
@@ -111,7 +111,10 @@ static inline __u64 nilfs_mdt_cno(struct
 	return ((struct the_nilfs *)inode->i_sb->s_fs_info)->ns_cno;
 }
 
-#define nilfs_mdt_bgl_lock(inode, bg) \
-	(&NILFS_MDT(inode)->mi_bgl->locks[(bg) & (NR_BG_LOCKS-1)].lock)
+static inline spinlock_t *
+nilfs_mdt_bgl_lock(struct inode *inode, unsigned int block_group)
+{
+	return bgl_lock_ptr(NILFS_MDT(inode)->mi_bgl, block_group);
+}
 
 #endif /* _NILFS_MDT_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

