From: akpm@osdl.org
Subject: - acpi-clear-gpe-before-disabling-it.patch removed from -mm tree
Date: Fri, 22 Dec 2006 20:15:32 -0800
Message-ID: <200612230415.kBN4FWvk007175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbWLWEPi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 23:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.morrow@amd.com, jordan.crouse@amd.com, len.brown@intel.com, luming.yu@intel.com, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: Clear GPE before disabling it
has been removed from the -mm tree.  Its filename was
     acpi-clear-gpe-before-disabling-it.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: ACPI: Clear GPE before disabling it
From: William Morrow <william.morrow@amd.com>

On some BIOSen, the GPE bit will remain set even if it is disabled,
resulting in a interrupt storm.  This patch clears the bit before disabling
it.

Signed-off-by: William Morrow <william.morrow@amd.com>
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Yu, Luming" <luming.yu@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: "Moore, Robert" <robert.moore@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/events/evgpe.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/events/evgpe.c~acpi-clear-gpe-before-disabling-it drivers/acpi/events/evgpe.c
--- a/drivers/acpi/events/evgpe.c~acpi-clear-gpe-before-disabling-it
+++ a/drivers/acpi/events/evgpe.c
@@ -677,10 +677,22 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_eve
 	case ACPI_GPE_DISPATCH_METHOD:
 
 		/*
-		 * Disable GPE, so it doesn't keep firing before the method has a
+		 * Clear GPE, so it doesn't keep firing before the method has a
 		 * chance to run.
 		 */
+		status = acpi_hw_clear_gpe(gpe_event_info);
+		if (ACPI_FAILURE(status)) {
+			ACPI_EXCEPTION((AE_INFO, status,
+					"Unable to clear GPE[%2X]",
+					gpe_number));
+			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
+		}
+		/*
+		 * Disable GPE, so it doesn't keep happen again.
+		 */
+
 		status = acpi_ev_disable_gpe(gpe_event_info);
+
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
 					"Unable to disable GPE[%2X]",
_

Patches currently in -mm which might be from william.morrow@amd.com are

acpi-clear-gpe-before-disabling-it.patch

