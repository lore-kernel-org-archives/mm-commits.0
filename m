From: akpm@linux-foundation.org
Subject: - acpi-adjust-register-handling.patch removed from -mm tree
Date: Mon, 23 Jun 2008 12:46:06 -0700
Message-ID: <200806231946.m5NJk67m013013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYFWTqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 15:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: adjust register handling
has been removed from the -mm tree.  Its filename was
     acpi-adjust-register-handling.patch

This patch was dropped because of the customary crap

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: adjust register handling
From: "Jan Beulich" <jbeulich@novell.com>

acpi_hw_low_level_{read,write}() have no need to accept a NULL reg argument
anymore (all callers use addresses of or derived from ACPI globals), and it
really should always have been considered an error to call these functions in
such a way.

Additionally acpi_hw_low_level_read() should initialize the value read in all
cases when it returns successfully.

Also use ACPI_GPE_REGISTER_WIDTH where possible rather than a plain number.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/hardware/hwgpe.c  |   15 ++++++++-------
 drivers/acpi/hardware/hwregs.c |    6 +++---
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/hardware/hwgpe.c~acpi-adjust-register-handling drivers/acpi/hardware/hwgpe.c
--- a/drivers/acpi/hardware/hwgpe.c~acpi-adjust-register-handling
+++ a/drivers/acpi/hardware/hwgpe.c
@@ -84,7 +84,8 @@ acpi_hw_write_gpe_enable_reg(struct acpi
 
 	/* Write the entire GPE (runtime) enable register */
 
-	status = acpi_hw_low_level_write(8, gpe_register_info->enable_for_run,
+	status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
+					 gpe_register_info->enable_for_run,
 					 &gpe_register_info->enable_address);
 
 	return (status);
@@ -118,7 +119,7 @@ acpi_status acpi_hw_clear_gpe(struct acp
 	 * Write a one to the appropriate bit in the status register to
 	 * clear this GPE.
 	 */
-	status = acpi_hw_low_level_write(8, register_bit,
+	status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, register_bit,
 					 &gpe_event_info->register_info->
 					 status_address);
 
@@ -181,7 +182,7 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 	/* GPE currently active (status bit == 1)? */
 
 	status =
-	    acpi_hw_low_level_read(8, &in_byte,
+	    acpi_hw_low_level_read(ACPI_GPE_REGISTER_WIDTH, &in_byte,
 				   &gpe_register_info->status_address);
 	if (ACPI_FAILURE(status)) {
 		goto unlock_and_exit;
@@ -226,7 +227,7 @@ acpi_hw_disable_gpe_block(struct acpi_gp
 
 		/* Disable all GPEs in this register */
 
-		status = acpi_hw_low_level_write(8, 0x00,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, 0x00,
 						 &gpe_block->register_info[i].
 						 enable_address);
 		if (ACPI_FAILURE(status)) {
@@ -263,7 +264,7 @@ acpi_hw_clear_gpe_block(struct acpi_gpe_
 
 		/* Clear status on all GPEs in this register */
 
-		status = acpi_hw_low_level_write(8, 0xFF,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, 0xFF,
 						 &gpe_block->register_info[i].
 						 status_address);
 		if (ACPI_FAILURE(status)) {
@@ -307,7 +308,7 @@ acpi_hw_enable_runtime_gpe_block(struct 
 		/* Enable all "runtime" GPEs in this register */
 
 		status =
-		    acpi_hw_low_level_write(8,
+		    acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
 					    gpe_block->register_info[i].
 					    enable_for_run,
 					    &gpe_block->register_info[i].
@@ -350,7 +351,7 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 
 		/* Enable all "wake" GPEs in this register */
 
-		status = acpi_hw_low_level_write(8,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
 						 gpe_block->register_info[i].
 						 enable_for_wake,
 						 &gpe_block->register_info[i].
diff -puN drivers/acpi/hardware/hwregs.c~acpi-adjust-register-handling drivers/acpi/hardware/hwregs.c
--- a/drivers/acpi/hardware/hwregs.c~acpi-adjust-register-handling
+++ a/drivers/acpi/hardware/hwregs.c
@@ -745,8 +745,9 @@ acpi_hw_low_level_read(u32 width, u32 * 
 	 * because the PM1A/B code must not fail if B isn't present.
 	 */
 	if (!reg) {
-		return (AE_OK);
+		return (AE_BAD_PARAMETER);
 	}
+	*value = 0;
 
 	/* Get a local copy of the address. Handles possible alignment issues */
 
@@ -754,7 +755,6 @@ acpi_hw_low_level_read(u32 width, u32 * 
 	if (!address) {
 		return (AE_OK);
 	}
-	*value = 0;
 
 	/*
 	 * Two address spaces supported: Memory or IO.
@@ -815,7 +815,7 @@ acpi_hw_low_level_write(u32 width, u32 v
 	 * because the PM1A/B code must not fail if B isn't present.
 	 */
 	if (!reg) {
-		return (AE_OK);
+		return (AE_BAD_PARAMETER);
 	}
 
 	/* Get a local copy of the address. Handles possible alignment issues */
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
acpi-fix-fadt-parsing.patch
acpi-adjust-register-handling.patch
acpi-adjust-_acpi_modulefunction_name-definitions.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch

