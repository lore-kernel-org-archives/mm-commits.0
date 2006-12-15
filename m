From: akpm@osdl.org
Subject: - aic79xx-wrong-max-memory-at-driver-init.patch removed from -mm tree
Date: Fri, 15 Dec 2006 12:08:29 -0800
Message-ID: <200612152008.kBFK8TBd028218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40628 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbWLOUIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 15:08:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frederic.temporelli@ext.bull.net, frederic.temporelli@bull.net, hare@suse.de, xavier.bru@bull.net, mm-commits@vger.kernel.org


The patch titled
     aic79xx: wrong max memory at driver init
has been removed from the -mm tree.  Its filename was
     aic79xx-wrong-max-memory-at-driver-init.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: aic79xx: wrong max memory at driver init
From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

Aic79xx driver for Adaptec 39320 supports 64-bit addressing, but the
initialization code of the driver is wrong: it tests the available memory
size instead of testing the maximum available memory address.  This is
necessary to support servers that provides 1 Terabyte of physical memory
space addressing.

Attached is the suggested patch to solve this issue.

[akpm@osdl.org: extern decls never go in .c files]
Signed-off-by: <xavier.bru@bull.net>
Signed-off-by: <frederic.temporelli@bull.net>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic79xx-wrong-max-memory-at-driver-init drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~aic79xx-wrong-max-memory-at-driver-init
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -44,6 +44,7 @@
 
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
+#include <linux/blkdev.h>
 #include <scsi/scsicam.h>
 
 static struct scsi_transport_template *ahd_linux_transport_template = NULL;
@@ -1130,10 +1131,9 @@ ahd_linux_register_host(struct ahd_softc
 uint64_t
 ahd_linux_get_memsize(void)
 {
-	struct sysinfo si;
-
-	si_meminfo(&si);
-	return ((uint64_t)si.totalram << PAGE_SHIFT);
+	/* Need to take in account the max physical address in case
+	 * of discontiguous memory. */
+	return ((uint64_t)blk_max_pfn << PAGE_SHIFT);
 }
 
 /*
_

Patches currently in -mm which might be from frederic.temporelli@ext.bull.net are

aic79xx-wrong-max-memory-at-driver-init.patch

