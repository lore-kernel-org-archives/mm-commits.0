From: akpm@linux-foundation.org
Subject: - provide-acpi_check_mem_region.patch removed from -mm tree
Date: Mon, 05 Nov 2007 22:53:17 -0800
Message-ID: <200711060700.lA6705fP011293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613AbXKFHHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:07:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, bjorn.helgaas@hp.com, khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     Provide acpi_check_{mem_}region
has been removed from the -mm tree.  Its filename was
     provide-acpi_check_mem_region.patch

This patch was dropped because it was folded into small-acpica-extension-to-be-able-to-store-the-name-of.patch

------------------------------------------------------
Subject: Provide acpi_check_{mem_}region
From: Thomas Renninger <trenn@suse.de>

Provide acpi_check_{mem_}region.

Drivers can additionally check against possible ACPI interference by also
invoking this shortly before they call request_region.
If -EBUSY is returned, the driver must not load.
Use acpi_enforce_resources=strict/lax/no options to:
  - strict: let conflicting drivers fail to load with an error message
  - lax:    let conflicting driver work normal with a warning message
  - no:     no functional change at all

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c   |  175 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h |   13 +++
 2 files changed, 186 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/osl.c~provide-acpi_check_mem_region drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~provide-acpi_check_mem_region
+++ a/drivers/acpi/osl.c
@@ -44,6 +44,8 @@
 #include <asm/uaccess.h>
 
 #include <linux/efi.h>
+#include <linux/ioport.h>
+#include <linux/list.h>
 
 #define _COMPONENT		ACPI_OS_SERVICES
 ACPI_MODULE_NAME("osl");
@@ -74,6 +76,18 @@ static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
 
+struct acpi_res_list {
+	resource_size_t start;
+	resource_size_t end;
+	acpi_adr_space_type resource_type; /* IO port, System memory, ...*/
+	char name[5];   /* only can have a length of 4 chars, make use of this
+			   one instead of res->name, no need to kalloc then */
+	struct list_head resource_list;
+};
+
+static LIST_HEAD(resource_list_head);
+static DEFINE_SPINLOCK(acpi_res_lock);
+
 #define	OSI_STRING_LENGTH_MAX 64	/* arbitrary */
 static char osi_additional_string[OSI_STRING_LENGTH_MAX];
 
@@ -1042,6 +1056,127 @@ static int __init acpi_wake_gpes_always_
 
 __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
 
+/* Check of resource interference between native drivers and ACPI
+ * OperationRegions (SystemIO and System Memory only).
+ * IO ports and memory declared in ACPI might be used by the ACPI subsystem
+ * in arbitrary AML code and can interfere with legacy drivers.
+ * acpi_enforce_resources= can be set to:
+ *
+ *   - strict           (2)
+ *     -> further driver trying to access the resources will not load
+ *   - lax (default)    (1)
+ *     -> further driver trying to access the resources will load, but you
+ *     get a system message that something might go wrong...
+ *
+ *   - no               (0)
+ *     -> ACPI Operation Region resources will not be registered
+ *
+ */
+#define ENFORCE_RESOURCES_STRICT 2
+#define ENFORCE_RESOURCES_LAX    1
+#define ENFORCE_RESOURCES_NO     0
+
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+
+static int __init acpi_enforce_resources_setup(char *str)
+{
+	if (str == NULL || *str == '\0')
+		return 0;
+
+	if (!strcmp("strict", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
+	else if (!strcmp("lax", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+	else if (!strcmp("no", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_NO;
+
+	return 1;
+}
+
+__setup("acpi_enforce_resources=", acpi_enforce_resources_setup);
+
+/* Check for resource conflicts between ACPI OperationRegions and native
+ * drivers */
+static int acpi_check_resource_conflict(struct resource *res)
+{
+	struct acpi_res_list *res_list_elem;
+	int ioport;
+	int clash = 0;
+
+	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
+		return 0;
+	if (!(res->flags & IORESOURCE_IO) && !(res->flags & IORESOURCE_MEM))
+		return 0;
+
+	ioport = res->flags & IORESOURCE_IO;
+
+	spin_lock(&acpi_res_lock);
+	list_for_each_entry(res_list_elem, &resource_list_head,
+			    resource_list) {
+		if (ioport && (res_list_elem->resource_type
+			       != ACPI_ADR_SPACE_SYSTEM_IO))
+			continue;
+		if (!ioport && (res_list_elem->resource_type
+				!= ACPI_ADR_SPACE_SYSTEM_MEMORY))
+			continue;
+
+		if (res->end < res_list_elem->start
+		    || res_list_elem->end < res->start)
+			continue;
+		clash = 1;
+		break;
+	}
+	spin_unlock(&acpi_res_lock);
+
+	if (clash) {
+		if (acpi_enforce_resources != ENFORCE_RESOURCES_NO) {
+			printk("%sACPI: %s resource %s [0x%llx-0x%llx]"
+			       " conflicts with ACPI region %s"
+			       " [0x%llx-0x%llx]\n",
+			       acpi_enforce_resources == ENFORCE_RESOURCES_LAX
+			       ? KERN_WARNING : KERN_ERR,
+			       ioport ? "I/O" : "Memory", res->name,
+			       (long long) res->start, (long long) res->end,
+			       res_list_elem->name,
+			       (long long) res_list_elem->start,
+			       (long long) res_list_elem->end);
+			printk(KERN_INFO "ACPI: Device needs an ACPI driver\n");
+		}
+		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
+			return -EBUSY;
+	}
+	return 0;
+}
+
+int acpi_check_region(resource_size_t start, resource_size_t n,
+		      const char *name)
+{
+	struct resource res = {
+		.start = start,
+		.end   = start + n - 1,
+		.name  = name,
+		.flags = IORESOURCE_IO,
+	};
+
+	return acpi_check_resource_conflict(&res);
+}
+EXPORT_SYMBOL(acpi_check_region);
+
+int acpi_check_mem_region(resource_size_t start, resource_size_t n,
+		      const char *name)
+{
+	struct resource res = {
+		.start = start,
+		.end   = start + n - 1,
+		.name  = name,
+		.flags = IORESOURCE_MEM,
+	};
+
+	return acpi_check_resource_conflict(&res);
+
+}
+EXPORT_SYMBOL(acpi_check_mem_region);
+
 /*
  * Acquire a spinlock.
  *
@@ -1199,10 +1334,46 @@ acpi_status
 acpi_os_validate_address (
     u8                   space_id,
     acpi_physical_address   address,
-    acpi_size               length)
+    acpi_size               length,
+    char *name)
 {
+	struct acpi_res_list *res;
+	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
+		return AE_OK;
 
-    return AE_OK;
+	switch (space_id) {
+	case ACPI_ADR_SPACE_SYSTEM_IO:
+	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		/* Only interference checks against SystemIO and SytemMemory
+		   are needed */
+		res = kzalloc(sizeof(struct acpi_res_list), GFP_KERNEL);
+		if (!res)
+			return AE_OK;
+		/* ACPI names are fixed to 4 bytes, still better use strlcpy */
+		strlcpy(res->name, name, 5);
+		res->start = address;
+		res->end = address + length - 1;
+		res->resource_type = space_id;
+		spin_lock(&acpi_res_lock);
+		list_add(&res->resource_list, &resource_list_head);
+		spin_unlock(&acpi_res_lock);
+		pr_debug("Added %s resource: start: 0x%llx, end: 0x%llx, "
+			 "name: %s\n", (space_id == ACPI_ADR_SPACE_SYSTEM_IO)
+			 ? "SystemIO" : "System Memory",
+			 res->start,
+			 (unsigned long)res->end,
+			 (unsigned long)res->name);
+		break;
+	case ACPI_ADR_SPACE_PCI_CONFIG:
+	case ACPI_ADR_SPACE_EC:
+	case ACPI_ADR_SPACE_SMBUS:
+	case ACPI_ADR_SPACE_CMOS:
+	case ACPI_ADR_SPACE_PCI_BAR_TARGET:
+	case ACPI_ADR_SPACE_DATA_TABLE:
+	case ACPI_ADR_SPACE_FIXED_HARDWARE:
+		break;
+	}
+	return AE_OK;
 }
 
 #ifdef CONFIG_DMI
diff -puN include/linux/acpi.h~provide-acpi_check_mem_region include/linux/acpi.h
--- a/include/linux/acpi.h~provide-acpi_check_mem_region
+++ a/include/linux/acpi.h
@@ -123,10 +123,23 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
+int acpi_check_region(resource_size_t start, resource_size_t n,
+		      const char *name);
+int acpi_check_mem_region(resource_size_t start, resource_size_t n,
+		      const char *name);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_mp_config	0
 
+static inline int acpi_check_region(resource_size_t start, resource_size_t n,
+				    const char *name)
+{ return 0; }
+
+static inline int acpi_check_mem_region(resource_size_t start,
+					resource_size_t n, const char *name)
+{ return 0; }
+
 #endif 	/* !CONFIG_ACPI */
 
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);
_

Patches currently in -mm which might be from trenn@suse.de are

git-acpi.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
provide-acpi_check_mem_region.patch
export-acpi_check_resource_conflict.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
