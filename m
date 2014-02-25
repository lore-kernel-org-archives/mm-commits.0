From: akpm@linux-foundation.org
Subject: + zram-avoid-null-access-when-fail-to-alloc-meta.patch added to
 -mm tree
Date: Tue, 25 Feb 2014 12:28:08 -0800
Message-ID: <530cfcd8.AYc8SvbqqSBM7yE5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaBYU2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:28:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, minchan@kernel.org

Subject: + zram-avoid-null-access-when-fail-to-alloc-meta.patch added to -mm tree
To: minchan@kernel.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:28:08 -0800


The patch titled
     Subject: zram: avoid null access when fail to alloc meta
has been added to the -mm tree.  Its filename is
     zram-avoid-null-access-when-fail-to-alloc-meta.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-avoid-null-access-when-fail-to-alloc-meta.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-avoid-null-access-when-fail-to-alloc-meta.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: avoid null access when fail to alloc meta

zram_meta_alloc could fail so caller should check it.  Otherwise, your
system will be hang.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-avoid-null-access-when-fail-to-alloc-meta drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-avoid-null-access-when-fail-to-alloc-meta
+++ a/drivers/block/zram/zram_drv.c
@@ -554,6 +554,8 @@ static ssize_t disksize_store(struct dev
 
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
zram-avoid-null-access-when-fail-to-alloc-meta.patch
zram-delete-zram_init_device-function.patch
debugging-keep-track-of-page-owners.patch

