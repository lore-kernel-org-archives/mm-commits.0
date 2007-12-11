From: akpm@linux-foundation.org
Subject: + acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch added to -mm tree
Date: Mon, 10 Dec 2007 16:07:32 -0800
Message-ID: <200712110007.lBB07WUu025922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbXLKAHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 19:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of list_for_each()
has been added to the -mm tree.  Its filename is
     acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of list_for_each()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

acpi_pci_irq_find_prt_entry(): use list_for_each_entry() instead of
list_for_each()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_irq.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/acpi/pci_irq.c~acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each drivers/acpi/pci_irq.c
--- a/drivers/acpi/pci_irq.c~acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each
+++ a/drivers/acpi/pci_irq.c
@@ -51,10 +51,8 @@ static struct acpi_prt_entry *acpi_pci_i
 							  int bus,
 							  int device, int pin)
 {
-	struct list_head *node = NULL;
 	struct acpi_prt_entry *entry = NULL;
 
-
 	if (!acpi_prt.count)
 		return NULL;
 
@@ -64,8 +62,7 @@ static struct acpi_prt_entry *acpi_pci_i
 	 *
 	 */
 	spin_lock(&acpi_prt_lock);
-	list_for_each(node, &acpi_prt.entries) {
-		entry = list_entry(node, struct acpi_prt_entry, node);
+	list_for_each_entry(entry, &acpi_prt.entries, node) {
 		if ((segment == entry->id.segment)
 		    && (bus == entry->id.bus)
 		    && (device == entry->id.device)
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

acpi_pci_irq_find_prt_entry-use-list_for_each_entry-instead-of-list_for_each.patch
git-dvb.patch
git-infiniband.patch
git-netdev-all.patch
git-scsi-misc.patch
edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
usb-testing-driver-convert-dev-sem-to-mutex.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
