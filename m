From: akpm@linux-foundation.org
Subject: [merged] ata-fix-obviously-wrong-comment.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:50 -0700
Message-ID: <200904141950.n3EJooRG020361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbZDNTyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, arjan@linux.intel.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ata: fix obviously wrong comment
has been removed from the -mm tree.  Its filename was
     ata-fix-obviously-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: fix obviously wrong comment
From: Vegard Nossum <vegard.nossum@gmail.com>

Also remove the now-useless debug printouts which are supposed to tell us
when the scan starts and ends.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/ata/libata-core.c~ata-fix-obviously-wrong-comment drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~ata-fix-obviously-wrong-comment
+++ a/drivers/ata/libata-core.c
@@ -6121,13 +6121,11 @@ int ata_host_register(struct ata_host *h
 			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
 	}
 
-	/* perform each probe synchronously */
-	DPRINTK("probe begin\n");
+	/* perform each probe asynchronously */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 		async_schedule(async_port_probe, ap);
 	}
-	DPRINTK("probe end\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch

