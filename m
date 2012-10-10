From: akpm@linux-foundation.org
Subject: [wrecked] prio_tree-remove-fix.patch removed from -mm tree
Date: Wed, 10 Oct 2012 13:09:16 -0700
Message-ID: <20121010200917.379B820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:58162 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2JJUJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:09:20 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so68193lah.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:09:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: fix fs/block_dev.c for removal of prio_tree
has been removed from the -mm tree.  Its filename was
     prio_tree-remove-fix.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: prio_tree: fix fs/block_dev.c for removal of prio_tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~prio_tree-remove-fix fs/block_dev.c
--- a/fs/block_dev.c~prio_tree-remove-fix
+++ a/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/rbtree.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -132,7 +133,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping = bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap) ||
+	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
 	    !list_empty(&mapping->i_mmap_nonlinear)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code.patch
linux-next.patch
fs-block_devc-set_blocksize-use-mapping_mapped.patch
kernel-forkc-export-kernel_thread-to-modules.patch

