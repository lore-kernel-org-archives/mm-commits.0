From: akpm@linux-foundation.org
Subject: - drivers-block-cpqarraycciss-kill-unused-var.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:46:06 -0700
Message-ID: <200710162046.l9GKk6SF016333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965417AbXJPVDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jens.axboe@oracle.com, jgarzik@redhat.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/cpqarray,cciss: kill unused var
has been removed from the -mm tree.  Its filename was
     drivers-block-cpqarraycciss-kill-unused-var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/cpqarray,cciss: kill unused var
From: Jeff Garzik <jeff@garzik.org>

The recent bio work and subsequent fixups created unused variables.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c    |    1 -
 drivers/block/cpqarray.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-cpqarraycciss-kill-unused-var drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-cpqarraycciss-kill-unused-var
+++ a/drivers/block/cciss.c
@@ -1191,7 +1191,6 @@ static inline void complete_buffers(stru
 {
 	while (bio) {
 		struct bio *xbh = bio->bi_next;
-		int nr_sectors = bio_sectors(bio);
 
 		bio->bi_next = NULL;
 		bio_endio(bio, status ? 0 : -EIO);
diff -puN drivers/block/cpqarray.c~drivers-block-cpqarraycciss-kill-unused-var drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~drivers-block-cpqarraycciss-kill-unused-var
+++ a/drivers/block/cpqarray.c
@@ -981,9 +981,8 @@ static void start_io(ctlr_info_t *h)
 static inline void complete_buffers(struct bio *bio, int ok)
 {
 	struct bio *xbh;
-	while(bio) {
-		int nr_sectors = bio_sectors(bio);
 
+	while (bio) {
 		xbh = bio->bi_next;
 		bio->bi_next = NULL;
 		
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-jg-misc.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
tokenring-3c359c-fixed-array-index-problem.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
unify-dma_bit_mask-definitions-v31.patch
drivers-char-ip2-fix-used-uninitd-bug.patch
drivers-char-ip2-fix-used-uninitd-bug-checkpatch-fixes.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
s2io-rename-bit-macro.patch
define-global-bit-macro.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
