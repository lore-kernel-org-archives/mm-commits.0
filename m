From: akpm@linux-foundation.org
Subject: + acpi-busc-remove-doubled-status-checking.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:42:53 -0800
Message-ID: <200902242042.n1OKgrtX009474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbZBXUnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, lenb@kernel.org


The patch titled
     acpi: bus.c, remove doubled status checking
has been added to the -mm tree.  Its filename is
     acpi-busc-remove-doubled-status-checking.patch

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
Subject: acpi: bus.c, remove doubled status checking
From: Jiri Slaby <jirislaby@gmail.com>

There was a misplaced status test (two consequent tests without a
statement in between) in acpi_bus_init for ages.  Remove it, since the
function which should be checked (acpi_os_initialize1) has BUG_ONs on
failure paths.

On platforms with BUG_ON not being "noreturn", we panics elsewhere since
the function ever returns 0 anyway.

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
