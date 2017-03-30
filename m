From: akpm@linux-foundation.org
Subject: + fs-affs-free-affs_sb_info-in-put_super.patch added to -mm tree
Date: Thu, 30 Mar 2017 14:19:51 -0700
Message-ID: <58dd7677.hhR+DYSa7yJcnC/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754625AbdC3VTx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: free affs_sb_info in put_super()
has been added to the -mm tree.  Its filename is
     fs-affs-free-affs_sb_info-in-put_super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-free-affs_sb_info-in-put_super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-free-affs_sb_info-in-put_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
