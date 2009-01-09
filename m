From: akpm@linux-foundation.org
Subject: - filesystem-freeze-implement-generic-freeze-feature-fix.patch removed from -mm tree
Date: Fri, 09 Jan 2009 14:41:50 -0800
Message-ID: <200901092241.n09MfoHJ009553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZAIWlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 17:41:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, t-sato@yk.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     filesystem-freeze-implement-generic-freeze-feature-fix
has been removed from the -mm tree.  Its filename was
     filesystem-freeze-implement-generic-freeze-feature-fix.patch

This patch was dropped because it was folded into filesystem-freeze-implement-generic-freeze-feature.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: filesystem-freeze-implement-generic-freeze-feature-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix CONFIG_BLOCK=n.

Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature-fix
+++ a/include/linux/buffer_head.h
@@ -346,6 +346,15 @@ static inline int remove_inode_buffers(s
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
+static inline struct super_block *freeze_bdev(struct block_device *sb)
+{
+	return NULL;
+}
+
+static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+{
+	return 0;
+}
 
 #endif /* CONFIG_BLOCK */
 #endif /* _LINUX_BUFFER_HEAD_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

