From: akpm@linux-foundation.org
Subject: [merged] aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:12 -0800
Message-ID: <200912292133.nBTLXC85008691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZL2Vd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, ecashin@coraid.com, isloginov@gmail.com, jens.axboe@oracle.com, mingo@elte.hu, phorton@bitbox.co.uk, mm-commits@vger.kernel.org


The patch titled
     aoe: switch to the new bio_flush_dcache_pages() interface
has been removed from the -mm tree.  Its filename was
     aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: switch to the new bio_flush_dcache_pages() interface
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Horton <phorton@bitbox.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-switch-to-the-new-bio_flush_dcache_pages-interface drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-switch-to-the-new-bio_flush_dcache_pages-interface
+++ a/drivers/block/aoe/aoecmd.c
@@ -735,21 +735,6 @@ diskstats(struct gendisk *disk, struct b
 	part_stat_unlock();
 }
 
-/*
- * Ensure we don't create aliases in VI caches
- */
-static inline void
-killalias(struct bio *bio)
-{
-	struct bio_vec *bv;
-	int i;
-
-	if (bio_data_dir(bio) == READ)
-		__bio_for_each_segment(bv, bio, i, 0) {
-			flush_dcache_page(bv->bv_page);
-		}
-}
-
 void
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
@@ -871,7 +856,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		if (buf->flags & BUFFL_FAIL)
 			bio_endio(buf->bio, -EIO);
 		else {
-			killalias(buf->bio);
+			bio_flush_dcache_pages(buf->bio);
 			bio_endio(buf->bio, 0);
 		}
 		mempool_free(buf, d->bufpool);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
hid-logitech-g13-driver-002-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

