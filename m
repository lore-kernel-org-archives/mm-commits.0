From: akpm@linux-foundation.org
Subject: [nacked] fs-affs-free-affs_sb_info-in-put_super.patch removed
 from -mm tree
Date: Thu, 30 Mar 2017 14:55:01 -0700
Message-ID: <58dd7eb5.5E8sB9l2Jp9ZimVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755096AbdC3VzD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: free affs_sb_info in put_super()
has been removed from the -mm tree.  Its filename was
     fs-affs-free-affs_sb_info-in-put_super.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: free affs_sb_info in put_super()

kill_block_super() calls generic_shutdown_super() calling FS
->put_super() where we generally free superblock specific information.

This removes unneeded affs_kill_sb()

sbi is automatically reserved in fill_super() so there is no
need to test it.

Link: http://lkml.kernel.org/r/20170330194215.26379-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN fs/affs/super.c~fs-affs-free-affs_sb_info-in-put_super fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-free-affs_sb_info-in-put_super
+++ a/fs/affs/super.c
@@ -46,9 +46,14 @@ static void
 affs_put_super(struct super_block *sb)
 {
 	struct affs_sb_info *sbi = AFFS_SB(sb);
-	pr_debug("%s()\n", __func__);
 
+	pr_debug("%s()\n", __func__);
 	cancel_delayed_work_sync(&sbi->sb_work);
+	affs_free_bitmap(sb);
+	affs_brelse(sbi->s_root_bh);
+	kfree(sbi->s_prefix);
+	mutex_destroy(&sbi->s_bmlock);
+	kfree(sbi);
 }
 
 static int
@@ -604,24 +609,11 @@ static struct dentry *affs_mount(struct
 	return mount_bdev(fs_type, flags, dev_name, data, affs_fill_super);
 }
 
-static void affs_kill_sb(struct super_block *sb)
-{
-	struct affs_sb_info *sbi = AFFS_SB(sb);
-	kill_block_super(sb);
-	if (sbi) {
-		affs_free_bitmap(sb);
-		affs_brelse(sbi->s_root_bh);
-		kfree(sbi->s_prefix);
-		mutex_destroy(&sbi->s_bmlock);
-		kfree(sbi);
-	}
-}
