From: akpm@linux-foundation.org
Subject: [wrecked] fs-block_devc-set_blocksize-use-mapping_mapped.patch removed from -mm tree
Date: Wed, 10 Oct 2012 13:09:30 -0700
Message-ID: <20121010200931.BB57B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36847 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2JJUJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:09:34 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so68839wib.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:09:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mpatocka@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-set_blocksize-use-mapping_mapped.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()

... instead of open-coding it.

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped
+++ a/fs/block_dev.c
@@ -27,7 +27,6 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
-#include <linux/rbtree.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -133,8 +132,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping = bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
-	    !list_empty(&mapping->i_mmap_nonlinear)) {
+	if (mapping_mapped(mapping)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-powerpc-platforms-pseries-hotplug-memoryc-fix-section-handling-code.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

