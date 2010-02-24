From: akpm@linux-foundation.org
Subject: + omap2_mcspic-null-pointer-dereference.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:50:35 -0800
Message-ID: <201002242250.o1OMoZe1025119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758042Ab0BXWvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scott@jumpnowtek.com, Aaro.Koskinen@nokia.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, khilman@deeprootsystems.com, tony@atomide.com


The patch titled
     omap2_mcspi.c: NULL pointer dereference
has been added to the -mm tree.  Its filename is
     omap2_mcspic-null-pointer-dereference.patch

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
Subject: omap2_mcspi.c: NULL pointer dereference
From: Scott Ellis <scott@jumpnowtek.com>

Check spi->controller_state before dereferencing.

Shows up NULL here when using spi_alloc_device()/spi_add_device()
and spi_add_device() fails before spi_setup(). Calling spi_dev_put()
on the leftover spi_device results in the error.

Signed-off-by: Scott Ellis <scott@jumpnowtek.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Aaro Koskinen <Aaro.Koskinen@nokia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~omap2_mcspic-null-pointer-dereference drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~omap2_mcspic-null-pointer-dereference
+++ a/drivers/spi/omap2_mcspi.c
@@ -751,11 +751,13 @@ static void omap2_mcspi_cleanup(struct s
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
-	/* Unlink controller state from context save list */
-	cs = spi->controller_state;
-	list_del(&cs->node);
+	if (spi->controller_state) {
+		/* Unlink controller state from context save list */
+		cs = spi->controller_state;
+		list_del(&cs->node);
 
-	kfree(spi->controller_state);
+		kfree(spi->controller_state);
+	}
 
 	if (mcspi_dma->dma_rx_channel != -1) {
 		omap_free_dma(mcspi_dma->dma_rx_channel);
_

Patches currently in -mm which might be from scott@jumpnowtek.com are

omap2_mcspic-null-pointer-dereference.patch

