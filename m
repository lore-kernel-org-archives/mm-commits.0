From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 08 Jul 2011 11:13:45 -0700
Message-ID: <201107081813.p68IDI8r005599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab1GHSNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 14:13:52 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p68IDJPh012574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 8 Jul 2011 11:13:19 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/xen.c                      |   94 -------------
 drivers/net/vmxnet3/vmxnet3_int.h       |    7 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    3 
 drivers/net/wireless/iwlwifi/iwl-tx.c   |  150 ----------------------
 4 files changed, 254 deletions(-)

diff -puN arch/x86/pci/xen.c~linux-next-git-rejects arch/x86/pci/xen.c
--- a/arch/x86/pci/xen.c~linux-next-git-rejects
+++ a/arch/x86/pci/xen.c
@@ -372,83 +372,6 @@ int __init pci_xen_hvm_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_XEN_DOM0
-<<<<<<< HEAD
-static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
-{
-	int rc, pirq, irq = -1;
-	struct physdev_map_pirq map_irq;
-	int shareable = 0;
-	char *name;
-
-	if (!xen_pv_domain())
-		return -1;
-
-	if (triggering == ACPI_EDGE_SENSITIVE) {
-		shareable = 0;
-		name = "ioapic-edge";
-	} else {
-		shareable = 1;
-		name = "ioapic-level";
-	}
-	pirq = xen_allocate_pirq_gsi(gsi);
-	if (pirq < 0)
-		goto out;
-
-	if (gsi_override >= 0)
-		irq = xen_bind_pirq_gsi_to_irq(gsi_override, pirq, shareable, name);
-	else
-		irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
-	if (irq < 0)
-		goto out;
-
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
-
-	map_irq.domid = DOMID_SELF;
-	map_irq.type = MAP_PIRQ_TYPE_GSI;
-	map_irq.index = gsi;
-	map_irq.pirq = pirq;
-
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
-	if (rc) {
-		printk(KERN_WARNING "xen map irq failed %d\n", rc);
-		return -1;
-	}
-
-out:
-	return irq;
-}
-
-static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
-{
-	int rc, irq;
-	struct physdev_setup_gsi setup_gsi;
-
-	if (!xen_pv_domain())
-		return -1;
-
-	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
-			gsi, triggering, polarity);
-
-	irq = xen_register_pirq(gsi, gsi_override, triggering);
-
-	setup_gsi.gsi = gsi;
-	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
-	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
-	if (rc == -EEXIST)
-		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
-	else if (rc) {
-		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
-				gsi, rc);
-	}
-
-	return irq;
-}
-
-=======
->>>>>>> linux-next/akpm-end
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -483,16 +406,9 @@ static __init void xen_setup_acpi_sci(vo
 	 * the ACPI interpreter and keels over since IRQ 9 has not been
 	 * setup as we had setup IRQ 20 for it).
 	 */
-<<<<<<< HEAD
-	/* Check whether the GSI != IRQ */
-	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
-		if (irq >= 0 && irq != gsi)
-			/* Bugger, we MUST have that IRQ. */
-=======
 	if (acpi_gsi_to_irq(gsi, &irq) == 0) {
 		/* Use the provided value if it's valid. */
 		if (irq >= 0)
->>>>>>> linux-next/akpm-end
 			gsi_override = irq;
 	}
 
@@ -504,12 +420,7 @@ static __init void xen_setup_acpi_sci(vo
 
 int __init pci_xen_initial_domain(void)
 {
-<<<<<<< HEAD
-	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
-}
-=======
 	int irq;
->>>>>>> linux-next/akpm-end
 
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
@@ -525,12 +436,8 @@ int __init pci_xen_initial_domain(void)
 			continue;
 
 		xen_register_pirq(irq, -1 /* no GSI override */,
-<<<<<<< HEAD
-			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
-=======
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
 			true /* Map GSI to PIRQ */);
->>>>>>> linux-next/akpm-end
 	}
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
@@ -611,4 +518,3 @@ int xen_unregister_device_domain_owner(s
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_unregister_device_domain_owner);
-#endif
diff -puN drivers/net/vmxnet3/vmxnet3_int.h~linux-next-git-rejects drivers/net/vmxnet3/vmxnet3_int.h
--- a/drivers/net/vmxnet3/vmxnet3_int.h~linux-next-git-rejects
+++ a/drivers/net/vmxnet3/vmxnet3_int.h
@@ -70,17 +70,10 @@
 /*
  * Version numbers
  */
-<<<<<<< HEAD
-#define VMXNET3_DRIVER_VERSION_STRING   "1.1.18.0-k"
-
-/* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01011200
-=======
 #define VMXNET3_DRIVER_VERSION_STRING   "1.1.14.0-k"
 
 /* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
 #define VMXNET3_DRIVER_VERSION_NUM      0x01010E00
->>>>>>> linux-next/akpm-end
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
diff -puN drivers/net/wireless/iwlwifi/iwl-2000.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/iwl-2000.c
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -66,12 +66,9 @@
 
 #define IWL105_FW_PRE "iwlwifi-105-"
 #define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE __stringify(api) ".ucode"
-<<<<<<< HEAD
-=======
 
 #define IWL135_FW_PRE "iwlwifi-135-"
 #define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE #api ".ucode"
->>>>>>> linux-next/akpm-end
 
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
diff -puN drivers/net/wireless/iwlwifi/iwl-tx.c~linux-next-git-rejects drivers/net/wireless/iwlwifi/iwl-tx.c
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c~linux-next-git-rejects
+++ a/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -126,11 +126,7 @@ static inline u8 iwl_tfd_get_num_tbs(str
 }
 
 static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
-<<<<<<< HEAD
-			     struct iwl_tfd *tfd, int dma_dir)
-=======
 			     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
->>>>>>> linux-next/akpm-end
 {
 	int i;
 	int num_tbs;
@@ -153,11 +149,7 @@ static void iwlagn_unmap_tfd(struct iwl_
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
-<<<<<<< HEAD
-		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
-=======
 		dma_unmap_single(priv->bus.dev, iwl_tfd_tb_get_addr(tfd, i),
->>>>>>> linux-next/akpm-end
 				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
@@ -175,11 +167,7 @@ void iwlagn_txq_free_tfd(struct iwl_priv
 	int index = txq->q.read_ptr;
 
 	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
-<<<<<<< HEAD
-			 PCI_DMA_TODEVICE);
-=======
 			 DMA_TO_DEVICE);
->>>>>>> linux-next/akpm-end
 
 	/* free SKB */
 	if (txq->txb) {
@@ -305,11 +293,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
 			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
-<<<<<<< HEAD
-					 PCI_DMA_BIDIRECTIONAL);
-=======
 					 DMA_BIDIRECTIONAL);
->>>>>>> linux-next/akpm-end
 			txq->meta[i].flags = 0;
 		}
 
@@ -423,127 +407,6 @@ int iwl_queue_init(struct iwl_priv *priv
 	return 0;
 }
 
-<<<<<<< HEAD
-/**
- * iwl_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
- */
-static int iwl_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl_tx_queue *txq, u32 id)
-{
-	struct device *dev = &priv->pci_dev->dev;
-	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
-
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (id != priv->cmd_queue) {
-		txq->txb = kzalloc(sizeof(txq->txb[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->txb) {
-			IWL_ERR(priv, "kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else {
-		txq->txb = NULL;
-	}
-
-	/* Circular buffer of transmit frame descriptors (TFDs),
-	 * shared with device */
-	txq->tfds = dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr,
-				       GFP_KERNEL);
-	if (!txq->tfds) {
-		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n", tfd_sz);
-		goto error;
-	}
-	txq->q.id = id;
-
-	return 0;
-
- error:
-	kfree(txq->txb);
-	txq->txb = NULL;
-
-	return -ENOMEM;
-}
-
-/**
- * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
- */
-int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id)
-{
-	int i, len;
-	int ret;
-
-	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * slots_num,
-			    GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(struct iwl_device_cmd *) * slots_num,
-			   GFP_KERNEL);
-
-	if (!txq->meta || !txq->cmd)
-		goto out_free_arrays;
-
-	len = sizeof(struct iwl_device_cmd);
-	for (i = 0; i < slots_num; i++) {
-		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
-		if (!txq->cmd[i])
-			goto err;
-	}
-
-	/* Alloc driver data array and TFD circular buffer */
-	ret = iwl_tx_queue_alloc(priv, txq, txq_id);
-	if (ret)
-		goto err;
-
-	txq->need_update = 0;
-
-	/*
-	 * For the default queues 0-3, set up the swq_id
-	 * already -- all others need to get one later
-	 * (if they need one at all).
-	 */
-	if (txq_id < 4)
-		iwl_set_swq_id(txq, txq_id, txq_id);
-
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-	if (ret)
-		return ret;
-
-	/* Tell device where to find queue */
-	iwlagn_tx_queue_init(priv, txq);
-
-	return 0;
-err:
-	for (i = 0; i < slots_num; i++)
-		kfree(txq->cmd[i]);
-out_free_arrays:
-	kfree(txq->meta);
-	kfree(txq->cmd);
-
-	return -ENOMEM;
-}
-
-void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-			int slots_num, u32 txq_id)
-{
-	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * slots_num);
-
-	txq->need_update = 0;
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-
-	/* Tell device where to find queue */
-	iwlagn_tx_queue_init(priv, txq);
-}
-
-=======
->>>>>>> linux-next/akpm-end
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
@@ -692,21 +555,12 @@ int iwl_enqueue_hcmd(struct iwl_priv *pr
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-<<<<<<< HEAD
-		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
-					   cmd->len[i], PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
-			iwlagn_unmap_tfd(priv, out_meta,
-					 &txq->tfds[q->write_ptr],
-					 PCI_DMA_BIDIRECTIONAL);
-=======
 		phys_addr = dma_map_single(priv->bus.dev, (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(priv->bus.dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
 					 &txq->tfds[q->write_ptr],
 					 DMA_BIDIRECTIONAL);
->>>>>>> linux-next/akpm-end
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -810,11 +664,7 @@ void iwl_tx_cmd_complete(struct iwl_priv
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-<<<<<<< HEAD
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], PCI_DMA_BIDIRECTIONAL);
-=======
 	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
->>>>>>> linux-next/akpm-end
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

