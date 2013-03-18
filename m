From: akpm@linux-foundation.org
Subject: [folded-merged] block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:36:25 -0700
Message-ID: <20130318203625.A3C815A46AA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59805 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3CRUg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:36:26 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so614373ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:36:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix build error due to bio_endio_batch
has been removed from the -mm tree.  Its filename was
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into block-aio-batch-completion-for-bios-kiocbs.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Fix build error due to bio_endio_batch

This patch fixes build error of recent mmotm.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix include/linux/bio.h
--- a/include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix
+++ a/include/linux/bio.h
@@ -69,6 +69,8 @@
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 
+void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
+
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
@@ -542,8 +544,6 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
-void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
-
 static inline void batch_complete_init(struct batch_complete *batch)
 {
 	bio_list_init(&batch->bio);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
frontswap-get-rid-of-swap_lock-dependency.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

