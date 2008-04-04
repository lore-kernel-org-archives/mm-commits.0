From: akpm@linux-foundation.org
Subject: - ata-swncq-should-be-enabled-by-default.patch removed from -mm tree
Date: Fri, 04 Apr 2008 11:44:01 -0700
Message-ID: <200804041844.m34Ii1im003581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757418AbYDDSoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 14:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zboszor@dunaweb.hu, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: SWNCQ should be enabled by default
has been removed from the -mm tree.  Its filename was
     ata-swncq-should-be-enabled-by-default.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: SWNCQ should be enabled by default
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>

Enable SWNCQ by default for testing in 2.6.26-rcX[-mm]

Signed-off-by: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Cc: Robert Hancock <hancockr@shaw.ca>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-swncq-should-be-enabled-by-default drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-swncq-should-be-enabled-by-default
+++ a/drivers/ata/sata_nv.c
@@ -532,7 +532,7 @@ MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled = 1;
-static int swncq_enabled;
+static int swncq_enabled = 1;	/* FIXME: for testing during 2.6.26-rcX[-mmY] */
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2485,5 +2485,5 @@ module_exit(nv_exit);
 module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
-MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: false)");
+MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
 
_

Patches currently in -mm which might be from zboszor@dunaweb.hu are

git-libata-all.patch
ata-swncq-should-be-enabled-by-default.patch

