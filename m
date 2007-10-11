From: akpm@linux-foundation.org
Subject: + pnp-add-debug-message-for-adding-new-device-fix.patch added to -mm tree
Date: Thu, 11 Oct 2007 14:13:37 -0700
Message-ID: <200710112113.l9BLDbZt015834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbXJKVNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Oct 2007 17:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     PNP: add debug message for adding new device (fix unused var)
has been added to the -mm tree.  Its filename is
     pnp-add-debug-message-for-adding-new-device-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: add debug message for adding new device (fix unused var)
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device-fix drivers/pnp/core.c
--- a/drivers/pnp/core.c~pnp-add-debug-message-for-adding-new-device-fix
+++ a/drivers/pnp/core.c
@@ -141,7 +141,9 @@ int __pnp_add_device(struct pnp_dev *dev
 int pnp_add_device(struct pnp_dev *dev)
 {
 	int ret;
+#ifdef CONFIG_PNP_DEBUG
 	struct pnp_id *id;
+#endif
 
 	if (dev->card)
 		return -EINVAL;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
pnp-remove-null-pointer-checks.patch
pnp-simplify-pnp-card-error-handling.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch
pnp-use-dev_info-in-system-driver.patch
pnp-simplify-pnpbios-insert_device.patch
pnp-add-debug-message-for-adding-new-device.patch
pnp-add-debug-message-for-adding-new-device-fix.patch
