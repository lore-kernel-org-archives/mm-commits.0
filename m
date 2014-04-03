From: akpm@linux-foundation.org
Subject: [folded-merged] befs-logging-clean-up-fix.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:12:33 -0700
Message-ID: <533dcec1.gFBG6EeW61zxegZk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaDCVMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fengguang.wu@gmail.com, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] befs-logging-clean-up-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,fengguang.wu@gmail.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:12:33 -0700


The patch titled
     Subject: befs-logging-clean-up-fix
has been removed from the -mm tree.  Its filename was
     befs-logging-clean-up-fix.patch

This patch was dropped because it was folded into befs-logging-clean-up.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: befs-logging-clean-up-fix

fix printk warnings, reported by Fengguang

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/btree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/btree.c~befs-logging-clean-up-fix fs/befs/btree.c
--- a/fs/befs/btree.c~befs-logging-clean-up-fix
+++ a/fs/befs/btree.c
@@ -263,7 +263,7 @@ befs_btree_find(struct super_block *sb,
 	this_node = kmalloc(sizeof (befs_btree_node),
 						GFP_NOFS);
 	if (!this_node) {
-		befs_error(sb, "befs_btree_find() failed to allocate %u "
+		befs_error(sb, "befs_btree_find() failed to allocate %zu "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
 	}
@@ -437,7 +437,7 @@ befs_btree_read(struct super_block *sb,
 	}
 
 	if ((this_node = kmalloc(sizeof (befs_btree_node), GFP_NOFS)) == NULL) {
-		befs_error(sb, "befs_btree_read() failed to allocate %u "
+		befs_error(sb, "befs_btree_read() failed to allocate %zu "
 			   "bytes of memory", sizeof (befs_btree_node));
 		goto error;
 	}
@@ -498,7 +498,7 @@ befs_btree_read(struct super_block *sb,
 		   (int)keylen);
 
 	if (bufsize < keylen + 1) {
-		befs_error(sb, "%s keybuf too small (%u) "
+		befs_error(sb, "%s keybuf too small (%zu) "
 			   "for key of size %d", __func__, bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
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
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch

