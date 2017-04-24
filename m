From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Mon, 24 Apr 2017 15:40:54 -0700
Message-ID: <20170424224054.3HzU10xJ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966825AbdDXWk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2017 18:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/buffer.c~linux-next-rejects fs/buffer.c
diff -puN fs/dax.c~linux-next-rejects fs/dax.c
--- a/fs/dax.c~linux-next-rejects
+++ a/fs/dax.c
@@ -824,8 +824,8 @@ static int dax_writeback_one(struct bloc
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
 	trace_dax_writeback_one(mapping->host, index, dax.size >> PAGE_SHIFT);
- unmap:
-	dax_unmap_atomic(bdev, &dax);
+ dax_unlock:
+	dax_read_unlock(id);
 	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
@@ -883,9 +883,10 @@ int dax_writeback_mapping_range(struct a
 				break;
 			}
 
-			ret = dax_writeback_one(bdev, mapping, indices[i],
-					pvec.pages[i]);
-			if (ret < 0)
+			ret = dax_writeback_one(bdev, dax_dev, mapping,
+					indices[i], pvec.pages[i]);
+			if (ret < 0) {
+				put_dax(dax_dev);
 				goto out;
 		}
 	}
diff -puN fs/internal.h~linux-next-rejects fs/internal.h
diff -puN fs/iomap.c~linux-next-rejects fs/iomap.c
diff -puN tools/testing/selftests/vm/run_vmtests~linux-next-rejects tools/testing/selftests/vm/run_vmtests
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

