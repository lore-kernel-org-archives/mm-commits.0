From: akpm@linux-foundation.org
Subject: + pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch added to -mm tree
Date: Thu, 11 Oct 2007 14:12:41 -0700
Message-ID: <200710112112.l9BLCfh0015744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbXJKVMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Oct 2007 17:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is enabled
has been added to the -mm tree.  Its filename is
     pnp-use-dev_info-dev_err-etc-in-core-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
