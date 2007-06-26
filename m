From: akpm@linux-foundation.org
Subject: + libata-add-irq_flags-to-struct-pata_platform_info.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:33:28 -0700
Message-ID: <200706261933.l5QJXSTM000643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbXFZTdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.adi@gmail.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata: add irq_flags to struct pata_platform_info
has been added to the -mm tree.  Its filename is
     libata-add-irq_flags-to-struct-pata_platform_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add irq_flags to struct pata_platform_info
From: "Sonic Zhang" <sonic.adi@gmail.com>

On some embedded platforms, such as blackfin, the gpio interrupt for IDE
interface is designed to be triggered with high voltage.  The gpio port
should be configured properly by set_irq_type() when register the irq. 
This patch enable the generic pata platform driver to accept platform irq
flags data.

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_platform.c   |    6 ++++--
 include/linux/pata_platform.h |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_platform.c~libata-add-irq_flags-to-struct-pata_platform_info drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~libata-add-irq_flags-to-struct-pata_platform_info
+++ a/drivers/ata/pata_platform.c
@@ -139,6 +139,7 @@ static int __devinit pata_platform_probe
 	struct resource *io_res, *ctl_res;
 	struct ata_host *host;
 	struct ata_port *ap;
+	struct pata_platform_info *pp_info;
 	unsigned int mmio;
 
 	/*
@@ -208,11 +209,12 @@ static int __devinit pata_platform_probe
 
 	ap->ioaddr.altstatus_addr = ap->ioaddr.ctl_addr;
 
-	pata_platform_setup_port(&ap->ioaddr, pdev->dev.platform_data);
+	pp_info = (struct pata_platform_info *)(pdev->dev.platform_data);
+	pata_platform_setup_port(&ap->ioaddr, pp_info);
 
 	/* activate */
 	return ata_host_activate(host, platform_get_irq(pdev, 0), ata_interrupt,
-				 0, &pata_platform_sht);
+				 pp_info->irq_flags, &pata_platform_sht);
 }
 
 /**
diff -puN include/linux/pata_platform.h~libata-add-irq_flags-to-struct-pata_platform_info include/linux/pata_platform.h
--- a/include/linux/pata_platform.h~libata-add-irq_flags-to-struct-pata_platform_info
+++ a/include/linux/pata_platform.h
@@ -8,6 +8,11 @@ struct pata_platform_info {
 	 * spacing used by ata_std_ports().
 	 */
 	unsigned int ioport_shift;
+	/*
+	 * Indicate platform specific irq types and initial
+	 * IRQ flags when call request_irq()
+	 */
+	unsigned int irq_flags;
 };
 
 #endif /* __LINUX_PATA_PLATFORM_H */
_

Patches currently in -mm which might be from sonic.adi@gmail.com are

libata-add-irq_flags-to-struct-pata_platform_info.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
