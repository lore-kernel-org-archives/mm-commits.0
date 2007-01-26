From: akpm@osdl.org
Subject: + fix-race-in-efi-variable-delete-code.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:00:34 -0800
Message-ID: <200701260600.l0Q60YPi008838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47210 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXAZGAo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Matt_Domsch@dell.com, prarit@redhat.com


The patch titled
     Fix race in efi variable delete code
has been added to the -mm tree.  Its filename is
     fix-race-in-efi-variable-delete-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race in efi variable delete code
From: Matt Domsch <Matt_Domsch@dell.com>

Fix race when deleting an EFI variable and issuing another EFI command on
the same variable.  The removal of the variable from the efivars_list
should be done in efivar_delete and not delayed until the kobject release.

Furthermore, remove the item from the list at module unload time, and use
list_for_each_entry_safe() rather than list_for_each_safe() for
readability.

Tested on ia64.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/firmware/efivars.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff -puN drivers/firmware/efivars.c~fix-race-in-efi-variable-delete-code drivers/firmware/efivars.c
--- a/drivers/firmware/efivars.c~fix-race-in-efi-variable-delete-code
+++ a/drivers/firmware/efivars.c
@@ -122,8 +122,6 @@ struct efivar_entry {
 	struct kobject kobj;
 };
 
-#define get_efivar_entry(n) list_entry(n, struct efivar_entry, list)
-
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -386,9 +384,6 @@ static struct sysfs_ops efivar_attr_ops 
 static void efivar_release(struct kobject *kobj)
 {
 	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
-	spin_lock(&efivars_lock);
-	list_del(&var->list);
-	spin_unlock(&efivars_lock);
 	kfree(var);
 }
 
@@ -430,9 +425,8 @@ static ssize_t
 efivar_create(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar = NULL;
+	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
-	struct list_head *pos, *n;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
 
@@ -444,8 +438,7 @@ efivar_create(struct subsystem *sub, con
 	/*
 	 * Does this variable already exist?
 	 */
-	list_for_each_safe(pos, n, &efivar_list) {
-		search_efivar = get_efivar_entry(pos);
+	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
 		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
 		strsize2 = utf8_strsize(new_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
@@ -490,9 +483,8 @@ static ssize_t
 efivar_delete(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivar_entry *search_efivar = NULL;
+	struct efivar_entry *search_efivar, *n;
 	unsigned long strsize1, strsize2;
-	struct list_head *pos, *n;
 	efi_status_t status = EFI_NOT_FOUND;
 	int found = 0;
 
@@ -504,8 +496,7 @@ efivar_delete(struct subsystem *sub, con
 	/*
 	 * Does this variable already exist?
 	 */
-	list_for_each_safe(pos, n, &efivar_list) {
-		search_efivar = get_efivar_entry(pos);
+	list_for_each_entry_safe(search_efivar, n, &efivar_list, list) {
 		strsize1 = utf8_strsize(search_efivar->var.VariableName, 1024);
 		strsize2 = utf8_strsize(del_var->VariableName, 1024);
 		if (strsize1 == strsize2 &&
@@ -537,9 +528,9 @@ efivar_delete(struct subsystem *sub, con
 		spin_unlock(&efivars_lock);
 		return -EIO;
 	}
+	list_del(&search_efivar->list);
 	/* We need to release this lock before unregistering. */
 	spin_unlock(&efivars_lock);
-
 	efivar_unregister(search_efivar);
 
 	/* It's dead Jim.... */
@@ -768,10 +759,14 @@ out_free:
 static void __exit
 efivars_exit(void)
 {
-	struct list_head *pos, *n;
+	struct efivar_entry *entry, *n;
 
-	list_for_each_safe(pos, n, &efivar_list)
-		efivar_unregister(get_efivar_entry(pos));
+	list_for_each_entry_safe(entry, n, &efivar_list, list) {
+		spin_lock(&efivars_lock);
+		list_del(&entry->list);
+		spin_unlock(&efivars_lock);
+		efivar_unregister(entry);
+	}
 
 	subsystem_unregister(&vars_subsys);
 	firmware_unregister(&efi_subsys);
_

Patches currently in -mm which might be from Matt_Domsch@dell.com are

fix-race-in-efi-variable-delete-code.patch
docbook-add-edd-firmware-interfaces.patch
