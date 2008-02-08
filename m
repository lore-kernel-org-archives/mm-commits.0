From: akpm@linux-foundation.org
Subject: - export-acpi_check_resource_conflict.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:30 -0800
Message-ID: <200802080810.m188ABdu014921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932839AbYBHIU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, bjorn.helgaas@hp.com, jdelvare@suse.de, khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     Export acpi_check_resource_conflict
has been removed from the -mm tree.  Its filename was
     export-acpi_check_resource_conflict.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Export acpi_check_resource_conflict
From: Thomas Renninger <trenn@suse.de>

Export acpi_check_resource_conflict(), sometimes drivers already have
a struct resource at hand so no need to use the wrappers to build a new
one.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c   |    3 ++-
 include/linux/acpi.h |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~export-acpi_check_resource_conflict drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~export-acpi_check_resource_conflict
+++ a/drivers/acpi/osl.c
@@ -1161,7 +1161,7 @@ __setup("acpi_enforce_resources=", acpi_
 
 /* Check for resource conflicts between ACPI OperationRegions and native
  * drivers */
-static int acpi_check_resource_conflict(struct resource *res)
+int acpi_check_resource_conflict(struct resource *res)
 {
 	struct acpi_res_list *res_list_elem;
 	int ioport;
@@ -1211,6 +1211,7 @@ static int acpi_check_resource_conflict(
 	}
 	return 0;
 }
+EXPORT_SYMBOL(acpi_check_resource_conflict);
 
 int acpi_check_region(resource_size_t start, resource_size_t n,
 		      const char *name)
diff -puN include/linux/acpi.h~export-acpi_check_resource_conflict include/linux/acpi.h
--- a/include/linux/acpi.h~export-acpi_check_resource_conflict
+++ a/include/linux/acpi.h
@@ -25,6 +25,7 @@
 #ifndef _LINUX_ACPI_H
 #define _LINUX_ACPI_H
 
+#include <linux/ioport.h>	/* for struct resource */
 
 #ifdef	CONFIG_ACPI
 
@@ -223,6 +224,8 @@ extern int pnpacpi_disabled;
 #define PXM_INVAL	(-1)
 #define NID_INVAL	(-1)
 
+int acpi_check_resource_conflict(struct resource *res);
+
 int acpi_check_region(resource_size_t start, resource_size_t n,
 		      const char *name);
 int acpi_check_mem_region(resource_size_t start, resource_size_t n,
@@ -240,6 +243,11 @@ static inline int acpi_boot_table_init(v
 	return 0;
 }
 
+static inline int acpi_check_resource_conflict(struct resource *res)
+{
+	return 0;
+}
+
 static inline int acpi_check_region(resource_size_t start, resource_size_t n,
 				    const char *name)
 {
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
