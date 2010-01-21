From: akpm@linux-foundation.org
Subject: [alternative-merged] acpi-fix-section-mismatch.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:20:11 -0800
Message-ID: <201001212120.o0LLKB9V030209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274Ab0AUVU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:20:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, achiang@hp.com, lenb@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: fix section mismatch
has been removed from the -mm tree.  Its filename was
     acpi-fix-section-mismatch.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix section mismatch
From: Jeff Mahoney <jeffm@suse.com>

acpi_early_processor_set_pdc() uses processor_idle_dmi_table(), which is
marked __cpuinitdata.  It's only called by acpi_bus_init, which is __init.
We mark it __cpuinit.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_pdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_pdc.c~acpi-fix-section-mismatch drivers/acpi/processor_pdc.c
--- a/drivers/acpi/processor_pdc.c~acpi-fix-section-mismatch
+++ a/drivers/acpi/processor_pdc.c
@@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 l
 	return AE_OK;
 }
 
-void acpi_early_processor_set_pdc(void)
+void __cpuinit acpi_early_processor_set_pdc(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
acpi-fix-section-mismatch.patch
drivers-scsi-hpsac-fix-section-mismatch.patch

