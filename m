From: akpm@linux-foundation.org
Subject: - acpi-use-__init-on-everything-in-tables-tbfadtc.patch removed from -mm tree
Date: Thu, 01 May 2008 12:36:23 -0700
Message-ID: <200805011936.m41JaN1r021769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763044AbYEATgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: use __init* on everything in tables/tbfadt.c
has been removed from the -mm tree.  Its filename was
     acpi-use-__init-on-everything-in-tables-tbfadtc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: use __init* on everything in tables/tbfadt.c
From: "Jan Beulich" <jbeulich@novell.com>

All of the code in this file is use at boot time only.

Additionally, acpi_tb_create_local_fadt() doesn't need a globally visible
declaration.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables/tbfadt.c |   15 +++++++++------
 include/acpi/actables.h      |    2 --
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/tables/tbfadt.c~acpi-use-__init-on-everything-in-tables-tbfadtc drivers/acpi/tables/tbfadt.c
--- a/drivers/acpi/tables/tbfadt.c~acpi-use-__init-on-everything-in-tables-tbfadtc
+++ a/drivers/acpi/tables/tbfadt.c
@@ -52,6 +52,8 @@ static void inline
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 bit_width, u64 address);
 
+static void acpi_tb_create_local_fadt(struct acpi_table_header *, u32 length);
+
 static void acpi_tb_convert_fadt(void);
 
 static void acpi_tb_validate_fadt(void);
@@ -59,7 +61,7 @@ static void acpi_tb_validate_fadt(void);
 /* Table for conversion of FADT to common internal format and FADT validation */
 
 typedef struct acpi_fadt_info {
-	char *name;
+	const char *name;
 	u8 target;
 	u8 source;
 	u8 length;
@@ -70,7 +72,7 @@ typedef struct acpi_fadt_info {
 #define ACPI_FADT_REQUIRED          1
 #define ACPI_FADT_SEPARATE_LENGTH   2
 
-static struct acpi_fadt_info fadt_info_table[] = {
+static struct acpi_fadt_info __initdata fadt_info_table[] = {
 	{"Pm1aEventBlock", ACPI_FADT_OFFSET(xpm1a_event_block),
 	 ACPI_FADT_OFFSET(pm1a_event_block),
 	 ACPI_FADT_OFFSET(pm1_event_length), ACPI_FADT_REQUIRED},
@@ -155,7 +157,7 @@ acpi_tb_init_generic_address(struct acpi
  *
  ******************************************************************************/
 
-void acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags)
+void __init acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags)
 {
 	u32 length;
 	struct acpi_table_header *table;
@@ -215,7 +217,8 @@ void acpi_tb_parse_fadt(acpi_native_uint
  *
  ******************************************************************************/
 
-void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
+static void __init
+acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
 {
 
 	/*
@@ -276,7 +279,7 @@ void acpi_tb_create_local_fadt(struct ac
  *
  ******************************************************************************/
 
-static void acpi_tb_convert_fadt(void)
+static void __init acpi_tb_convert_fadt(void)
 {
 	u8 pm1_register_length;
 	struct acpi_generic_address *target;
@@ -397,7 +400,7 @@ static void acpi_tb_convert_fadt(void)
  *
  ******************************************************************************/
 
-static void acpi_tb_validate_fadt(void)
+static void __init acpi_tb_validate_fadt(void)
 {
 	u32 *address32;
 	struct acpi_generic_address *address64;
diff -puN include/acpi/actables.h~acpi-use-__init-on-everything-in-tables-tbfadtc include/acpi/actables.h
--- a/include/acpi/actables.h~acpi-use-__init-on-everything-in-tables-tbfadtc
+++ a/include/acpi/actables.h
@@ -51,8 +51,6 @@ acpi_status acpi_allocate_root_table(u32
  */
 void acpi_tb_parse_fadt(acpi_native_uint table_index, u8 flags);
 
-void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length);
