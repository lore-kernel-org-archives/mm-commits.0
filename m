From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 20 Jan 2017 14:03:34 -0800
Message-ID: <58828936.Tm7P8NhQ+y9YMDHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbdATWD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 17:03:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/dra72-evm-revc.dts                 |    3 
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts |    7 -
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi          |   25 ------
 block/blk-mq.c                                       |   37 ----------
 drivers/block/nbd.c                                  |    5 -
 drivers/spi/spi-dw.c                                 |    6 -
 6 files changed, 83 deletions(-)

diff -puN arch/arm/boot/dts/dra72-evm-revc.dts~linux-next-git-rejects arch/arm/boot/dts/dra72-evm-revc.dts
--- a/arch/arm/boot/dts/dra72-evm-revc.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/dra72-evm-revc.dts
@@ -78,10 +78,7 @@
 		ti,tx-internal-delay = <DP83867_RGMIIDCTL_250_PS>;
 		ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_8_B_NIB>;
 		ti,min-output-impedance;
-<<<<<<< HEAD
-=======
 		interrupt-parent = <&gpio6>;
 		interrupts = <16 IRQ_TYPE_EDGE_FALLING>;
->>>>>>> linux-next/akpm-base
 	};
 };
diff -puN arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts~linux-next-git-rejects arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts
@@ -57,15 +57,8 @@
 
 &pio {
 	mmc2_pins_nrst: mmc2-rst-pin {
-<<<<<<< HEAD
-		allwinner,pins = "PC16";
-		allwinner,function = "gpio_out";
-		allwinner,drive = <SUN4I_PINCTRL_10_MA>;
-		allwinner,pull = <SUN4I_PINCTRL_NO_PULL>;
-=======
 		pins = "PC16";
 		function = "gpio_out";
->>>>>>> linux-next/akpm-base
 	};
 };
 
diff -puN arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi~linux-next-git-rejects arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -50,31 +50,6 @@
 / {
 	compatible = "amlogic,meson-gxbb";
 
-<<<<<<< HEAD
-	scpi {
-		compatible = "amlogic,meson-gxbb-scpi", "arm,scpi-pre-1.0";
-		mboxes = <&mailbox 1 &mailbox 2>;
-		shmem = <&cpu_scp_lpri &cpu_scp_hpri>;
-
-		scpi_clocks: clocks {
-			compatible = "arm,scpi-clocks";
-
-			scpi_dvfs: scpi_clocks@0 {
-				compatible = "arm,scpi-dvfs-clocks";
-				#clock-cells = <1>;
-				clock-indices = <0>;
-				clock-output-names = "vcpu";
-			};
-		};
-
-		scpi_sensors: sensors {
-			compatible = "arm,scpi-sensors";
-			#thermal-sensor-cells = <1>;
-		};
-	};
-
-=======
->>>>>>> linux-next/akpm-base
 	soc {
 		usb0_phy: phy@c0000000 {
 			compatible = "amlogic,meson-gxbb-usb2-phy";
diff -puN block/blk-mq.c~linux-next-git-rejects block/blk-mq.c
--- a/block/blk-mq.c~linux-next-git-rejects
+++ a/block/blk-mq.c
@@ -992,43 +992,6 @@ bool blk_mq_dispatch_rq_list(struct blk_
 	return ret != BLK_MQ_RQ_QUEUE_BUSY;
 }
 
-<<<<<<< HEAD
-/*
- * Run this hardware queue, pulling any software queues mapped to it in.
- * Note that this function currently has various problems around ordering
- * of IO. In particular, we'd like FIFO behaviour on handling existing
- * items on the hctx->dispatch list. Ignore that for now.
- */
-static void blk_mq_process_rq_list(struct blk_mq_hw_ctx *hctx)
-{
-	LIST_HEAD(rq_list);
-
-	if (unlikely(blk_mq_hctx_stopped(hctx)))
-		return;
-
-	hctx->run++;
-
-	/*
-	 * Touch any software queue that has pending entries.
-	 */
-	flush_busy_ctxs(hctx, &rq_list);
-
-	/*
-	 * If we have previous entries on our dispatch list, grab them
-	 * and stuff them at the front for more fair dispatch.
-	 */
-	if (!list_empty_careful(&hctx->dispatch)) {
-		spin_lock(&hctx->lock);
-		if (!list_empty(&hctx->dispatch))
-			list_splice_init(&hctx->dispatch, &rq_list);
-		spin_unlock(&hctx->lock);
-	}
-
-	blk_mq_dispatch_rq_list(hctx, &rq_list);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	int srcu_idx;
diff -puN drivers/block/nbd.c~linux-next-git-rejects drivers/block/nbd.c
--- a/drivers/block/nbd.c~linux-next-git-rejects
+++ a/drivers/block/nbd.c
@@ -256,15 +256,10 @@ static int sock_xmit(struct nbd_device *
 static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 {
 	struct request *req = blk_mq_rq_from_pdu(cmd);
-<<<<<<< HEAD
-	int result;
-	struct nbd_request request;
-=======
 	int result, flags;
 	struct nbd_request request = {.magic = htonl(NBD_REQUEST_MAGIC)};
 	struct kvec iov = {.iov_base = &request, .iov_len = sizeof(request)};
 	struct iov_iter from;
->>>>>>> linux-next/akpm-base
 	unsigned long size = blk_rq_bytes(req);
 	struct bio *bio;
 	u32 type;
diff -puN drivers/spi/spi-dw.c~linux-next-git-rejects drivers/spi/spi-dw.c
--- a/drivers/spi/spi-dw.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw.c
@@ -107,15 +107,9 @@ static const struct file_operations dw_s
 
 static int dw_spi_debugfs_init(struct dw_spi *dws)
 {
-<<<<<<< HEAD
-	char name[128];
-
-	snprintf(name, 128, "dw_spi-%s", dev_name(&dws->master->dev));
-=======
 	char name[32];
 
 	snprintf(name, 32, "dw_spi%d", dws->master->bus_num);
->>>>>>> linux-next/akpm-base
 	dws->debugfs = debugfs_create_dir(name, NULL);
 	if (!dws->debugfs)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

