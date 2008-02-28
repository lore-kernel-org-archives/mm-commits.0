From: akpm@linux-foundation.org
Subject: + acpi-ec-fix-regression.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:32:03 -0800
Message-ID: <200802280332.m1S3W3SN013516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759781AbYB1DcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:32:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, len.brown@intel.com, m.s.tsirkin@gmail.com, rjw@sisk.pl


The patch titled
     ACPI: EC: fix regression
has been added to the -mm tree.  Its filename is
     acpi-ec-fix-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ACPI: EC: fix regression
From: Alexey Starikovskiy <astarikovskiy@suse.de>

no changelog?

Tested-by: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/ec.c~acpi-ec-fix-regression drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-fix-regression
+++ a/drivers/acpi/ec.c
@@ -129,7 +129,8 @@ static struct acpi_ec {
 	struct mutex lock;
 	wait_queue_head_t wait;
 	struct list_head list;
-	u8 handlers_installed;
+	u8 handlers_installed:1;
+	u8 from_ecdt:1;
 } *boot_ec, *first_ec;
 
 /* --------------------------------------------------------------------------
@@ -772,16 +773,18 @@ static int acpi_ec_add(struct acpi_devic
 
 	/* Check for boot EC */
 	if (boot_ec) {
-		if (boot_ec->handle == device->handle) {
-			/* Pre-loaded EC from DSDT, just move pointer */
-			ec = boot_ec;
-			boot_ec = NULL;
-			goto end;
-		} else if (boot_ec->handle == ACPI_ROOT_OBJECT) {
+		if (boot_ec->from_ecdt &&
+		    (boot_ec->handle == device->handle ||
+		     boot_ec->handle == ACPI_ROOT_OBJECT)) {
 			/* ECDT-based EC, time to shut it down */
 			ec_remove_handlers(boot_ec);
 			kfree(boot_ec);
 			first_ec = boot_ec = NULL;
+		} else if (boot_ec->handle == device->handle) {
+			/* Pre-loaded EC from DSDT, just move pointer */
+			ec = boot_ec;
+			boot_ec = NULL;
+			goto end;
 		}
 	}
 
@@ -943,6 +946,7 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
+		boot_ec->from_ecdt = 1;
 		if (ACPI_FAILURE(acpi_get_handle(NULL, ecdt_ptr->id,
 				&boot_ec->handle))) {
 			pr_info("Failed to locate handle for boot EC\n");
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

acpi-ec-fix-regression.patch
