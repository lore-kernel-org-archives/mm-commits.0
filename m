From: akpm@linux-foundation.org
Subject: [folded-merged]
 tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
 removed from -mm tree
Date: Thu, 14 Nov 2013 14:22:44 -0800
Message-ID: <52854d34.tHsc4UDrbV/G31YX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3KNWWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 17:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wsa@the-dreams.de, akpm@linux-foundation.org

Subject: [folded-merged] tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,wsa@the-dreams.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 14:22:44 -0800


The patch titled
     Subject: tree-wide-use-reinit_completion-instead-of-init_completion-fix
has been removed from the -mm tree.  Its filename was
     tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch

This patch was dropped because it was folded into tree-wide-use-reinit_completion-instead-of-init_completion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tree-wide-use-reinit_completion-instead-of-init_completion-fix

Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/mic/card/mic_virtio.c |    2 +-
 drivers/misc/mic/host/mic_boot.c   |    2 +-
 drivers/spi/spi.c                  |    2 +-
 sound/firewire/dice.c              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/mic/card/mic_virtio.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/misc/mic/card/mic_virtio.c
--- a/drivers/misc/mic/card/mic_virtio.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/misc/mic/card/mic_virtio.c
@@ -493,7 +493,7 @@ static int mic_remove_device(struct mic_
 			ioread8(&dc->config_change), ioread8(&d->type), mvdev);
 
 		status = ioread8(&d->status);
-		INIT_COMPLETION(mvdev->reset_done);
+		reinit_completion(&mvdev->reset_done);
 		unregister_virtio_device(&mvdev->vdev);
 		mic_free_card_irq(mvdev->virtio_cookie, mvdev);
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK)
diff -puN drivers/misc/mic/host/mic_boot.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/misc/mic/host/mic_boot.c
--- a/drivers/misc/mic/host/mic_boot.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/misc/mic/host/mic_boot.c
@@ -38,7 +38,7 @@ static void mic_reset(struct mic_device
 
 #define MIC_RESET_TO (45)
 
-	INIT_COMPLETION(mdev->reset_wait);
+	reinit_completion(&mdev->reset_wait);
 	mdev->ops->reset_fw_ready(mdev);
 	mdev->ops->reset(mdev);
 
diff -puN drivers/spi/spi.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/spi/spi.c
--- a/drivers/spi/spi.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/spi/spi.c
@@ -584,7 +584,7 @@ static int spi_transfer_one_message(stru
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		trace_spi_transfer_start(msg, xfer);
 
-		INIT_COMPLETION(master->xfer_completion);
+		reinit_completion(&master->xfer_completion);
 
 		ret = master->transfer_one(master, msg->spi, xfer);
 		if (ret < 0) {
diff -puN sound/firewire/dice.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix sound/firewire/dice.c
--- a/sound/firewire/dice.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/sound/firewire/dice.c
@@ -543,7 +543,7 @@ static int dice_change_rate(struct dice
 	__be32 value;
 	int err;
 
-	INIT_COMPLETION(dice->clock_accepted);
+	reinit_completion(&dice->clock_accepted);
 
 	value = cpu_to_be32(clock_rate | CLOCK_SOURCE_ARX1);
 	err = snd_fw_transaction(dice->unit, TCODE_WRITE_QUADLET_REQUEST,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
tree-wide-use-reinit_completion-instead-of-init_completion.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch

