From: akpm@linux-foundation.org
Subject: + vme-bridges-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:27 -0700
Message-ID: <53ab2353.0rrhw/7WyQndQpuP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaFYTa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, manohar.vanga@gmail.com, martyn.welch@ge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vme: bridges: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     vme-bridges-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vme-bridges-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vme-bridges-use-pci_zalloc_consistent.patch

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
Subject: vme: bridges: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vme/bridges/vme_ca91cx42.c |    6 ++----
 drivers/vme/bridges/vme_tsi148.c   |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/vme/bridges/vme_ca91cx42.c~vme-bridges-use-pci_zalloc_consistent drivers/vme/bridges/vme_ca91cx42.c
--- a/drivers/vme/bridges/vme_ca91cx42.c~vme-bridges-use-pci_zalloc_consistent
+++ a/drivers/vme/bridges/vme_ca91cx42.c
@@ -1555,16 +1555,14 @@ static int ca91cx42_crcsr_init(struct vm
 	}
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for CR/CSR "
 			"image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
-
 	crcsr_addr = slot * (512 * 1024);
 	iowrite32(bridge->crcsr_bus - crcsr_addr, bridge->base + VCSR_TO);
 
diff -puN drivers/vme/bridges/vme_tsi148.c~vme-bridges-use-pci_zalloc_consistent drivers/vme/bridges/vme_tsi148.c
--- a/drivers/vme/bridges/vme_tsi148.c~vme-bridges-use-pci_zalloc_consistent
+++ a/drivers/vme/bridges/vme_tsi148.c
@@ -2275,16 +2275,14 @@ static int tsi148_crcsr_init(struct vme_
 	bridge = tsi148_bridge->driver_priv;
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(tsi148_bridge->parent, "Failed to allocate memory for "
 			"CR/CSR image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
-
 	reg_split(bridge->crcsr_bus, &crcsr_bus_high, &crcsr_bus_low);
 
 	iowrite32be(crcsr_bus_high, bridge->base + TSI148_LCSR_CROU);
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

