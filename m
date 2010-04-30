From: akpm@linux-foundation.org
Subject: + drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:24 -0700
Message-ID: <201004301902.o3UJ2O47005928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933447Ab0D3TDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, lenb@kernel.org


The patch titled
     drivers: acpi: don't use own implementation of hex_to_bin()
has been added to the -mm tree.  Its filename is
     drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch

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
Subject: drivers: acpi: don't use own implementation of hex_to_bin()
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Remove own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/bus.c~drivers-acpi-dont-use-own-implementation-of-hex_to_bin drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~drivers-acpi-dont-use-own-implementation-of-hex_to_bin
+++ a/drivers/acpi/bus.c
@@ -394,11 +394,6 @@ static void acpi_print_osc_error(acpi_ha
 	printk("\n");
 }
 
-static u8 hex_val(unsigned char c)
-{
-	return isdigit(c) ? c - '0' : toupper(c) - 'A' + 10;
-}
-
 static acpi_status acpi_str_to_uuid(char *str, u8 *uuid)
 {
 	int i;
@@ -415,8 +410,8 @@ static acpi_status acpi_str_to_uuid(char
 			return AE_BAD_PARAMETER;
 	}
 	for (i = 0; i < 16; i++) {
-		uuid[i] = hex_val(str[opc_map_to_uuid[i]]) << 4;
-		uuid[i] |= hex_val(str[opc_map_to_uuid[i] + 1]);
+		uuid[i] = hex_to_bin(str[opc_map_to_uuid[i]]) << 4;
+		uuid[i] |= hex_to_bin(str[opc_map_to_uuid[i] + 1]);
 	}
 	return AE_OK;
 }
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
lib-introduce-common-method-to-convert-hex-digits.patch
drivers-isdn-use-new-hex_to_bin-method.patch
usb-atm-speedtch-use-new-hex_to_bin-method.patch
sysctl-dont-use-own-implementation-of-hex_to_bin.patch
staging-rt2860-use-new-hex_to_bin-method.patch
fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch
drivers-wireless-use-new-hex_to_bin-method.patch
drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch

