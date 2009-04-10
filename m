From: akpm@linux-foundation.org
Subject: + ata-fix-obviously-wrong-comment.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:43:13 -0700
Message-ID: <200904102143.n3ALhD0q004615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbZDJVqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, arjan@linux.intel.com, jgarzik@redhat.com


The patch titled
     ata: fix obviously wrong comment
has been added to the -mm tree.  Its filename is
     ata-fix-obviously-wrong-comment.patch

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
ata-fix-obviously-wrong-comment.patch

