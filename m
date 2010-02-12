From: akpm@linux-foundation.org
Subject: [withdrawn] mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:01:16 -0800
Message-ID: <201002121901.o1CJ1GTH021008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0BLTCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:02:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maximlevitsky@gmail.com, dwmw2@infradead.org, ext-jorg.2.schummer@nokia.com, linux-mmc@vger.kernel.org, nico@fluxnic.net, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: fix hang if card was removed during suspend and unsafe resume was enabled
has been removed from the -mm tree.  Its filename was
     mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: fix hang if card was removed during suspend and unsafe resume was enabled
From: Maxim Levitsky <maximlevitsky@gmail.com>

Presently the following operations lead to a hang:

-> Have a kernel with CONFIG_MMC_UNSAFE_RESUME
-> Insert MMC/SD card
-> Suspend/hibernate the system
-> While system is hibernated/suspended pull the card off
-> Resume the system
-> Hang

[<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
[<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
[<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
[<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
[<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
[<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
[<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
[<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
[<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
[<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
[<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
[<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
[<ffffffff811391de>] fsync_bdev+0x2e/0x60
[<ffffffff812226be>] invalidate_partition+0x2e/0x50
[<ffffffff8116b92f>] del_gendisk+0x3f/0x140
[<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
[<ffffffff81338977>] mmc_bus_remove+0x17/0x20
[<ffffffff812ce746>] __device_release_driver+0x66/0xc0
[<ffffffff812ce89d>] device_release_driver+0x2d/0x40
[<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
[<ffffffff812cb46f>] device_del+0x12f/0x1a0
[<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
[<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
[<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
[<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
[<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]

because del_gendisk() tries to perform writeout when some devices are in
the suspended state.

If CONFIG_MMC_UNSAFE_RESUME is set, mmc core allows the user to
suspend/resume the card normally assuming he won't change the card or
modify it in another system.  The former case is actually handled quite
well.

If CONFIG_MMC_UNSAFE_RESUME isn't set, it removes the card during suspend,
and I now think (and will test) that this will still hang the system this
time on suspend.


Fix that by removing the code that did that in mmc_resume_host.  It is
possible because card detection logic will kick it later and remove the
card.

Also make mtd workqueue freezeable, so it won't attempt to add/remove the
card while userspace is frozen.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled
+++ a/drivers/mmc/core/core.c
@@ -1257,7 +1257,6 @@ int mmc_suspend_host(struct mmc_host *ho
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
-	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
@@ -1300,15 +1299,11 @@ int mmc_resume_host(struct mmc_host *hos
 		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
+
 		if (err) {
 			printk(KERN_WARNING "%s: error %d during resume "
 					    "(card was removed?)\n",
 					    mmc_hostname(host), err);
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
 			/* no need to bother upper layers */
 			err = 0;
 		}
@@ -1332,7 +1327,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_singlethread_workqueue("kmmcd");
+	workqueue = create_freezeable_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch
linux-next.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
ricoh_mmc-port-from-driver-to-pci-quirk.patch
ricoh_mmc-port-from-driver-to-pci-quirk-update.patch

