From: akpm@linux-foundation.org
Subject: [merged] zram-avoid-null-access-when-fail-to-alloc-meta.patch
 removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:46 -0800
Message-ID: <5318dc9a.Gsf136BwaKShXCt3%akpm__22035.5557780296$1394138294$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaCFUhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-avoid-null-access-when-fail-to-alloc-meta.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:46 -0800


The patch titled
     Subject: zram: avoid null access when fail to alloc meta
has been removed from the -mm tree.  Its filename was
     zram-avoid-null-access-when-fail-to-alloc-meta.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: avoid null access when fail to alloc meta

zram_meta_alloc could fail so caller should check it.  Otherwise, your
system will hang.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-avoid-null-access-when-fail-to-alloc-meta drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-avoid-null-access-when-fail-to-alloc-meta
+++ a/drivers/block/zram/zram_drv.c
@@ -612,6 +612,8 @@ static ssize_t disksize_store(struct dev
 
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (zram->init_done) {
 		up_write(&zram->init_lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
mm-zswap-support-multiple-swap-devices.patch
debugging-keep-track-of-page-owners.patch

