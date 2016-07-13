From: akpm@linux-foundation.org
Subject: [folded-merged] nvme-dont-allocate-unused-nvme_major-fix.patch
 removed from -mm tree
Date: Wed, 13 Jul 2016 11:02:29 -0700
Message-ID: <57868235.jq0tDPDlRuqCemvl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcGMSDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 14:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, gregkh@linuxfoundation.org, keith.busch@intel.com, maximlevitsky@gmail.com, neilb@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nvme-dont-allocate-unused-nvme_major-fix
has been removed from the -mm tree.  Its filename was
     nvme-dont-allocate-unused-nvme_major-fix.patch

This patch was dropped because it was folded into nvme-dont-allocate-unused-nvme_major.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nvme-dont-allocate-unused-nvme_major-fix

one unregister_blkdev() was missed

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/core.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major-fix drivers/nvme/host/core.c
--- a/drivers/nvme/host/core.c~nvme-dont-allocate-unused-nvme_major-fix
+++ a/drivers/nvme/host/core.c
@@ -1867,7 +1867,6 @@ void nvme_core_exit(void)
 {
 	class_destroy(nvme_class);
 	__unregister_chrdev(nvme_char_major, 0, NVME_MINORS, "nvme");
-	unregister_blkdev(nvme_major, "nvme");
 }
 
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
nvme-dont-allocate-unused-nvme_major.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

