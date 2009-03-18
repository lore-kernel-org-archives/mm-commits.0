From: akpm@linux-foundation.org
Subject: [merged] acpi-busc-remove-doubled-status-checking.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:47:57 -0700
Message-ID: <200903182247.n2IMlvbc020241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbZCRWv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: bus.c, remove doubled status checking
has been removed from the -mm tree.  Its filename was
     acpi-busc-remove-doubled-status-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: bus.c, remove doubled status checking
From: Jiri Slaby <jirislaby@gmail.com>

There was a misplaced status test (two consequent tests without a
statement in between) in acpi_bus_init for ages.  Remove it, since the
function which should be checked (acpi_os_initialize1) has BUG_ONs on
failure paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/acpi/bus.c~acpi-busc-remove-doubled-status-checking drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~acpi-busc-remove-doubled-status-checking
+++ a/drivers/acpi/bus.c
@@ -758,8 +758,7 @@ static int __init acpi_bus_init(void)
 	acpi_status status = AE_OK;
 	extern acpi_status acpi_os_initialize1(void);
 
-
-	status = acpi_os_initialize1();
+	acpi_os_initialize1();
 
 	status =
 	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
@@ -769,12 +768,6 @@ static int __init acpi_bus_init(void)
 		goto error1;
 	}
 
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX
-		       "Unable to initialize ACPI OS objects\n");
-		goto error1;
-	}
