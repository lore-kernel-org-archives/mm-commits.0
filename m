From: akpm@linux-foundation.org
Subject: + nilfs2-use-bgl_lock_ptr.patch added to -mm tree
Date: Mon, 16 Mar 2015 15:51:33 -0700
Message-ID: <55075e75.US627qOQ9tMrotJl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbbCPWve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 18:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use bgl_lock_ptr()
has been added to the -mm tree.  Its filename is
     nilfs2-use-bgl_lock_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-bgl_lock_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-bgl_lock_ptr.patch

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

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch

