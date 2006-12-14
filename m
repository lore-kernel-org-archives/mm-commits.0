From: akpm@osdl.org
Subject: - add-support-for-acpi_load_table-acpi_unload_table_id.patch removed from -mm tree
Date: Thu, 14 Dec 2006 14:42:19 -0800
Message-ID: <200612142242.kBEMgLAg031125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964972AbWLNWmc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 17:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpk@sgi.com, ayoung@sgi.com, greg@kroah.com, len.brown@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add support for acpi_load_table/acpi_unload_table_id
has been removed from the -mm tree.  Its filename was
     add-support-for-acpi_load_table-acpi_unload_table_id.patch

This patch was dropped because other acpi changes trashed it

------------------------------------------------------
Subject: Add support for acpi_load_table/acpi_unload_table_id
From: John Keller <jpk@sgi.com>

Make acpi_load_table() available for use by removing it from the #ifdef
ACPI_FUTURE_USAGE.

Also add a new routine used to unload an ACPI table of a given type and "id" -
acpi_unload_table_id().  The implementation of this new routine was almost a
direct copy of existing routine acpi_unload_table() - only difference being
that it only removes a specific table id instead of ALL tables of a given
type.  The SN hotplug driver (sgi_hotplug.c) now uses both of these interfaces
to dynamically load and unload SSDT ACPI tables.

Also, a few other ACPI routines now used by the SN hotplug driver are exported
(since the driver can be a loadable module):

 acpi_ns_map_handle_to_node
 acpi_ns_convert_entry_to_handle
 acpi_ns_get_next_node

Signed-off-by: Aaron Young <ayoung@sgi.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/namespace/nsxfobj.c |   44 +++++++++++++++++++++++
 drivers/acpi/tables/tbxface.c    |   54 ++++++++++++++++++++++++++++-
 include/acpi/acpixf.h            |    7 ++-
 3 files changed, 102 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/namespace/nsutils.c~add-support-for-acpi_load_table-acpi_unload_table_id drivers/acpi/namespace/nsutils.c
diff -puN drivers/acpi/namespace/nswalk.c~add-support-for-acpi_load_table-acpi_unload_table_id drivers/acpi/namespace/nswalk.c
diff -puN drivers/acpi/tables/tbxface.c~add-support-for-acpi_load_table-acpi_unload_table_id drivers/acpi/tables/tbxface.c
--- a/drivers/acpi/tables/tbxface.c~add-support-for-acpi_load_table-acpi_unload_table_id
+++ a/drivers/acpi/tables/tbxface.c
@@ -123,7 +123,6 @@ acpi_status acpi_load_tables(void)
 
 ACPI_EXPORT_SYMBOL(acpi_load_tables)
 
-#ifdef ACPI_FUTURE_USAGE
 /*******************************************************************************
  *
  * FUNCTION:    acpi_load_table
@@ -221,6 +220,59 @@ ACPI_EXPORT_SYMBOL(acpi_load_table)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_unload_table_id
+ *
+ * PARAMETERS:  table_type    - Type of table to be unloaded
+ *              id            - Owner ID of the table to be removed.
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This routine is used to force the unload of a table (by id)
+ *
+ ******************************************************************************/
+acpi_status acpi_unload_table_id(acpi_table_type table_type, acpi_owner_id id)
+{
+	struct acpi_table_desc *table_desc;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_unload_table);
+
+	/* Parameter validation */
+	if (table_type > ACPI_TABLE_ID_MAX)
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+
+	/* Find table from the requested type list */
+	table_desc = acpi_gbl_table_lists[table_type].next;
+	while (table_desc && table_desc->owner_id != id)
+		table_desc = table_desc->next;
+
+	if (!table_desc)
+		return_ACPI_STATUS(AE_NOT_EXIST);
+
+	/*
+	 * Delete all namespace objects owned by this table. Note that these
+	 * objects can appear anywhere in the namespace by virtue of the AML
+	 * "Scope" operator. Thus, we need to track ownership by an ID, not
+	 * simply a position within the hierarchy
+	 */
+	acpi_ns_delete_namespace_by_owner(table_desc->owner_id);
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
+	(void)acpi_tb_uninstall_table(table_desc);
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
+
+#ifdef ACPI_FUTURE_USAGE
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_unload_table
  *
  * PARAMETERS:  table_type    - Type of table to be unloaded
diff -puN include/acpi/acpixf.h~add-support-for-acpi_load_table-acpi_unload_table_id include/acpi/acpixf.h
--- a/include/acpi/acpixf.h~add-support-for-acpi_load_table-acpi_unload_table_id
+++ a/include/acpi/acpixf.h
@@ -97,11 +97,12 @@ acpi_find_root_pointer(u32 flags, struct
 
 acpi_status acpi_load_tables(void);
 
-#ifdef ACPI_FUTURE_USAGE
 acpi_status acpi_load_table(struct acpi_table_header *table_ptr);
 
-acpi_status acpi_unload_table(acpi_table_type table_type);
+acpi_status acpi_unload_table_id(acpi_table_type table_type, acpi_owner_id id);
 
+#ifdef ACPI_FUTURE_USAGE
+acpi_status acpi_unload_table(acpi_table_type table_type);
 acpi_status
 acpi_get_table_header(acpi_table_type table_type,
 		      u32 instance, struct acpi_table_header *out_table_header);
@@ -180,6 +181,8 @@ acpi_get_next_object(acpi_object_type ty
 
 acpi_status acpi_get_type(acpi_handle object, acpi_object_type * out_type);
 
+acpi_status acpi_get_id(acpi_handle object, acpi_owner_id * out_type);
+
 acpi_status acpi_get_parent(acpi_handle object, acpi_handle * out_handle);
 
 /*
diff -puN drivers/acpi/namespace/nsxfobj.c~add-support-for-acpi_load_table-acpi_unload_table_id drivers/acpi/namespace/nsxfobj.c
--- a/drivers/acpi/namespace/nsxfobj.c~add-support-for-acpi_load_table-acpi_unload_table_id
+++ a/drivers/acpi/namespace/nsxfobj.c
@@ -50,6 +50,50 @@ ACPI_MODULE_NAME("nsxfobj")
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_get_id
+ *
+ * PARAMETERS:  Handle          - Handle of object whose id is desired
+ *              ret_id          - Where the id will be placed
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: This routine returns the owner id associated with a handle
+ *
+ ******************************************************************************/
+acpi_status acpi_get_id(acpi_handle handle, acpi_owner_id * ret_id)
+{
+	struct acpi_namespace_node *node;
+	acpi_status status;
+
+	/* Parameter Validation */
+
+	if (!ret_id) {
+		return (AE_BAD_PARAMETER);
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status)) {
+		return (status);
+	}
+
+	/* Convert and validate the handle */
+
+	node = acpi_ns_map_handle_to_node(handle);
+	if (!node) {
+		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+		return (AE_BAD_PARAMETER);
+	}
+
+	*ret_id = node->owner_id;
+
+	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	return (status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_get_id)
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_get_type
  *
  * PARAMETERS:  Handle          - Handle of object whose type is desired
_

Patches currently in -mm which might be from jpk@sgi.com are

add-support-for-acpi_load_table-acpi_unload_table_id.patch
altix-acpi-ssdt-pci-device-support.patch
altix-add-acpi-ssdt-pci-device-support-hotplug.patch

