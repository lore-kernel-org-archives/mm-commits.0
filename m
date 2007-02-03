From: akpm@osdl.org
Subject: + acpi-fix-tbfadt.patch added to -mm tree
Date: Fri, 02 Feb 2007 17:12:35 -0800
Message-ID: <200702030112.l131CZjr022890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47663 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946172AbXBCBN5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 20:13:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexey.y.starikovskiy@linux.intel.com, bob.picco@hp.com, lenb@kernel.org


The patch titled
     acpi: fix tbfadt
has been added to the -mm tree.  Its filename is
     acpi-fix-tbfadt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: fix tbfadt
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>

Copy space_id of GAS structure to newly created GAS.

Cc: Bob Picco <bob.picco@hp.com>
CC: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/tables/tbfadt.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/acpi/tables/tbfadt.c~acpi-fix-tbfadt drivers/acpi/tables/tbfadt.c
--- a/drivers/acpi/tables/tbfadt.c~acpi-fix-tbfadt
+++ a/drivers/acpi/tables/tbfadt.c
@@ -333,6 +333,8 @@ static void acpi_tb_convert_fadt(void)
 				     pm1_register_length,
 				     (acpi_gbl_FADT.xpm1a_event_block.address +
 				      pm1_register_length));
+	/* Don't forget to copy space_id of the GAS */
+	acpi_gbl_xpm1a_enable.space_id = acpi_gbl_FADT.xpm1a_event_block.space_id;
 
 	/* The PM1B register block is optional, ignore if not present */
 
@@ -341,6 +343,9 @@ static void acpi_tb_convert_fadt(void)
 					     pm1_register_length,
 					     (acpi_gbl_FADT.xpm1b_event_block.
 					      address + pm1_register_length));
+		/* Don't forget to copy space_id of the GAS */
+		acpi_gbl_xpm1b_enable.space_id = acpi_gbl_FADT.xpm1a_event_block.space_id;
+
 	}
 }
 
_

Patches currently in -mm which might be from alexey.y.starikovskiy@linux.intel.com are

git-acpi.patch
acpi-fix-tbfadt.patch
swsusp-change-code-order-in-diskc-fix.patch
