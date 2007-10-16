From: akpm@linux-foundation.org
Subject: - pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 16:06:00 -0700
Message-ID: <200710162306.l9GN60Q0022435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965647AbXJPXGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 19:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is enabled
has been removed from the -mm tree.  Its filename was
     pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch

This patch was dropped because it was folded into pnp-use-dev_info-dev_err-etc-in-core.patch

------------------------------------------------------
Subject: PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is enabled
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We now use dev_dbg(), which is enabled when DEBUG is defined.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/Makefile~pnp-use-dev_info-dev_err-etc-in-core-fix-fix drivers/pnp/Makefile
--- a/drivers/pnp/Makefile~pnp-use-dev_info-dev_err-etc-in-core-fix-fix
+++ a/drivers/pnp/Makefile
@@ -7,3 +7,7 @@ obj-y		:= core.o card.o driver.o resourc
 obj-$(CONFIG_PNPACPI)		+= pnpacpi/
 obj-$(CONFIG_PNPBIOS)		+= pnpbios/
 obj-$(CONFIG_ISAPNP)		+= isapnp/
+
+ifeq ($(CONFIG_PNP_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
pnp-remove-null-pointer-checks.patch
pnp-simplify-pnp-card-error-handling.patch
pnp-use-dev_info-dev_err-etc-in-core.patch
pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch
pnp-use-dev_info-in-system-driver.patch
pnp-simplify-pnpbios-insert_device.patch
pnp-add-debug-message-for-adding-new-device.patch
pnp-add-debug-message-for-adding-new-device-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
