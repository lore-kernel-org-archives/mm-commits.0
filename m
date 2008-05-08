From: akpm@linux-foundation.org
Subject: - mptsas-add-mptsas_shutdown-to-call-pci_disable_msi.patch removed from -mm tree
Date: Wed, 07 May 2008 17:25:31 -0700
Message-ID: <200805080025.m480PVxg024679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYEHAZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 20:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, ebiederm@xmission.com, sathya.prakash@lsi.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mptsas: add mptsas_shutdown to call pci_disable_msi
has been removed from the -mm tree.  Its filename was
     mptsas-add-mptsas_shutdown-to-call-pci_disable_msi.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mptsas: add mptsas_shutdown to call pci_disable_msi
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

this change

| commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
| Author: Prakash, Sathya <sathya.prakash@lsi.com>
| Date:   Fri Mar 7 15:53:21 2008 +0530
|
|     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
|
|     This patch modifies the driver to enable MSI by default for all SAS chips.
|

causes a kexec of the RHEL 5.1 kernel to fail.

root cause: the rhel 5.1 kernel still use INTx emulation.  and
mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path

So try to call mptsas_remove in mptsas_shutdown.  then pci_disable_msi will be
called via mptsas_remove==>mptscih_remove==> mpt_detach.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Prakash, Sathya <sathya.prakash@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptsas.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptsas.c~mptsas-add-mptsas_shutdown-to-call-pci_disable_msi drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~mptsas-add-mptsas_shutdown-to-call-pci_disable_msi
+++ a/drivers/message/fusion/mptsas.c
@@ -3326,6 +3326,11 @@ static void __devexit mptsas_remove(stru
 	mptscsih_remove(pdev);
 }
 
+static void mptsas_shutdown(struct pci_dev *pdev)
+{
+	mptsas_remove(pdev);
+}
+
 static struct pci_device_id mptsas_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
 		PCI_ANY_ID, PCI_ANY_ID },
@@ -3347,7 +3352,7 @@ static struct pci_driver mptsas_driver =
 	.id_table	= mptsas_pci_table,
 	.probe		= mptsas_probe,
 	.remove		= __devexit_p(mptsas_remove),
-	.shutdown	= mptscsih_shutdown,
+	.shutdown	= mptsas_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
 	.resume		= mptscsih_resume,
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

origin.patch
linux-next.patch
mptsas-add-mptsas_shutdown-to-call-pci_disable_msi.patch

