From: akpm@linux-foundation.org
Subject: - x86-check-boundary-in-count-setup_resource-called-by.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:35 -0800
Message-ID: <200711192316.lAJNGZ8t001781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbXKSX1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:27:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@sun.com, gary.hade@us.ibm.com, gregkh@suse.de, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     x86: check boundary in count/setup_resource called by get_current_resources()
has been removed from the -mm tree.  Its filename was
     x86-check-boundary-in-count-setup_resource-called-by.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: check boundary in count/setup_resource called by get_current_resources()
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
info->bus->resource[info->res_num] = res will not beyond of bus resource
array when acpi returns too many resource entries.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Gary Hade <gary.hade@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/acpi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/pci/acpi.c~x86-check-boundary-in-count-setup_resource-called-by arch/x86/pci/acpi.c
--- a/arch/x86/pci/acpi.c~x86-check-boundary-in-count-setup_resource-called-by
+++ a/arch/x86/pci/acpi.c
@@ -77,6 +77,9 @@ count_resource(struct acpi_resource *acp
 	struct acpi_resource_address64 addr;
 	acpi_status status;
 
+	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
+		return AE_OK;
+
 	status = resource_to_addr(acpi_res, &addr);
 	if (ACPI_SUCCESS(status))
 		info->res_num++;
@@ -93,6 +96,9 @@ setup_resource(struct acpi_resource *acp
 	unsigned long flags;
 	struct resource *root;
 
+	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
+		return AE_OK;
+
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
kernel-printkc-concerns-about-the-console-handover.patch
