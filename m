From: akpm@linux-foundation.org
Subject: [folded-merged]
 hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:13:55 -0700
Message-ID: <533dcf13.43l1KlQVVI8VO87e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaDCVN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sougata@tuxera.com, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, akpm@linux-foundation.org

Subject: [folded-merged] hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com,sougata@tuxera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:13:55 -0700


The patch titled
     Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch

This patch was dropped because it was folded into hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-fix-concurrent-acess-of-alloc_blocks-fix

take extents_lock before taking a copy of ->alloc_blocks

Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sougata Santra <sougata@tuxera.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks-fix
+++ a/fs/hfsplus/extents.c
@@ -556,11 +556,13 @@ void hfsplus_file_truncate(struct inode
 
 	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
 			HFSPLUS_SB(sb)->alloc_blksz_shift;
+
+	mutex_lock(&hip->extents_lock);
+
 	alloc_cnt = hip->alloc_blocks;
 	if (blk_cnt == alloc_cnt)
-		goto out;
+		goto out_unlock;
 
-	mutex_lock(&hip->extents_lock);
 	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
 	if (res) {
 		mutex_unlock(&hip->extents_lock);
@@ -594,6 +596,7 @@ void hfsplus_file_truncate(struct inode
 	hfs_find_exit(&fd);
 
 	hip->alloc_blocks = blk_cnt;
+out_unlock:
 	mutex_unlock(&hip->extents_lock);
 out:
 	hip->phys_size = inode->i_size;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-process_vm_accessc-mark-function-as-static.patch
drop_caches-add-some-documentation-and-info-message.patch
sys_sysfs-add-config_sysfs_syscall.patch
kernel-groupsc-remove-return-value-of-set_groups.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
rtc-fixed-potential-race-condition.patch
befs-logging-clean-up.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

