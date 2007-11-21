From: akpm@linux-foundation.org
Subject: - export-acpi_check_resource_conflict-update.patch removed from -mm tree
Date: Wed, 21 Nov 2007 14:49:12 -0800
Message-ID: <200711212249.lALMnDMo012963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXKUWtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 17:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, mm-commits@vger.kernel.org


The patch titled
     ACPI: Export acpi_check_resource_conflict() (update #2)
has been removed from the -mm tree.  Its filename was
     export-acpi_check_resource_conflict-update.patch

This patch was dropped because it was folded into export-acpi_check_resource_conflict.patch

------------------------------------------------------
Subject: ACPI: Export acpi_check_resource_conflict() (update #2)
From: Jean Delvare <jdelvare@suse.de>

Export acpi_check_resource_conflict(), sometimes drivers already have
a struct resource at hand so no need to use the wrappers to build a new
one.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/acpi.h~export-acpi_check_resource_conflict-update include/linux/acpi.h
--- a/include/linux/acpi.h~export-acpi_check_resource_conflict-update
+++ a/include/linux/acpi.h
@@ -25,8 +25,8 @@
 #ifndef _LINUX_ACPI_H
 #define _LINUX_ACPI_H
 
+#include <linux/ioport.h>	/* for struct resource */
 
-#include <linux/ioport.h>
 #ifdef	CONFIG_ACPI
 
 #ifndef _LINUX
@@ -220,6 +220,11 @@ static inline int acpi_boot_table_init(v
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
@@ -232,8 +237,5 @@ static inline int acpi_check_mem_region(
 	return 0;
 }
 
-static inline int acpi_check_resource_conflict(struct resource *res)
-{ return 0; }
-
 #endif	/* CONFIG_ACPI */
 #endif	/*_LINUX_ACPI_H*/
_

Patches currently in -mm which might be from jdelvare@suse.de are

acpi-cleanup-linux-acpih.patch
export-acpi_check_resource_conflict.patch
export-acpi_check_resource_conflict-update.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
