From: akpm@linux-foundation.org
Subject: + nsc-ircc-default-to-dongle-type-9-on-ibm-hardware.patch added to -mm tree
Date: Mon, 28 Jul 2008 19:46:31 -0700
Message-ID: <200807290246.m6T2kVPS010273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233AbYG2CrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 22:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben.collins@canonical.com, mjg59@srcf.ucam.org, samuel@sortiz.org


The patch titled
     nsc-ircc: default to dongle type 9 on IBM hardware
has been added to the -mm tree.  Its filename is
     nsc-ircc-default-to-dongle-type-9-on-ibm-hardware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nsc-ircc: default to dongle type 9 on IBM hardware
From: Ben Collins <ben.collins@canonical.com>

Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/nsc-ircc.c |    7 +++++--
 drivers/net/irda/nsc-ircc.h |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/net/irda/nsc-ircc.c~nsc-ircc-default-to-dongle-type-9-on-ibm-hardware drivers/net/irda/nsc-ircc.c
--- a/drivers/net/irda/nsc-ircc.c~nsc-ircc-default-to-dongle-type-9-on-ibm-hardware
+++ a/drivers/net/irda/nsc-ircc.c
@@ -151,8 +151,8 @@ static char *dongle_types[] = {
 static chipio_t pnp_info;
 static const struct pnp_device_id nsc_ircc_pnp_table[] = {
 	{ .id = "NSC6001", .driver_data = 0 },
-	{ .id = "IBM0071", .driver_data = 0 },
 	{ .id = "HWPC224", .driver_data = 0 },
+	{ .id = "IBM0071", .driver_data = NSC_FORCE_DONGLE_TYPE9 },
 	{ }
 };
 
@@ -930,7 +930,10 @@ static int nsc_ircc_pnp_probe(struct pnp
 	pnp_info.dma = -1;
 	pnp_succeeded = 1;
 
-	/* There don't seem to be any way to get the cfg_base.
+	if (id->driver_data & NSC_FORCE_DONGLE_TYPE9)
+		dongle_id = 0x9;
+
+	/* There doesn't seem to be any way of getting the cfg_base.
 	 * On my box, cfg_base is in the PnP descriptor of the
 	 * motherboard. Oh well... Jean II */
 
diff -puN drivers/net/irda/nsc-ircc.h~nsc-ircc-default-to-dongle-type-9-on-ibm-hardware drivers/net/irda/nsc-ircc.h
--- a/drivers/net/irda/nsc-ircc.h~nsc-ircc-default-to-dongle-type-9-on-ibm-hardware
+++ a/drivers/net/irda/nsc-ircc.h
@@ -35,6 +35,9 @@
 #include <linux/types.h>
 #include <asm/io.h>
 
+/* Features for chips (set in driver_data) */
+#define NSC_FORCE_DONGLE_TYPE9	0x00000001
+
 /* DMA modes needed */
 #define DMA_TX_MODE     0x08    /* Mem to I/O, ++, demand. */
 #define DMA_RX_MODE     0x04    /* I/O to mem, ++, demand. */
_

Patches currently in -mm which might be from ben.collins@canonical.com are

origin.patch
nsc-ircc-default-to-dongle-type-9-on-ibm-hardware.patch

