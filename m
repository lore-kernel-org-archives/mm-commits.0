From: akpm@linux-foundation.org
Subject: + qlogic-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:17 -0700
Message-ID: <53ab2349.+NxOnQlgMVYOvu+g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaFYTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, davem@davemloft.net, jitendra.kalsaria@qlogic.com, manish.chopra@qlogic.com, rajesh.borundia@qlogic.com, ron.mercer@qlogic.com, shahed.shaikh@qlogic.com, sony.chacko@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: qlogic: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     qlogic-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/qlogic-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/qlogic-use-pci_zalloc_consistent.patch

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
Subject: qlogic: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Manish Chopra <manish.chopra@qlogic.com>
Cc: Sony Chacko <sony.chacko@qlogic.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c |    4 ---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c        |   11 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c~qlogic-use-pci_zalloc_consistent drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c~qlogic-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -129,14 +129,12 @@ netxen_get_minidump_template(struct netx
 		return NX_RCODE_INVALID_ARGS;
 	}
 
-	addr = pci_alloc_consistent(adapter->pdev, size, &md_template_addr);
-
+	addr = pci_zalloc_consistent(adapter->pdev, size, &md_template_addr);
 	if (!addr) {
 		dev_err(&adapter->pdev->dev, "Unable to allocate dmable memory for template.\n");
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, size);
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&cmd.rsp, 1, sizeof(struct _cdrp_cmd));
 	cmd.req.cmd = NX_CDRP_CMD_GET_TEMP_HDR;
diff -puN drivers/net/ethernet/qlogic/qlge/qlge_main.c~qlogic-use-pci_zalloc_consistent drivers/net/ethernet/qlogic/qlge/qlge_main.c
--- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c~qlogic-use-pci_zalloc_consistent
+++ a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
@@ -2727,23 +2727,22 @@ static void ql_free_shadow_space(struct
 static int ql_alloc_shadow_space(struct ql_adapter *qdev)
 {
 	qdev->rx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev,
-				 PAGE_SIZE, &qdev->rx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->rx_ring_shadow_reg_dma);
 	if (qdev->rx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of RX shadow space failed.\n");
 		return -ENOMEM;
 	}
-	memset(qdev->rx_ring_shadow_reg_area, 0, PAGE_SIZE);
+
 	qdev->tx_ring_shadow_reg_area =
-	    pci_alloc_consistent(qdev->pdev, PAGE_SIZE,
-				 &qdev->tx_ring_shadow_reg_dma);
+		pci_zalloc_consistent(qdev->pdev, PAGE_SIZE,
+				      &qdev->tx_ring_shadow_reg_dma);
 	if (qdev->tx_ring_shadow_reg_area == NULL) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Allocation of TX shadow space failed.\n");
 		goto err_wqp_sh_area;
 	}
-	memset(qdev->tx_ring_shadow_reg_area, 0, PAGE_SIZE);
 	return 0;
 
 err_wqp_sh_area:
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

