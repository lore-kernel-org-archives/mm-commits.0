From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Fri, 10 Mar 2017 13:42:36 -0800
Message-ID: <58c31dcc.Ehm6DFfBsPF2XoFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbdCJVmh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "disble(d)" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "disble(d)" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  disble||disable
  disbled||disabled

I kept the TSL2563_INT_DISBLED in /drivers/iio/light/tsl2563.c
untouched.  The macro is not referenced at all, but this commit is
touching only comment blocks just in case.

Link: http://lkml.kernel.org/r/1481573103-11329-20-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst        |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c  |    2 +-
 arch/x86/kernel/ftrace.c                |    2 +-
 drivers/crypto/ux500/cryp/cryp.c        |    2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c  |    2 +-
 drivers/hv/channel.c                    |    2 +-
 drivers/isdn/hisax/st5481_b.c           |    2 +-
 drivers/mtd/spi-nor/spi-nor.c           |    2 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c     |    2 +-
 drivers/usb/gadget/legacy/inode.c       |    3 +--
 drivers/usb/host/xhci.c                 |    4 ++--
 include/linux/regulator/machine.h       |    2 +-
 kernel/cgroup/cgroup.c                  |    2 +-
 kernel/events/core.c                    |    2 +-
 scripts/spelling.txt                    |    2 ++
 sound/soc/amd/acp-pcm-dma.c             |    2 +-
 17 files changed, 19 insertions(+), 18 deletions(-)

diff -puN Documentation/dev-tools/kcov.rst~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances Documentation/dev-tools/kcov.rst
--- a/Documentation/dev-tools/kcov.rst~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/Documentation/dev-tools/kcov.rst
@@ -10,7 +10,7 @@ Note that kcov does not aim to collect a
 to collect more or less stable coverage that is function of syscall inputs.
 To achieve this goal it does not collect coverage in soft/hard interrupts
 and instrumentation of some inherently non-deterministic parts of kernel is
-disbled (e.g. scheduler, locking).
+disabled (e.g. scheduler, locking).
 
 Usage
 -----
diff -puN arch/cris/arch-v32/drivers/cryptocop.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -2086,7 +2086,7 @@ static void cryptocop_job_queue_close(vo
 		dma_in_cfg.en = regk_dma_no;
 		REG_WR(dma, IN_DMA_INST, rw_cfg, dma_in_cfg);
 
-		/* Disble the cryptocop. */
+		/* Disable the cryptocop. */
 		rw_cfg = REG_RD(strcop, regi_strcop, rw_cfg);
 		rw_cfg.en = 0;
 		REG_WR(strcop, regi_strcop, rw_cfg, rw_cfg);
diff -puN arch/x86/kernel/ftrace.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances arch/x86/kernel/ftrace.c
--- a/arch/x86/kernel/ftrace.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/arch/x86/kernel/ftrace.c
@@ -535,7 +535,7 @@ static void run_sync(void)
 {
 	int enable_irqs = irqs_disabled();
 
-	/* We may be called with interrupts disbled (on bootup). */
+	/* We may be called with interrupts disabled (on bootup). */
 	if (enable_irqs)
 		local_irq_enable();
 	on_each_cpu(do_sync_core, NULL, 1);
diff -puN drivers/crypto/ux500/cryp/cryp.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/crypto/ux500/cryp/cryp.c
--- a/drivers/crypto/ux500/cryp/cryp.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/crypto/ux500/cryp/cryp.c
@@ -82,7 +82,7 @@ void cryp_activity(struct cryp_device_da
 void cryp_flush_inoutfifo(struct cryp_device_data *device_data)
 {
 	/*
-	 * We always need to disble the hardware before trying to flush the
+	 * We always need to disable the hardware before trying to flush the
 	 * FIFO. This is something that isn't written in the design
 	 * specification, but we have been informed by the hardware designers
 	 * that this must be done.
diff -puN drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
@@ -788,7 +788,7 @@ static int sdma_v3_0_start(struct amdgpu
 		}
 	}
 
-	/* disble sdma engine before programing it */
+	/* disable sdma engine before programing it */
 	sdma_v3_0_ctx_switch_enable(adev, false);
 	sdma_v3_0_enable(adev, false);
 
diff -puN drivers/hv/channel.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/hv/channel.c
--- a/drivers/hv/channel.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/hv/channel.c
@@ -543,7 +543,7 @@ static int vmbus_close_internal(struct v
 	/*
 	 * In case a device driver's probe() fails (e.g.,
 	 * util_probe() -> vmbus_open() returns -ENOMEM) and the device is
-	 * rescinded later (e.g., we dynamically disble an Integrated Service
+	 * rescinded later (e.g., we dynamically disable an Integrated Service
 	 * in Hyper-V Manager), the driver's remove() invokes vmbus_close():
 	 * here we should skip most of the below cleanup work.
 	 */
diff -puN drivers/isdn/hisax/st5481_b.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/isdn/hisax/st5481_b.c
--- a/drivers/isdn/hisax/st5481_b.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/isdn/hisax/st5481_b.c
@@ -239,7 +239,7 @@ static void st5481B_mode(struct st5481_b
 			}
 		}
 	} else {
-		// Disble B channel interrupts
+		// Disable B channel interrupts
 		st5481_usb_device_ctrl_msg(adapter, FFMSK_B1+(bcs->channel * 2), 0, NULL, NULL);
 
 		// Disable B channel FIFOs
diff -puN drivers/mtd/spi-nor/spi-nor.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/mtd/spi-nor/spi-nor.c
--- a/drivers/mtd/spi-nor/spi-nor.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/mtd/spi-nor/spi-nor.c
@@ -186,7 +186,7 @@ static inline int write_enable(struct sp
 }
 
 /*
- * Send write disble instruction to the chip.
+ * Send write disable instruction to the chip.
  */
 static inline int write_disable(struct spi_nor *nor)
 {
diff -puN drivers/net/ethernet/qlogic/qlge/qlge.h~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/net/ethernet/qlogic/qlge/qlge.h
--- a/drivers/net/ethernet/qlogic/qlge/qlge.h~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/qlogic/qlge/qlge.h
@@ -1163,7 +1163,7 @@ struct ib_mac_iocb_rsp {
 	u8 opcode;		/* 0x20 */
 	u8 flags1;
 #define IB_MAC_IOCB_RSP_OI	0x01	/* Overide intr delay */
-#define IB_MAC_IOCB_RSP_I	0x02	/* Disble Intr Generation */
+#define IB_MAC_IOCB_RSP_I	0x02	/* Disable Intr Generation */
 #define IB_MAC_CSUM_ERR_MASK 0x1c	/* A mask to use for csum errs */
 #define IB_MAC_IOCB_RSP_TE	0x04	/* Checksum error */
 #define IB_MAC_IOCB_RSP_NU	0x08	/* No checksum rcvd */
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6278,7 +6278,7 @@ ahd_reset(struct ahd_softc *ahd, int rei
 		 * does not disable its parity logic prior to
 		 * the start of the reset.  This may cause a
 		 * parity error to be detected and thus a
-		 * spurious SERR or PERR assertion.  Disble
+		 * spurious SERR or PERR assertion.  Disable
 		 * PERR and SERR responses during the CHIPRST.
 		 */
 		mod_cmd = cmd & ~(PCIM_CMD_PERRESPEN|PCIM_CMD_SERRESPEN);
diff -puN drivers/usb/gadget/legacy/inode.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/usb/gadget/legacy/inode.c
--- a/drivers/usb/gadget/legacy/inode.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -84,8 +84,7 @@ static int ep_open(struct inode *, struc
 
 /* /dev/gadget/$CHIP represents ep0 and the whole device */
 enum ep0_state {
-	/* DISBLED is the initial state.
-	 */
+	/* DISABLED is the initial state. */
 	STATE_DEV_DISABLED = 0,
 
 	/* Only one open() of /dev/gadget/$CHIP; only one file tracks
diff -puN drivers/usb/host/xhci.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances drivers/usb/host/xhci.c
--- a/drivers/usb/host/xhci.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/drivers/usb/host/xhci.c
@@ -868,7 +868,7 @@ static void xhci_disable_port_wake_on_bi
 
 	spin_lock_irqsave(&xhci->lock, flags);
 
-	/* disble usb3 ports Wake bits*/
+	/* disable usb3 ports Wake bits */
 	port_index = xhci->num_usb3_ports;
 	port_array = xhci->usb3_ports;
 	while (port_index--) {
@@ -879,7 +879,7 @@ static void xhci_disable_port_wake_on_bi
 			writel(t2, port_array[port_index]);
 	}
 
-	/* disble usb2 ports Wake bits*/
+	/* disable usb2 ports Wake bits */
 	port_index = xhci->num_usb2_ports;
 	port_array = xhci->usb2_ports;
 	while (port_index--) {
diff -puN include/linux/regulator/machine.h~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances include/linux/regulator/machine.h
--- a/include/linux/regulator/machine.h~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/include/linux/regulator/machine.h
@@ -65,7 +65,7 @@ struct regulator_state {
 	int uV;	/* suspend voltage */
 	unsigned int mode; /* suspend regulator operating mode */
 	int enabled; /* is regulator enabled in this suspend state */
-	int disabled; /* is the regulator disbled in this suspend state */
+	int disabled; /* is the regulator disabled in this suspend state */
 };
 
 /**
diff -puN kernel/cgroup/cgroup.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances kernel/cgroup/cgroup.c
--- a/kernel/cgroup/cgroup.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/kernel/cgroup/cgroup.c
@@ -2669,7 +2669,7 @@ static bool css_visible(struct cgroup_su
  *
  * Returns 0 on success, -errno on failure.  On failure, csses which have
  * been processed already aren't cleaned up.  The caller is responsible for
- * cleaning up with cgroup_apply_control_disble().
+ * cleaning up with cgroup_apply_control_disable().
  */
 static int cgroup_apply_control_enable(struct cgroup *cgrp)
 {
diff -puN kernel/events/core.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances kernel/events/core.c
--- a/kernel/events/core.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/kernel/events/core.c
@@ -998,7 +998,7 @@ list_update_cgroup_event(struct perf_eve
  */
 #define PERF_CPU_HRTIMER (1000 / HZ)
 /*
- * function must be called with interrupts disbled
+ * function must be called with interrupts disabled
  */
 static enum hrtimer_restart perf_mux_hrtimer_handler(struct hrtimer *hr)
 {
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -372,6 +372,8 @@ disassocation||disassociation
 disapear||disappear
 disapeared||disappeared
 disappared||disappeared
+disble||disable
+disbled||disabled
 disconnet||disconnect
 discontinous||discontinuous
 dispertion||dispersion
diff -puN sound/soc/amd/acp-pcm-dma.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances sound/soc/amd/acp-pcm-dma.c
--- a/sound/soc/amd/acp-pcm-dma.c~scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances
+++ a/sound/soc/amd/acp-pcm-dma.c
@@ -89,7 +89,7 @@ static void acp_reg_write(u32 val, void
 	writel(val, acp_mmio + (reg * 4));
 }
 
-/* Configure a given dma channel parameters - enable/disble,
+/* Configure a given dma channel parameters - enable/disable,
  * number of descriptors, priority
  */
 static void config_acp_dma_channel(void __iomem *acp_mmio, u8 ch_num,
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch

