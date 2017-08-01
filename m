From: akpm@linux-foundation.org
Subject: + nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch added to -mm tree
Date: Tue, 01 Aug 2017 14:45:45 -0700
Message-ID: <5980f689.hsOfObi2R3UV6+Aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752718AbdHAVpq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 17:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dan.j.williams@intel.com, hch@infradead.org, jthumshirn@suse.de, toshi.kani@hpe.com, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix
has been added to the -mm tree.  Its filename is
     nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

