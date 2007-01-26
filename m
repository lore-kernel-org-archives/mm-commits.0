From: akpm@osdl.org
Subject: + spi_bitbang-use-overridable-setup_transfer-method.patch added to -mm tree
Date: Thu, 25 Jan 2007 20:24:08 -0800
Message-ID: <200701260424.l0Q4O8xD007280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44724 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030737AbXAZEYV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 23:24:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-peter.nilsson@axis.com, dbrownell@users.sourceforge.net, hp@axis.com


The patch titled
     spi_bitbang(): use overridable setup_transfer() method
has been added to the -mm tree.  Its filename is
     spi_bitbang-use-overridable-setup_transfer-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

spi_bitbang-use-overridable-setup_transfer-method.patch
