From: akpm@linux-foundation.org
Subject: + infiniband-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:09 -0700
Message-ID: <53ab2341.UzcFu09b5F/0FUvh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFYTaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, faisal.latif@intel.com, hal.rosenstock@gmail.com, roland@kernel.org, sean.hefty@intel.com, swise@opengridcomputing.com, tom@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: infiniband: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     infiniband-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/infiniband-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/infiniband-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: infiniband: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2.c   |    6 ++----
 drivers/infiniband/hw/nes/nes_hw.c    |   12 ++++++------
 drivers/infiniband/hw/nes/nes_verbs.c |    5 ++---
 3 files changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2.c~infiniband-use-pci_zalloc_consistent drivers/infiniband/hw/amso1100/c2.c
--- a/drivers/infiniband/hw/amso1100/c2.c~infiniband-use-pci_zalloc_consistent
+++ a/drivers/infiniband/hw/amso1100/c2.c
@@ -604,16 +604,14 @@ static int c2_up(struct net_device *netd
 	tx_size = c2_port->tx_ring.count * sizeof(struct c2_tx_desc);
 
 	c2_port->mem_size = tx_size + rx_size;
-	c2_port->mem = pci_alloc_consistent(c2dev->pcidev, c2_port->mem_size,
-					    &c2_port->dma);
+	c2_port->mem = pci_zalloc_consistent(c2dev->pcidev, c2_port->mem_size,
+					     &c2_port->dma);
 	if (c2_port->mem == NULL) {
 		pr_debug("Unable to allocate memory for "
 			"host descriptor rings\n");
 		return -ENOMEM;
 	}
 
-	memset(c2_port->mem, 0, c2_port->mem_size);
-
 	/* Create the Rx host descriptor ring */
 	if ((ret =
 	     c2_rx_ring_alloc(&c2_port->rx_ring, c2_port->mem, c2_port->dma,
diff -puN drivers/infiniband/hw/nes/nes_hw.c~infiniband-use-pci_zalloc_consistent drivers/infiniband/hw/nes/nes_hw.c
--- a/drivers/infiniband/hw/nes/nes_hw.c~infiniband-use-pci_zalloc_consistent
+++ a/drivers/infiniband/hw/nes/nes_hw.c
@@ -1003,13 +1003,13 @@ int nes_init_cqp(struct nes_device *nesd
 			(sizeof(struct nes_hw_aeqe) * nesadapter->max_qp) +
 			sizeof(struct nes_hw_cqp_qp_context);
 
-	nesdev->cqp_vbase = pci_alloc_consistent(nesdev->pcidev, nesdev->cqp_mem_size,
-			&nesdev->cqp_pbase);
+	nesdev->cqp_vbase = pci_zalloc_consistent(nesdev->pcidev,
+						  nesdev->cqp_mem_size,
+						  &nesdev->cqp_pbase);
 	if (!nesdev->cqp_vbase) {
 		nes_debug(NES_DBG_INIT, "Unable to allocate memory for host descriptor rings\n");
 		return -ENOMEM;
 	}
-	memset(nesdev->cqp_vbase, 0, nesdev->cqp_mem_size);
 
 	/* Allocate a twice the number of CQP requests as the SQ size */
 	nesdev->nes_cqp_requests = kzalloc(sizeof(struct nes_cqp_request) *
@@ -1691,13 +1691,13 @@ int nes_init_nic_qp(struct nes_device *n
 			(NES_NIC_WQ_SIZE * 2 * sizeof(struct nes_hw_nic_cqe)) +
 			sizeof(struct nes_hw_nic_qp_context);
 
-	nesvnic->nic_vbase = pci_alloc_consistent(nesdev->pcidev, nesvnic->nic_mem_size,
-			&nesvnic->nic_pbase);
+	nesvnic->nic_vbase = pci_zalloc_consistent(nesdev->pcidev,
+						   nesvnic->nic_mem_size,
+						   &nesvnic->nic_pbase);
 	if (!nesvnic->nic_vbase) {
 		nes_debug(NES_DBG_INIT, "Unable to allocate memory for NIC host descriptor rings\n");
 		return -ENOMEM;
 	}
-	memset(nesvnic->nic_vbase, 0, nesvnic->nic_mem_size);
 	nes_debug(NES_DBG_INIT, "Allocated NIC QP structures at %p (phys = %016lX), size = %u.\n",
 			nesvnic->nic_vbase, (unsigned long)nesvnic->nic_pbase, nesvnic->nic_mem_size);
 
diff -puN drivers/infiniband/hw/nes/nes_verbs.c~infiniband-use-pci_zalloc_consistent drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c~infiniband-use-pci_zalloc_consistent
+++ a/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1616,8 +1616,8 @@ static struct ib_cq *nes_create_cq(struc
 				entries, nescq->cq_mem_size, nescq->hw_cq.cq_number);
 
 		/* allocate the physical buffer space */
-		mem = pci_alloc_consistent(nesdev->pcidev, nescq->cq_mem_size,
-				&nescq->hw_cq.cq_pbase);
+		mem = pci_zalloc_consistent(nesdev->pcidev, nescq->cq_mem_size,
+					    &nescq->hw_cq.cq_pbase);
 		if (!mem) {
 			printk(KERN_ERR PFX "Unable to allocate pci memory for cq\n");
 			nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
@@ -1625,7 +1625,6 @@ static struct ib_cq *nes_create_cq(struc
 			return ERR_PTR(-ENOMEM);
 		}
 
-		memset(mem, 0, nescq->cq_mem_size);
 		nescq->hw_cq.cq_vbase = mem;
 		nescq->hw_cq.cq_head = 0;
 		nes_debug(NES_DBG_CQ, "CQ%u virtual address @ %p, phys = 0x%08X\n",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

