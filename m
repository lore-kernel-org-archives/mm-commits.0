From: akpm@linux-foundation.org
Subject: + export-acpi_check_resource_conflict.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:51:39 -0700
Message-ID: <200710250351.l9P3pdSL030387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbXJYDwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:52:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, jdelvare@suse.de, khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com


The patch titled
     Export acpi_check_resource_conflict
has been added to the -mm tree.  Its filename is
     export-acpi_check_resource_conflict.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c   |    3 ++-
 include/linux/acpi.h |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~export-acpi_check_resource_conflict drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~export-acpi_check_resource_conflict
+++ a/drivers/acpi/osl.c
@@ -1097,7 +1097,7 @@ __setup("acpi_enforce_resources=", acpi_
 
 /* Check for resource conflicts between ACPI OperationRegions and native
  * drivers */
-static int acpi_check_resource_conflict(struct resource *res)
+int acpi_check_resource_conflict(struct resource *res)
 {
 	struct acpi_res_list *res_list_elem;
 	int ioport;
@@ -1147,6 +1147,7 @@ static int acpi_check_resource_conflict(
 	}
 	return 0;
 }
+EXPORT_SYMBOL(acpi_check_resource_conflict);
 
 int acpi_check_region(resource_size_t start, resource_size_t n,
 		      const char *name)
diff -puN include/linux/acpi.h~export-acpi_check_resource_conflict include/linux/acpi.h
--- a/include/linux/acpi.h~export-acpi_check_resource_conflict
+++ a/include/linux/acpi.h
@@ -123,6 +123,8 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
+int acpi_check_resource_conflict(struct resource *res);
+
 int acpi_check_region(resource_size_t start, resource_size_t n,
 		      const char *name);
 int acpi_check_mem_region(resource_size_t start, resource_size_t n,
@@ -132,6 +134,9 @@ int acpi_check_mem_region(resource_size_
 
 #define acpi_mp_config	0
 
+static inline int acpi_check_resource_conflict(struct resource *res)
+{ return 0; }
+
 static inline int acpi_check_region(resource_size_t start, resource_size_t n,
 				    const char *name)
 { return 0; }
_

Patches currently in -mm which might be from trenn@suse.de are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
provide-acpi_check_mem_region.patch
provide-acpi_check_mem_region-checkpatch-fixes.patch
export-acpi_check_resource_conflict.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
