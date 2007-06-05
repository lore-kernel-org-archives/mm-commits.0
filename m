From: akpm@linux-foundation.org
Subject: + libata-config_pm=n-compile-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 10:36:19 -0700
Message-ID: <200706051736.l55HaKCI031630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbXFERga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 13:36:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net


The patch titled
     libata: CONFIG_PM=n compile fix
has been added to the -mm tree.  Its filename is
     libata-config_pm=n-compile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1493,6 +1493,14 @@ static void ahci_post_internal_cmd(struc
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
@@ -1510,14 +1518,6 @@ static int ahci_port_suspend(struct ata_
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

8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
libata-config_pm=n-compile-fix.patch
8xx-fix-whitespace-and-indentation.patch
