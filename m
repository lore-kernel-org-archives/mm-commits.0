From: akpm@linux-foundation.org
Subject: + acpi-use-acpi_debug_print-instead-of-printk.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:28:22 -0800
Message-ID: <200802152128.m1FLSMGi024897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbYBOV3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, lenb@kernel.org


The patch titled
     acpi: use ACPI_DEBUG_PRINT instead of printk
has been added to the -mm tree.  Its filename is
     acpi-use-acpi_debug_print-instead-of-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: use ACPI_DEBUG_PRINT instead of printk
From: Glauber Costa <gcosta@redhat.com>

For consistency, use ACPI_DEBUG_PRINT instead of printk in
acpi_processor_hotplug_notify() for BUS_CHECK and DEVICE_CHECK events

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-use-acpi_debug_print-instead-of-printk drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-use-acpi_debug_print-instead-of-printk
+++ a/drivers/acpi/processor_core.c
@@ -890,9 +890,10 @@ acpi_processor_hotplug_notify(acpi_handl
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		printk("Processor driver received %s event\n",
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+		"Processor driver received %s event\n",
 		       (event == ACPI_NOTIFY_BUS_CHECK) ?
-		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK");
+		       "ACPI_NOTIFY_BUS_CHECK" : "ACPI_NOTIFY_DEVICE_CHECK"));
 
 		if (!is_processor_present(handle))
 			break;
_

Patches currently in -mm which might be from gcosta@redhat.com are

remove-is_processor_present-prototype.patch
acpi-use-acpi_debug_print-instead-of-printk.patch
git-kvm.patch
