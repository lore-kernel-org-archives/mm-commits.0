From: akpm@linux-foundation.org
Subject: + mm-only-enforce-acpi-resource-conflict-checks.patch added to -mm tree
Date: Thu, 25 Oct 2007 13:00:24 -0700
Message-ID: <200710252000.l9PK0ODk019272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbXJYUBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 16:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, lenb@kernel.org, mhoffman@lightlink.com


The patch titled
     Enforce ACPI resource conflict checks
has been added to the -mm tree.  Its filename is
     mm-only-enforce-acpi-resource-conflict-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Enforce ACPI resource conflict checks
From: Jean Delvare <khali@linux-fr.org>

In -mm, enforce ACPI resource conflict checks, so that users will report
to us.

This patch is NOT meant to go to Linus at this point.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks
+++ a/drivers/acpi/osl.c
@@ -1076,7 +1076,7 @@ __setup("acpi_wake_gpes_always_on", acpi
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 
 static int __init acpi_enforce_resources_setup(char *str)
 {
_

Patches currently in -mm which might be from khali@linux-fr.org are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
provide-acpi_check_mem_region.patch
provide-acpi_check_mem_region-checkpatch-fixes.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-add-support-for-the-pcf8575-chip.patch
git-hwmon.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
