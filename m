From: akpm@linux-foundation.org
Subject: + spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs.patch added to -mm tree
Date: Wed, 25 Nov 2009 13:46:13 -0800
Message-ID: <200911252146.nAPLkD7Q003745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932371AbZKYVqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 16:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, david-b@pacbell.net, grant.likely@secretlab.ca, lethal@linux-sh.org


The patch titled
     spi: allow using spi_bitbang_setup() with custom txrx_bufs()
has been added to the -mm tree.  Its filename is
     spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs.patch

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
Subject: spi: allow using spi_bitbang_setup() with custom txrx_bufs()
From: Magnus Damm <damm@opensource.se>

This patch modifies the shared spi bitbanging code to allow using
spi_bitbang_setup() even though the txrx_word[] callbacks are unset. 
Useful for drivers that want to make use of spi_bitbang_setup() but have
their own txrx_bufs() callback.

While at it, drop the MSIOF driver workaround which was there to address
this shortcoming.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c  |   25 ++++++++++++++-----------
 drivers/spi/spi_sh_msiof.c |   11 -----------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs
+++ a/drivers/spi/spi_bitbang.c
@@ -176,6 +176,14 @@ int spi_bitbang_setup_transfer(struct sp
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_setup_transfer);
 
+static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
+{
+	struct spi_bitbang_cs	*cs = spi->controller_state;
+	unsigned		nsecs = cs->nsecs;
+
+	return cs->txrx_bufs(spi, cs->txrx_word, nsecs, t);
+}
+
 /**
  * spi_bitbang_setup - default setup for per-word I/O loops
  */
@@ -183,6 +191,7 @@ int spi_bitbang_setup(struct spi_device 
 {
 	struct spi_bitbang_cs	*cs = spi->controller_state;
 	struct spi_bitbang	*bitbang;
+	int			mode_mask = SPI_CPOL | SPI_CPHA;
 	int			retval;
 	unsigned long		flags;
 
@@ -196,9 +205,11 @@ int spi_bitbang_setup(struct spi_device 
 	}
 
 	/* per-word shift register access, in hardware or bitbanging */
-	cs->txrx_word = bitbang->txrx_word[spi->mode & (SPI_CPOL|SPI_CPHA)];
-	if (!cs->txrx_word)
-		return -EINVAL;
+	if (bitbang->txrx_bufs == spi_bitbang_bufs) {
+		cs->txrx_word = bitbang->txrx_word[spi->mode & mode_mask];
+		if (!cs->txrx_word)
+			return -EINVAL;
+	}
 
 	retval = bitbang->setup_transfer(spi, NULL);
 	if (retval < 0)
@@ -232,14 +243,6 @@ void spi_bitbang_cleanup(struct spi_devi
 }
 EXPORT_SYMBOL_GPL(spi_bitbang_cleanup);
 
-static int spi_bitbang_bufs(struct spi_device *spi, struct spi_transfer *t)
-{
-	struct spi_bitbang_cs	*cs = spi->controller_state;
-	unsigned		nsecs = cs->nsecs;
-
-	return cs->txrx_bufs(spi, cs->txrx_word, nsecs, t);
-}
-
 /*----------------------------------------------------------------------*/
 
 /*
diff -puN drivers/spi/spi_sh_msiof.c~spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs drivers/spi/spi_sh_msiof.c
--- a/drivers/spi/spi_sh_msiof.c~spi-allow-using-spi_bitbang_setup-with-custom-txrx_bufs
+++ a/drivers/spi/spi_sh_msiof.c
@@ -510,13 +510,6 @@ static int sh_msiof_spi_txrx(struct spi_
 	return bytes_done;
 }
 
-static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
-				  u32 word, u8 bits)
-{
-	BUG_ON(1); /* unused but needed by bitbang code */
-	return 0;
-}
