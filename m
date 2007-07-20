From: akpm@linux-foundation.org
Subject: - ata-fix-reported-task-file-values-in-sense-data.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:19 -0700
Message-ID: <200707201942.l6KJgJJE013079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763578AbXGTTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petr@vandrovec.name, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ata: fix reported task file values in sense data
has been removed from the -mm tree.  Its filename was
     ata-fix-reported-task-file-values-in-sense-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: fix reported task file values in sense data
From: Petr Vandrovec <petr@vandrovec.name>

ata_tf_read was setting HOB bit when lba48 command was submitted, but was
not clearing it before reading "normal" data.  As it is only place which
sets HOB bit in control register, and register reads should not be affected
by other bits, let's just clear it when we are done with reading upper
bytes so non-48bit commands do not have to touch ctl at all.

pata_scc suffered from same problem...

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |    2 ++
 drivers/ata/pata_scc.c   |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/ata/libata-sff.c~ata-fix-reported-task-file-values-in-sense-data drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~ata-fix-reported-task-file-values-in-sense-data
+++ a/drivers/ata/libata-sff.c
@@ -211,6 +211,8 @@ void ata_tf_read(struct ata_port *ap, st
 		tf->hob_lbal = ioread8(ioaddr->lbal_addr);
 		tf->hob_lbam = ioread8(ioaddr->lbam_addr);
 		tf->hob_lbah = ioread8(ioaddr->lbah_addr);
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
 	}
 }
 
diff -puN drivers/ata/pata_scc.c~ata-fix-reported-task-file-values-in-sense-data drivers/ata/pata_scc.c
--- a/drivers/ata/pata_scc.c~ata-fix-reported-task-file-values-in-sense-data
+++ a/drivers/ata/pata_scc.c
@@ -358,6 +358,8 @@ static void scc_tf_read (struct ata_port
 		tf->hob_lbal = in_be32(ioaddr->lbal_addr);
 		tf->hob_lbam = in_be32(ioaddr->lbam_addr);
 		tf->hob_lbah = in_be32(ioaddr->lbah_addr);
+		out_be32(ioaddr->ctl_addr, tf->ctl);
+		ap->last_ctl = tf->ctl;
 	}
 }
 
_

Patches currently in -mm which might be from petr@vandrovec.name are

origin.patch
ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch
