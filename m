From: akpm@linux-foundation.org
Subject: + dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch added to -mm tree
Date: Wed, 02 Jul 2008 03:40:34 -0700
Message-ID: <200807021040.m62AeYdQ012152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbYGBKk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 06:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Sivakumar.Subramani@neterion.com, Sreenivasa.Honnur@neterion.com, fujita.tomonori@lab.ntt.co.jp, jgarzik@pobox.com, ravinandan.arakali@neterion.com, sivakumar.subramani@neterion.com, sreenivasa.honnur@neterion.com, surjit.reang@neterion.com


The patch titled
     dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
has been added to the -mm tree.  Its filename is
     dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
From: Andrew Morton <akpm@linux-foundation.org>

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Sivakumar Subramani <sivakumar.subramani@neterion.com>
Cc: Sreenivasa Honnur <Sreenivasa.Honnur@neterion.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
Cc: Ravinandan Arakali <ravinandan.arakali@neterion.com>
Cc: Surjit Reang <surjit.reang@neterion.com>
Cc: Sivakumar Subramani <Sivakumar.Subramani@neterion.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |   44 ++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io drivers/net/s2io.c
--- a/drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io
+++ a/drivers/net/s2io.c
@@ -2536,7 +2536,7 @@ static void stop_nic(struct s2io_nic *ni
  *  SUCCESS on success or an appropriate -ve value on failure.
  */
 
-static int fill_rx_buffers(struct ring_info *ring)
+static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring)
 {
 	struct sk_buff *skb;
 	struct RxD_t *rxdp;
@@ -2625,7 +2625,8 @@ static int fill_rx_buffers(struct ring_i
 			rxdp1->Buffer0_ptr = pci_map_single
 			    (ring->pdev, skb->data, size - NET_IP_ALIGN,
 				PCI_DMA_FROMDEVICE);
-			if(pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp1->Buffer0_ptr))
 				goto pci_map_failed;
 
 			rxdp->Control_2 =
@@ -2664,7 +2665,8 @@ static int fill_rx_buffers(struct ring_i
 				pci_dma_sync_single_for_device(ring->pdev,
 				(dma_addr_t) rxdp3->Buffer0_ptr,
 				    BUF0_LEN, PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp3->Buffer0_ptr))
 				goto pci_map_failed;
 
 			rxdp->Control_2 = SET_BUFFER0_SIZE_3(BUF0_LEN);
@@ -2679,7 +2681,8 @@ static int fill_rx_buffers(struct ring_i
 				(ring->pdev, skb->data, ring->mtu + 4,
 						PCI_DMA_FROMDEVICE);
 
-				if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+				if (pci_dma_mapping_error(nic->pdev,
+							rxdp3->Buffer2_ptr))
 					goto pci_map_failed;
 
 				/* AK: check is wrong */
@@ -2689,7 +2692,8 @@ static int fill_rx_buffers(struct ring_i
 						ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
 
-				if (pci_dma_mapping_error(rxdp3->Buffer1_ptr)) {
+				if (pci_dma_mapping_error(nic->pdev,
+							rxdp3->Buffer1_ptr)) {
 					pci_unmap_single
 						(ring->pdev,
 						(dma_addr_t)(unsigned long)
@@ -2829,9 +2833,9 @@ static void free_rx_buffers(struct s2io_
 	}
 }
 
-static int s2io_chk_rx_buffers(struct ring_info *ring)
+static int s2io_chk_rx_buffers(struct s2io_nic *nic, struct ring_info *ring)
 {
-	if (fill_rx_buffers(ring) == -ENOMEM) {
+	if (fill_rx_buffers(nic, ring) == -ENOMEM) {
 		DBG_PRINT(INFO_DBG, "%s:Out of memory", ring->dev->name);
 		DBG_PRINT(INFO_DBG, " in Rx Intr!!\n");
 	}
@@ -2871,7 +2875,7 @@ static int s2io_poll_msix(struct napi_st
 		return 0;
 
 	pkts_processed = rx_intr_handler(ring, budget);
-	s2io_chk_rx_buffers(ring);
+	s2io_chk_rx_buffers(nic, ring);
 
 	if (pkts_processed < budget_org) {
 		netif_rx_complete(dev, napi);
@@ -2905,7 +2909,7 @@ static int s2io_poll_inta(struct napi_st
 	for (i = 0; i < config->rx_ring_num; i++) {
 		ring = &mac_control->rings[i];
 		ring_pkts_processed = rx_intr_handler(ring, budget);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(nic, ring);
 		pkts_processed += ring_pkts_processed;
 		budget -= ring_pkts_processed;
 		if (budget <= 0)
@@ -2962,7 +2966,7 @@ static void s2io_netpoll(struct net_devi
 		rx_intr_handler(&mac_control->rings[i], 0);
 
 	for (i = 0; i < config->rx_ring_num; i++) {
-		if (fill_rx_buffers(&mac_control->rings[i]) == -ENOMEM) {
+		if (fill_rx_buffers(nic, &mac_control->rings[i]) == -ENOMEM) {
 			DBG_PRINT(INFO_DBG, "%s:Out of memory", dev->name);
 			DBG_PRINT(INFO_DBG, " in Rx Netpoll!!\n");
 			break;
@@ -4261,14 +4265,14 @@ static int s2io_xmit(struct sk_buff *skb
 		txdp->Buffer_Pointer = pci_map_single(sp->pdev,
 					fifo->ufo_in_band_v,
 					sizeof(u64), PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+		if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 			goto pci_map_failed;
 		txdp++;
 	}
 
 	txdp->Buffer_Pointer = pci_map_single
 	    (sp->pdev, skb->data, frg_len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+	if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 		goto pci_map_failed;
 
 	txdp->Host_Control = (unsigned long) skb;
@@ -4371,7 +4375,7 @@ static irqreturn_t s2io_msix_ring_handle
 		netif_rx_schedule(dev, &ring->napi);
 	} else {
 		rx_intr_handler(ring, 0);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(sp, ring);
 	}
 
 	return IRQ_HANDLED;
@@ -4846,7 +4850,7 @@ static irqreturn_t s2io_isr(int irq, voi
 		 */
 		if (!config->napi) {
 			for (i = 0; i < config->rx_ring_num; i++)
-				s2io_chk_rx_buffers(&mac_control->rings[i]);
+				s2io_chk_rx_buffers(sp, &mac_control->rings[i]);
 		}
 		writeq(sp->general_int_mask, &bar0->general_int_mask);
 		readl(&bar0->general_int_status);
@@ -6879,7 +6883,7 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single( sp->pdev, (*skb)->data,
 					size - NET_IP_ALIGN,
 					PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp1->Buffer0_ptr))
 				goto memalloc_failed;
 			rxdp->Host_Control = (unsigned long) (*skb);
 		}
@@ -6906,12 +6910,13 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single(sp->pdev, (*skb)->data,
 					       dev->mtu + 4,
 					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp3->Buffer2_ptr))
 				goto memalloc_failed;
 			rxdp3->Buffer0_ptr = *temp0 =
 				pci_map_single( sp->pdev, ba->ba_0, BUF0_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer0_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer0_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer2_ptr,
 					dev->mtu + 4, PCI_DMA_FROMDEVICE);
@@ -6923,7 +6928,8 @@ static int set_rxd_buffer_pointer(struct
 			rxdp3->Buffer1_ptr = *temp1 =
 				pci_map_single(sp->pdev, ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer1_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer1_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer0_ptr,
 					BUF0_LEN, PCI_DMA_FROMDEVICE);
@@ -7204,7 +7210,7 @@ static int s2io_card_up(struct s2io_nic 
 
 	for (i = 0; i < config->rx_ring_num; i++) {
 		mac_control->rings[i].mtu = dev->mtu;
-		ret = fill_rx_buffers(&mac_control->rings[i]);
+		ret = fill_rx_buffers(sp, &mac_control->rings[i]);
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-x1205-fix-alarm-set-fix.patch
update-ntfs-help-text-fix.patch
cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
spi-fix-the-read-path-in-spidev-cleanup.patch
security-filesystem-capabilities-fix-fragile-setuid-fixup-code-checkpatch-fixes.patch
doc-document-the-relax_domain_level-kernel-boot-argument-fix.patch
revert-introduce-rculisth.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixups.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
arch-x86-kernel-smpbootc-fix-warning.patch
arch-x86-mm-pgtable_32c-remove-unused-variable-fixmaps.patch
drivers-media-video-cx18-cx18-av-firmwarec-fix-warning.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming-checkpatch-fixes.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-fix.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver-fix.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
unevictable-lru-infrastructure-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

