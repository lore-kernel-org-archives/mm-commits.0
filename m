From: akpm@linux-foundation.org
Subject: [merged] acpi-annote-acpi_processor_add-with-__cpuinit.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:42 -0800
Message-ID: <200911091954.nA9Jsgln022063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZKITzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: Annote acpi_processor_add with __cpuinit
has been removed from the -mm tree.  Its filename was
     acpi-annote-acpi_processor_add-with-__cpuinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: Annote acpi_processor_add with __cpuinit
From: Rakib Mullick <rakib.mullick@gmail.com>

Annote acpi_processor_add with cpuinit since it calls a cpuinit function
acpi_processor_power_init and fixes a section mismatch warning.

 We were warned by the following warning:

 LD      drivers/acpi/processor.o
WARNING: drivers/acpi/processor.o(.text+0x1829): Section mismatch in
reference from the function acpi_processor_add() to the function
.cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/acpi/processor_core.c~acpi-annote-acpi_processor_add-with-__cpuinit drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-annote-acpi_processor_add-with-__cpuinit
+++ a/drivers/acpi/processor_core.c
@@ -770,7 +770,7 @@ static struct notifier_block acpi_cpu_no
 	    .notifier_call = acpi_cpu_soft_notify,
 };
 
-static int acpi_processor_add(struct acpi_device *device)
+static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch

