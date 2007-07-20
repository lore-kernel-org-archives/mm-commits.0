From: akpm@linux-foundation.org
Subject: - libata-config_pm=n-compile-fix.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:17 -0700
Message-ID: <200707201942.l6KJgH7K013074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760920AbXGTTm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     libata: CONFIG_PM=n compile fix
has been removed from the -mm tree.  Its filename was
     libata-config_pm=n-compile-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: CONFIG_PM=n compile fix
From: olof@lixom.net (Olof Johansson)

CONFIG_PM=n compile fix.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/ata/ahci.c~libata-config_pm=n-compile-fix drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~libata-config_pm=n-compile-fix
+++ a/drivers/ata/ahci.c
@@ -1519,6 +1519,14 @@ static void ahci_post_internal_cmd(struc
 	}
 }
 
+static int ahci_port_resume(struct ata_port *ap)
+{
+	ahci_power_up(ap);
+	ahci_start_port(ap);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 {
@@ -1536,14 +1544,6 @@ static int ahci_port_suspend(struct ata_
 	return rc;
 }
 
-static int ahci_port_resume(struct ata_port *ap)
-{
-	ahci_power_up(ap);
-	ahci_start_port(ap);
-
-	return 0;
-}
-
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
