From: akpm@linux-foundation.org
Subject: - libata-fix-probe-time-irq-printouts.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:11 -0700
Message-ID: <200706121858.l5CIwB5A018525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbXFLTA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     libata: fix probe time irq printouts
has been removed from the -mm tree.  Its filename was
     libata-fix-probe-time-irq-printouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: fix probe time irq printouts
From: Olof Johansson <olof@lixom.net>

Most drivers don't seem to fill out the host->irq field, resulting in the
wrong (no) irq being reported at probe time.  For example, sil24 on my
system:

ata1: SATA max UDMA/100 cmd 0xd00008009001f000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/100 cmd 0xd000080090021000 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0

Since they're allocated and set up in ata_host_activate(), just save them
away there.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-fix-probe-time-irq-printouts drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-fix-probe-time-irq-printouts
+++ a/drivers/ata/libata-core.c
@@ -6509,6 +6509,9 @@ int ata_host_activate(struct ata_host *h
 	if (rc)
 		devm_free_irq(host->dev, irq, host);
 
+	/* Used to print device info at probe */
+	host->irq = irq;
+
 	return rc;
 }
 
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
libata-config_pm=n-compile-fix.patch
8xx-fix-whitespace-and-indentation.patch
