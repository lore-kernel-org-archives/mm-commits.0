From: akpm@linux-foundation.org
Subject: + acpi-dont-create-empty-filenames-in-sys-firmware-acpi-tables.patch added to -mm tree
Date: Thu, 11 Sep 2008 12:30:05 -0700
Message-ID: <200809111930.m8BJU6jY012531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYIKTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nokos@gmx.net, len.brown@intel.com, ming.m.lin@intel.com, robert.moore@intel.com, stable@kernel.org


The patch titled
     acpi: don't create empty filenames in /sys/firmware/acpi/tables
has been added to the -mm tree.  Its filename is
     acpi-dont-create-empty-filenames-in-sys-firmware-acpi-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: don't create empty filenames in /sys/firmware/acpi/tables
From: Peter Gruber <nokos@gmx.net>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=11539

Since commit bc45b1d39a925b56796bebf8a397a0491489d85c acpi tables are
allowed to have an empty signature and /sys/firmware/acpi/tables uses the
signature as filename.  Applications using naive recursion through /sys
loop forever.  A possible solution would be: (replacing the zero length
filename with the string "NULL")

Cc: Bob Moore <robert.moore@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/system.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/system.c~acpi-dont-create-empty-filenames-in-sys-firmware-acpi-tables drivers/acpi/system.c
--- a/drivers/acpi/system.c~acpi-dont-create-empty-filenames-in-sys-firmware-acpi-tables
+++ a/drivers/acpi/system.c
@@ -78,9 +78,15 @@ static ssize_t acpi_table_show(struct ko
 	    container_of(bin_attr, struct acpi_table_attr, attr);
 	struct acpi_table_header *table_header = NULL;
 	acpi_status status;
+	char name[ACPI_NAME_SIZE];
+
+	if (strncmp(table_attr->name, "NULL", 4))
+		memcpy(name, table_attr->name, ACPI_NAME_SIZE);
+	else
+		memcpy(name, "\0\0\0\0", 4);
 
 	status =
-	    acpi_get_table(table_attr->name, table_attr->instance,
+	    acpi_get_table(name, table_attr->instance,
 			   &table_header);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
@@ -95,21 +101,24 @@ static void acpi_table_attr_init(struct 
 	struct acpi_table_header *header = NULL;
 	struct acpi_table_attr *attr = NULL;
 
-	memcpy(table_attr->name, table_header->signature, ACPI_NAME_SIZE);
+	if (table_header->signature[0] != '\0')
+		memcpy(table_attr->name, table_header->signature,
+			ACPI_NAME_SIZE);
+	else
+		memcpy(table_attr->name, "NULL", 4);
 
 	list_for_each_entry(attr, &acpi_table_attr_list, node) {
-		if (!memcmp(table_header->signature, attr->name,
-			    ACPI_NAME_SIZE))
+		if (!memcmp(table_attr->name, attr->name, ACPI_NAME_SIZE))
 			if (table_attr->instance < attr->instance)
 				table_attr->instance = attr->instance;
 	}
 	table_attr->instance++;
 
 	if (table_attr->instance > 1 || (table_attr->instance == 1 &&
-					 !acpi_get_table(table_header->
-							 signature, 2,
-							 &header)))
-		sprintf(table_attr->name + 4, "%d", table_attr->instance);
+					!acpi_get_table
+					(table_header->signature, 2, &header)))
+		sprintf(table_attr->name + ACPI_NAME_SIZE, "%d",
+			table_attr->instance);
 
 	table_attr->attr.size = 0;
 	table_attr->attr.read = acpi_table_show;
_

Patches currently in -mm which might be from nokos@gmx.net are

acpi-dont-create-empty-filenames-in-sys-firmware-acpi-tables.patch

