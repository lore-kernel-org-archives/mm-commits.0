From: akpm@linux-foundation.org
Subject: + fs-block_devc-avoid-dereferencing-a-request_queue-after-last-close.patch added to -mm tree
Date: Fri, 09 Sep 2011 15:18:48 -0700
Message-ID: <201109092218.p89MImtm010037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759236Ab1IIWTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 18:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, fengguang.wu@intel.com, hch@lst.de, hughd@google.com, mlin@ss.pku.edu.cn, sitsofe@yahoo.com, stable@kernel.org


The patch titled
     fs/block_dev.c: avoid dereferencing a 'request_queue' after last close
has been added to the -mm tree.  Its filename is
     fs-block_devc-avoid-dereferencing-a-request_queue-after-last-close.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/block_dev.c: avoid dereferencing a 'request_queue' after last close
From: NeilBrown <neilb@suse.de>

On the last close of an 'md' device which as been stopped, the device is
destroyed and in particular the request_queue is freed.  The free is done
in a separate thread so it might happen a short time later.

__blkdev_put calls bdev_inode_switch_bdi *after* ->release has been
called.

Since commit f758eeabeb96f87 ("writeback: split inode_wb_list_lock into
bdi_writeback.list_lock") bdev_inode_switch_bdi() will dereference the 'old'
bdi, which lives inside a request_queue, to get a spin lock.  This causes
the last close on an md device to sometime take a spin_lock which lives in
freed memory - which results in an oops.

So move the called to bdev_inode_switch_bdi before the call to ->release.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-avoid-dereferencing-a-request_queue-after-last-close fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-avoid-dereferencing-a-request_queue-after-last-close
+++ a/fs/block_dev.c
@@ -1430,6 +1430,12 @@ static int __blkdev_put(struct block_dev
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
 	}
+	if (!bdev->bd_openers)
+		/* ->release can cause the old bdi to disappear,
+		 * so must switch it out first
+		 */
+		bdev_inode_switch_bdi(bdev->bd_inode,
+					&default_backing_dev_info);
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
 			ret = disk->fops->release(disk, mode);
@@ -1442,8 +1448,6 @@ static int __blkdev_put(struct block_dev
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev_inode_switch_bdi(bdev->bd_inode,
-					&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
fs-block_devc-avoid-dereferencing-a-request_queue-after-last-close.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch

