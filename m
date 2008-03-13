From: akpm@linux-foundation.org
Subject: - acpi-use-acpi_debug_print-instead-of-printk.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:22 -0700
Message-ID: <200803131859.m2DIxMx9027949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbYCMTAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: use ACPI_DEBUG_PRINT instead of printk
has been removed from the -mm tree.  Its filename was
     acpi-use-acpi_debug_print-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -899,9 +899,10 @@ static void __ref acpi_processor_hotplug
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

git-x86.patch
git-acpi.patch
git-kvm.patch
fix-typo-in-tick-broadcastc.patch

