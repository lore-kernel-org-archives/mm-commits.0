From: akpm@linux-foundation.org
Subject: [folded-merged]
 nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch removed from -mm
 tree
Date: Wed, 02 Aug 2017 15:28:40 -0700
Message-ID: <59825218.HsKZ4GddkejImZPn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdHBW2k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 18:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dan.j.williams@intel.com, hch@infradead.org, jthumshirn@suse.de, toshi.kani@hpe.com, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix
has been removed from the -mm tree.  Its filename was
     nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch

This patch was dropped because it was folded into nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/nd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/nvdimm/nd.h~nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix drivers/nvdimm/nd.h
--- a/drivers/nvdimm/nd.h~nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix
+++ a/drivers/nvdimm/nd.h
@@ -393,7 +393,7 @@ static inline bool nd_iostat_start(struc
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 
 	if (!blk_queue_io_stat(disk->queue)) {
-		*start = 0;
+		*start = 0;	/* Suppress bogus warning */
 		return false;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
add-testcases-for-memset16-32-64-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

