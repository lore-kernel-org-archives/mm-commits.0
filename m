From: akpm@linux-foundation.org
Subject: + acpi-ec-fix-possible-double-io-port-registration.patch added to -mm tree
Date: Thu, 29 Jul 2010 13:12:46 -0700
Message-ID: <201007292012.o6TKCkl4031399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758154Ab0G2UN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 16:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, mjg@redhat.com


The patch titled
     acpi ec: fix possible double io port registration
has been added to the -mm tree.  Its filename is
     acpi-ec-fix-possible-double-io-port-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi ec: fix possible double io port registration
From: Thomas Renninger <trenn@suse.de>

Which will result in a harmless but ugly WARN message on some machines.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/ec.c~acpi-ec-fix-possible-double-io-port-registration drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-fix-possible-double-io-port-registration
+++ a/drivers/acpi/ec.c
@@ -811,6 +811,12 @@ static int acpi_ec_add(struct acpi_devic
 	if (!first_ec)
 		first_ec = ec;
 	device->driver_data = ec;
+
+	WARN(!request_region(ec->data_addr, 1, "EC data"),
+	     "Could not request EC data io port 0x%lx", ec->data_addr);
+	WARN(!request_region(ec->command_addr, 1, "EC cmd"),
+	     "Could not request EC cmd io port 0x%lx", ec->command_addr);
+
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
 
@@ -837,6 +843,8 @@ static int acpi_ec_remove(struct acpi_de
 		kfree(handler);
 	}
 	mutex_unlock(&ec->lock);
+	release_region(ec->data_addr, 1);
+	release_region(ec->command_addr, 1);
 	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
@@ -857,18 +865,10 @@ ec_parse_io_ports(struct acpi_resource *
 	 * the second address region returned is the status/command
 	 * port.
 	 */
-	if (ec->data_addr == 0) {
+	if (ec->data_addr == 0)
 		ec->data_addr = resource->data.io.minimum;
-		WARN(!request_region(ec->data_addr, 1, "EC data"),
-		     "Could not request EC data io port %lu",
-		     ec->data_addr);
-	}
-	else if (ec->command_addr == 0) {
+	else if (ec->command_addr == 0)
 		ec->command_addr = resource->data.io.minimum;
-		WARN(!request_region(ec->command_addr, 1, "EC command"),
-		     "Could not request EC command io port %lu",
-		     ec->command_addr);
-	}
 	else
 		return AE_CTRL_TERMINATE;
 
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
linux-next.patch
acpi-ec-fix-possible-double-io-port-registration.patch
acpi-ec_sys-be-more-cautious-about-ec-write-access.patch

