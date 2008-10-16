From: akpm@linux-foundation.org
Subject: + acpi-fix-possible-null-ptr-dereference-in-acpi-code.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:50:58 -0700
Message-ID: <200810162050.m9GKowUd017599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbYJPUvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: donald.d.dugger@intel.com, astarikovskiy@suse.de, bjorn.helgaas@hp.com, lenb@kernel.org


The patch titled
     acpi: fix possible NULL ptr dereference in ACPI code
has been added to the -mm tree.  Its filename is
     acpi-fix-possible-null-ptr-dereference-in-acpi-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix possible NULL ptr dereference in ACPI code
From: Don Dugger <donald.d.dugger@intel.com>

Code in file `drivers/acpi/pci_link.c' is attempting to evaluate the _DIS
method to disable a link.  Unfortunately, the method code unconditionally
uses the last argument as a pointer on success so passing a NULL could
wind up dereferencing 0.  This patch just passes an appropriate pointer to
avoid this issue.

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/pci_link.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/pci_link.c~acpi-fix-possible-null-ptr-dereference-in-acpi-code drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c~acpi-fix-possible-null-ptr-dereference-in-acpi-code
+++ a/drivers/acpi/pci_link.c
@@ -671,6 +671,7 @@ int acpi_pci_link_free_irq(acpi_handle h
 {
 	struct acpi_device *device = NULL;
 	struct acpi_pci_link *link = NULL;
+	union acpi_operand_object *dummy;
 	acpi_status result;
 
 
@@ -709,7 +710,7 @@ int acpi_pci_link_free_irq(acpi_handle h
 			  acpi_device_bid(link->device)));
 
 	if (link->refcnt == 0) {
-		acpi_ut_evaluate_object(link->device->handle, "_DIS", 0, NULL);
+		acpi_ut_evaluate_object(link->device->handle, "_DIS", 0, &dummy);
 	}
 	mutex_unlock(&acpi_link_lock);
 	return (link->irq.active);
@@ -721,6 +722,7 @@ int acpi_pci_link_free_irq(acpi_handle h
 
 static int acpi_pci_link_add(struct acpi_device *device)
 {
+	union acpi_operand_object *dummy;
 	int result = 0;
 	struct acpi_pci_link *link = NULL;
 	int i = 0;
@@ -773,7 +775,7 @@ static int acpi_pci_link_add(struct acpi
 
       end:
 	/* disable all links -- to be activated on use */
-	acpi_ut_evaluate_object(device->handle, "_DIS", 0, NULL);
+	acpi_ut_evaluate_object(device->handle, "_DIS", 0, &dummy);
 	mutex_unlock(&acpi_link_lock);
 
 	if (result)
_

Patches currently in -mm which might be from donald.d.dugger@intel.com are

acpi-fix-possible-null-ptr-dereference-in-acpi-code.patch

