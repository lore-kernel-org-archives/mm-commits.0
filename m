From: akpm@linux-foundation.org
Subject: + acpi_ibm_bay-can-not-coexist-with-acpi_bay.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:39 -0800
Message-ID: <200703151848.l2FImfSq023259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXCOSuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cw@f00f.org, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     ACPI_IBM_BAY can not coexist with ACPI_BAY
has been added to the -mm tree.  Its filename is
     acpi_ibm_bay-can-not-coexist-with-acpi_bay.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI_IBM_BAY can not coexist with ACPI_BAY
From: Chris Wedgwood <cw@f00f.org>

ACPI_IBM_BAY cannot coexist with ACPI_BAY --- it causes the IBM ACPI code
to fail to initialize so all the IBM ACPI functionality is missing.  The
simplest fix is to just make sure the Kconfig magic disallows ACPI_IBM_BAY
when ACPI_BAY is enabled.

Signed-off-by: Chris Wedgwood <cw@f00f.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/Kconfig~acpi_ibm_bay-can-not-coexist-with-acpi_bay drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi_ibm_bay-can-not-coexist-with-acpi_bay
+++ a/drivers/acpi/Kconfig
@@ -245,7 +245,7 @@ config ACPI_IBM_DOCK
 
 config ACPI_IBM_BAY
 	bool "Legacy Removable Bay Support"
-	depends on ACPI_IBM
+	depends on ACPI_IBM && !ACPI_BAY
 	default y
 	---help---
 	  Allows the ibm_acpi driver to handle removable bays.  It will allow
_

Patches currently in -mm which might be from cw@f00f.org are

acpi_ibm_bay-can-not-coexist-with-acpi_bay.patch
