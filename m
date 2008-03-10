From: akpm@linux-foundation.org
Subject: + ata-swncq-should-be-enabled-by-default.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:36:55 -0700
Message-ID: <200803102036.m2AKatRj004347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYCJUhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zboszor@dunaweb.hu, hancockr@shaw.ca


The patch titled
     ata: SWNCQ should be enabled by default
has been added to the -mm tree.  Its filename is
     ata-swncq-should-be-enabled-by-default.patch

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
Subject: ata: SWNCQ should be enabled by default
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>

unchangelogged patch.

Signed-off-by: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-swncq-should-be-enabled-by-default drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-swncq-should-be-enabled-by-default
+++ a/drivers/ata/sata_nv.c
@@ -641,7 +641,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
-static int swncq_enabled;
+static int swncq_enabled = 1;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2600,5 +2600,5 @@ module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
-MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: false)");
+MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
 
_

Patches currently in -mm which might be from zboszor@dunaweb.hu are

ata-swncq-should-be-enabled-by-default.patch

