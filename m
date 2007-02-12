From: akpm@linux-foundation.org
Subject: - spi_bitbang-use-overridable-setup_transfer-method.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:48 -0800
Message-ID: <200702122244.l1CMimmj013636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030269AbXBLWo4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hans-peter.nilsson@axis.com, dbrownell@users.sourceforge.net, hp@axis.com, mm-commits@vger.kernel.org


The patch titled
     spi_bitbang(): use overridable setup_transfer() method
has been removed from the -mm tree.  Its filename was
     spi_bitbang-use-overridable-setup_transfer-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_bitbang(): use overridable setup_transfer() method
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>

A small bug-fix for spi_bitbang: it must always call the setup_transfer
function via the overridable pointer, not assume that its
spi_bitbang_setup_transfer is sufficient.  Otherwise, if all options in the
transfers are default (0), the overrided function will never be called.

Granted, the function replacing it must call spi_bitbang_setup_transfer,
but it might also have other important things to do, even if the second
argument (the spi_transfer) is NULL.  Tested together with the other
patches on the spi_crisv32_sser and spi_crisv32_gpio drivers (not yet in
the kernel, will IIUC be submitted as part of the usual
arch-maintainer-pushes).

Signed-off-by: Hans-Peter Nilsson <hp@axis.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi_bitbang-use-overridable-setup_transfer-method drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi_bitbang-use-overridable-setup_transfer-method
+++ a/drivers/spi/spi_bitbang.c
@@ -210,7 +210,7 @@ int spi_bitbang_setup(struct spi_device 
 	if (!cs->txrx_word)
 		return -EINVAL;
 
-	retval = spi_bitbang_setup_transfer(spi, NULL);
+	retval = bitbang->setup_transfer(spi, NULL);
 	if (retval < 0)
 		return retval;
 
@@ -442,9 +442,10 @@ EXPORT_SYMBOL_GPL(spi_bitbang_transfer);
  * hardware that basically exposes a shift register) or per-spi_transfer
  * (which takes better advantage of hardware like fifos or DMA engines).
  *
- * Drivers using per-word I/O loops should use (or call) spi_bitbang_setup and
- * spi_bitbang_cleanup to handle those spi master methods.  Those methods are
- * the defaults if the bitbang->txrx_bufs routine isn't initialized.
+ * Drivers using per-word I/O loops should use (or call) spi_bitbang_setup,
+ * spi_bitbang_cleanup and spi_bitbang_setup_transfer to handle those spi
+ * master methods.  Those methods are the defaults if the bitbang->txrx_bufs
+ * routine isn't initialized.
  *
  * This routine registers the spi_master, which will process requests in a
  * dedicated task, keeping IRQs unblocked most of the time.  To stop
_

Patches currently in -mm which might be from hans-peter.nilsson@axis.com are

origin.patch
