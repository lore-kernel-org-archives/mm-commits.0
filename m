From: akpm@linux-foundation.org
Subject: + fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch added to -mm tree
Date: Wed, 26 Sep 2012 13:18:43 -0700
Message-ID: <20120926201843.940271E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47217 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZUSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:18:44 -0400
Received: by yenr11 with SMTP id r11so121052yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:18:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com, fengguang.wu@intel.com


The patch titled
     Subject: fs/fs-writeback.c: remove unneccesary parameter of __writeback_single_inode()
has been added to the -mm tree.  Its filename is
     fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/fs-writeback.c: remove unneccesary parameter of __writeback_single_inode()

The parameter 'wb' is never used in this function.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/fs-writeback.c~fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode
+++ a/fs/fs-writeback.c
@@ -439,8 +439,7 @@ static void requeue_inode(struct inode *
  * setting I_SYNC flag and calling inode_sync_complete() to clear it.
  */
 static int
-__writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-			 struct writeback_control *wbc)
+__writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	long nr_to_write = wbc->nr_to_write;
@@ -527,7 +526,7 @@ writeback_single_inode(struct inode *ino
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
 
-	ret = __writeback_single_inode(inode, wb, wbc);
+	ret = __writeback_single_inode(inode, wbc);
 
 	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
@@ -670,7 +669,7 @@ static long writeback_sb_inodes(struct s
 		 * We use I_SYNC to pin the inode in memory. While it is set
 		 * evict_inode() will wait so the inode cannot be freed.
 		 */
-		__writeback_single_inode(inode, wb, &wbc);
+		__writeback_single_inode(inode, &wbc);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

fs-debugsfs-remove-unnecessary-inode-i_private-initialization.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
fs-fs-writebackc-remove-unneccesary-parameter-of-__writeback_single_inode.patch
proc-return-enomem-when-inode-allocation-failed.patch
proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

