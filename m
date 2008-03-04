From: akpm@linux-foundation.org
Subject: + acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch added to -mm tree
Date: Tue, 04 Mar 2008 15:35:36 -0800
Message-ID: <200803042335.m24NZaBp003843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYCDXgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 18:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: astarikovskiy@suse.de, lenb@kernel.org


The patch titled
     ACPI: EC: Revert 208c70a45624400fafd7511b96bc426bf01f8f5e
has been added to the -mm tree.  Its filename is
     acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch

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
Subject: ACPI: EC: Revert 208c70a45624400fafd7511b96bc426bf01f8f5e
From: Alexey Starikovskiy <astarikovskiy@suse.de>

This patch for non-fatal error causes some fatal ones.  Just revert it and
find better solution for original problem.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/acpi/ec.c~acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e
+++ a/drivers/acpi/ec.c
@@ -943,11 +943,7 @@ int __init acpi_ec_ecdt_probe(void)
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
-		if (ACPI_FAILURE(acpi_get_handle(NULL, ecdt_ptr->id,
-				&boot_ec->handle))) {
-			pr_info("Failed to locate handle for boot EC\n");
-			boot_ec->handle = ACPI_ROOT_OBJECT;
-		}
+		boot_ec->handle = ACPI_ROOT_OBJECT;
 	} else {
 		/* This workaround is needed only on some broken machines,
 		 * which require early EC, but fail to provide ECDT */
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch

