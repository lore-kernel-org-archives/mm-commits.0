From: akpm@linux-foundation.org
Subject: + firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch added to -mm tree
Date: Wed, 10 Jul 2013 14:34:42 -0700
Message-ID: <51ddd372.8ch58mfrct0+pf+Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3GJVen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jul 2013 17:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, jdelvare@suse.de

Subject: + firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch added to -mm tree
To: jdelvare@suse.de,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 10 Jul 2013 14:34:42 -0700


The patch titled
     Subject: firmware/dmi_scan: fix most checkpatch errors and warnings
has been added to the -mm tree.  Its filename is
     firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: firmware/dmi_scan: fix most checkpatch errors and warnings

Fix all errors and trivial warnings reported by checkpatch for file
drivers/firmware/dmi_scan.c.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   47 +++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings
+++ a/drivers/firmware/dmi_scan.c
@@ -63,7 +63,7 @@ static char * __init dmi_string(const st
 	if (str != NULL)
 		strcpy(str, bp);
 	else
-		printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
+		pr_err("dmi_string: cannot allocate %Zu bytes.\n", len);
 
 	return str;
 }
@@ -140,9 +140,10 @@ int dmi_available;
 /*
  *	Save a DMI string
  */
-static void __init dmi_save_ident(const struct dmi_header *dm, int slot, int string)
+static void __init dmi_save_ident(const struct dmi_header *dm, int slot,
+		int string)
 {
-	const char *d = (const char*) dm;
+	const char *d = (const char *) dm;
 	char *p;
 
 	if (dmi_ident[slot])
@@ -155,9 +156,10 @@ static void __init dmi_save_ident(const
 	dmi_ident[slot] = p;
 }
 
-static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_uuid(const struct dmi_header *dm, int slot,
+		int index)
 {
-	const u8 *d = (u8*) dm + index;
+	const u8 *d = (u8 *) dm + index;
 	char *s;
 	int is_ff = 1, is_00 = 1, i;
 
@@ -188,12 +190,13 @@ static void __init dmi_save_uuid(const s
 	else
 		sprintf(s, "%pUB", d);
 
-        dmi_ident[slot] = s;
+	dmi_ident[slot] = s;
 }
 
-static void __init dmi_save_type(const struct dmi_header *dm, int slot, int index)
+static void __init dmi_save_type(const struct dmi_header *dm, int slot,
+		int index)
 {
-	const u8 *d = (u8*) dm + index;
+	const u8 *d = (u8 *) dm + index;
 	char *s;
 
 	if (dmi_ident[slot])
@@ -217,7 +220,7 @@ static void __init dmi_save_one_device(i
 
 	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
 	if (!dev) {
-		printk(KERN_ERR "dmi_save_one_device: out of memory.\n");
+		pr_err("dmi_save_one_device: out of memory.\n");
 		return;
 	}
 
@@ -256,8 +259,7 @@ static void __init dmi_save_oem_strings_
 
 		dev = dmi_alloc(sizeof(*dev));
 		if (!dev) {
-			printk(KERN_ERR
-			   "dmi_save_oem_strings_devices: out of memory.\n");
+			pr_err("dmi_save_oem_strings_devices: out of memory.\n");
 			break;
 		}
 
@@ -272,11 +274,11 @@ static void __init dmi_save_oem_strings_
 static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 {
 	struct dmi_device *dev;
-	void * data;
+	void *data;
 
 	data = dmi_alloc(dm->length);
 	if (data == NULL) {
-		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
+		pr_err("dmi_save_ipmi_device: out of memory.\n");
 		return;
 	}
 
@@ -284,7 +286,7 @@ static void __init dmi_save_ipmi_device(
 
 	dev = dmi_alloc(sizeof(*dev));
 	if (!dev) {
-		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
+		pr_err("dmi_save_ipmi_device: out of memory.\n");
 		return;
 	}
 
@@ -302,7 +304,7 @@ static void __init dmi_save_dev_onboard(
 
 	onboard_dev = dmi_alloc(sizeof(*onboard_dev) + strlen(name) + 1);
 	if (!onboard_dev) {
-		printk(KERN_ERR "dmi_save_dev_onboard: out of memory.\n");
+		pr_err("dmi_save_dev_onboard: out of memory.\n");
 		return;
 	}
 	onboard_dev->instance = instance;
@@ -320,7 +322,7 @@ static void __init dmi_save_dev_onboard(
 
 static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 {
-	const u8 *d = (u8*) dm + 5;
+	const u8 *d = (u8 *) dm + 5;
 
 	/* Skip disabled device */
 	if ((*d & 0x80) == 0)
@@ -338,7 +340,7 @@ static void __init dmi_save_extended_dev
  */
 static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 {
-	switch(dm->type) {
+	switch (dm->type) {
 	case 0:		/* BIOS Information */
 		dmi_save_ident(dm, DMI_BIOS_VENDOR, 4);
 		dmi_save_ident(dm, DMI_BIOS_VERSION, 5);
@@ -502,8 +504,7 @@ void __init dmi_scan_machine(void)
 			dmi_available = 1;
 			goto out;
 		}
-	}
-	else {
+	} else {
 		p = dmi_ioremap(0xF0000, 0x10000);
 		if (p == NULL)
 			goto error;
@@ -528,7 +529,7 @@ void __init dmi_scan_machine(void)
 		dmi_iounmap(p, 0x10000);
 	}
  error:
-	printk(KERN_INFO "DMI not present or invalid.\n");
+	pr_info("DMI not present or invalid.\n");
  out:
 	dmi_initialized = 1;
 }
@@ -664,7 +665,7 @@ int dmi_name_in_serial(const char *str)
 
 /**
  *	dmi_name_in_vendors - Check if string is in the DMI system or board vendor name
- *	@str: 	Case sensitive Name
+ *	@str: Case sensitive Name
  */
 int dmi_name_in_vendors(const char *str)
 {
@@ -691,13 +692,13 @@ EXPORT_SYMBOL(dmi_name_in_vendors);
  *	A new search is initiated by passing %NULL as the @from argument.
  *	If @from is not %NULL, searches continue from next device.
  */
-const struct dmi_device * dmi_find_device(int type, const char *name,
+const struct dmi_device *dmi_find_device(int type, const char *name,
 				    const struct dmi_device *from)
 {
 	const struct list_head *head = from ? &from->list : &dmi_devices;
 	struct list_head *d;
 
-	for(d = head->next; d != &dmi_devices; d = d->next) {
+	for (d = head->next; d != &dmi_devices; d = d->next) {
 		const struct dmi_device *dev =
 			list_entry(d, struct dmi_device, list);
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch
dmi_scan-add-comments-on-dmi_present-and-the-loop-in-dmi_scan_machine.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch

