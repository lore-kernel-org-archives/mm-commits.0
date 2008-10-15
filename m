From: akpm@linux-foundation.org
Subject: - acpi-fix-fadt-parsing-v3.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:13:58 -0700
Message-ID: <200810152113.m9FLDwU5005651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbYJOVOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, lenb@kernel.org, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: fix FADT parsing
has been removed from the -mm tree.  Its filename was
     acpi-fix-fadt-parsing-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: fix FADT parsing
From: "Jan Beulich" <jbeulich@novell.com>

The (1.0 inherited) separate length fields in the FADT are byte granular. 
Further, PM1a/b may have distinct lengths (if using the v2 fields was
okay) and may live in distinct address spaces.  acpi_tb_convert_fadt()
should account for all of these conditions.

Apart from these changes I'm puzzled by the fact that, not just for
acpi_gbl_xpm1{a,b}_enable, acpi_hw_low_level_{read,write}() get an
explicit size passed rather than using the size found in the passed GAS. 
What happens on a platform that defines PM1{a,b} wider than 16 bits?  Of
course, acpi_hw_low_level_{read,write}() at present are entirely
un-prepared to deal with sizes other than 8, 16, or 32, not to speak of a
non-zero bit_offset or access_width...

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Moore, Robert" <robert.moore@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables/tbfadt.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/tables/tbfadt.c~acpi-fix-fadt-parsing-v3 drivers/acpi/tables/tbfadt.c
--- a/drivers/acpi/tables/tbfadt.c~acpi-fix-fadt-parsing-v3
+++ a/drivers/acpi/tables/tbfadt.c
@@ -50,7 +50,7 @@ ACPI_MODULE_NAME("tbfadt")
 /* Local prototypes */
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address);
+			     u8 byte_width, u64 address);
 
 static void acpi_tb_convert_fadt(void);
 
@@ -111,7 +111,7 @@ static struct acpi_fadt_info fadt_info_t
  * FUNCTION:    acpi_tb_init_generic_address
  *
  * PARAMETERS:  generic_address     - GAS struct to be initialized
- *              bit_width           - Width of this register
+ *              byte_width          - Width of this register
  *              Address             - Address of the register
  *
  * RETURN:      None
@@ -124,7 +124,7 @@ static struct acpi_fadt_info fadt_info_t
 
 static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
-			     u8 bit_width, u64 address)
+			     u8 byte_width, u64 address)
 {
 
 	/*
@@ -136,7 +136,7 @@ acpi_tb_init_generic_address(struct acpi
 	/* All other fields are byte-wide */
 
 	generic_address->space_id = ACPI_ADR_SPACE_SYSTEM_IO;
-	generic_address->bit_width = bit_width;
+	generic_address->bit_width = byte_width << 3;
 	generic_address->bit_offset = 0;
 	generic_address->access_width = 0;
 }
@@ -342,9 +342,20 @@ static void acpi_tb_convert_fadt(void)
 	 * useful to calculate them once, here.
 	 *
 	 * The PM event blocks are split into two register blocks, first is the
-	 * PM Status Register block, followed immediately by the PM Enable Register
-	 * block. Each is of length (pm1_event_length/2)
+	 * PM Status Register block, followed immediately by the PM Enable
+	 * Register block. Each is of length (xpm1x_event_block.bit_width/2).
+	 *
+	 * On various systems the v2 fields (and particularly the bit widths)
+	 * cannot be relied upon, though. Hence resort to using the v1 length
+	 * here (and warn about the inconsistency).
 	 */
+	if (acpi_gbl_FADT.xpm1a_event_block.bit_width
+	    != acpi_gbl_FADT.pm1_event_length * 8)
+		printk(KERN_WARNING "FADT: "
+		       "X_PM1a_EVT_BLK.bit_width (%u) does not match"
+		       " PM1_EVT_LEN (%u)\n",
+		       acpi_gbl_FADT.xpm1a_event_block.bit_width,
+		       acpi_gbl_FADT.pm1_event_length);
 	pm1_register_length = (u8) ACPI_DIV_2(acpi_gbl_FADT.pm1_event_length);
 
 	/* The PM1A register block is required */
@@ -360,13 +371,20 @@ static void acpi_tb_convert_fadt(void)
 	/* The PM1B register block is optional, ignore if not present */
 
 	if (acpi_gbl_FADT.xpm1b_event_block.address) {
+		if (acpi_gbl_FADT.xpm1b_event_block.bit_width
+		    != acpi_gbl_FADT.pm1_event_length * 8)
+			printk(KERN_WARNING "FADT: "
+			       "X_PM1b_EVT_BLK.bit_width (%u) does not match"
+			       " PM1_EVT_LEN (%u)\n",
+			       acpi_gbl_FADT.xpm1b_event_block.bit_width,
+			       acpi_gbl_FADT.pm1_event_length);
 		acpi_tb_init_generic_address(&acpi_gbl_xpm1b_enable,
 					     pm1_register_length,
 					     (acpi_gbl_FADT.xpm1b_event_block.
 					      address + pm1_register_length));
 		/* Don't forget to copy space_id of the GAS */
 		acpi_gbl_xpm1b_enable.space_id =
-		    acpi_gbl_FADT.xpm1a_event_block.space_id;
+		    acpi_gbl_FADT.xpm1b_event_block.space_id;
 
 	}
 }
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-acpi.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

