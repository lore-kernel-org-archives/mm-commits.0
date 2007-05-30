From: akpm@linux-foundation.org
Subject: + aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch added to -mm tree
Date: Wed, 30 May 2007 15:30:53 -0700
Message-ID: <200705302230.l4UMUrrb006757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbXE3WbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark_salyzyn@adaptec.com, James.Bottomley@steeleye.com, aacraid@adaptec.com, akpm@linux-foundation.org, ebiederm@xmission.com, vgoyal@in.ibm.com, yhlu.kernel@gmail.com


The patch titled
     aacraid: fix shutdown handler to also disable interrupts.
has been added to the -mm tree.  Its filename is
     aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aacraid: fix shutdown handler to also disable interrupts.
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

Moves quiesce, thread and interrupt shutdown into aacraid drivers'
.shutdown handler.  This fix to the aac_shutdown handler will remove the
superfluous reset of the adapter during a (clean) kexec.

This fix may mitigate the active investigation 'kexec and aacraid
broken' but it is unlikely to affect the root cause (issue likely
present in both kexec and kdump). This patch reduces the chance the
problem will occur with a kexec. The fix for root cause is currently
expected to be the minimum value check to the aacraid.startup_timeout
driver variable after an adapter reset within aacraid_commit_reset.patch
submitted on 05/22/2007 and awaiting testing by Yinghai to confirm.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~aacraid-fix-shutdown-handler-to-also-disable-interrupts drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~aacraid-fix-shutdown-handler-to-also-disable-interrupts
+++ a/drivers/scsi/aacraid/linit.c
@@ -859,6 +859,14 @@ static struct scsi_host_template aac_dri
 	.emulated                       = 1,
 };
 
+static void __aac_shutdown(struct aac_dev * aac)
+{
+	kthread_stop(aac->thread);
+	aac_send_shutdown(aac);
+	aac_adapter_disable_int(aac);
+	free_irq(aac->pdev->irq, aac);
+}
+
 static int __devinit aac_probe_one(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
@@ -1011,10 +1019,7 @@ static int __devinit aac_probe_one(struc
 	return 0;
 
  out_deinit:
-	kthread_stop(aac->thread);
-	aac_send_shutdown(aac);
-	aac_adapter_disable_int(aac);
-	free_irq(pdev->irq, aac);
+	__aac_shutdown(aac);
  out_unmap:
 	aac_fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
@@ -1034,7 +1039,8 @@ static void aac_shutdown(struct pci_dev 
 {
 	struct Scsi_Host *shost = pci_get_drvdata(dev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
-	aac_send_shutdown(aac);
+	scsi_block_requests(shost);
+	__aac_shutdown(aac);
 }
 
 static void __devexit aac_remove_one(struct pci_dev *pdev)
@@ -1044,16 +1050,12 @@ static void __devexit aac_remove_one(str
 
 	scsi_remove_host(shost);
 
-	kthread_stop(aac->thread);
-
-	aac_send_shutdown(aac);
-	aac_adapter_disable_int(aac);
+	__aac_shutdown(aac);
 	aac_fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
 			aac->comm_phys);
 	kfree(aac->queues);
 
-	free_irq(pdev->irq, aac);
 	aac_adapter_ioremap(aac, 0);
 	
 	kfree(aac->fibs);
_

Patches currently in -mm which might be from mark_salyzyn@adaptec.com are

git-scsi-misc.patch
git-scsi-rc-fixes.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
